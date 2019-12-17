//
//  CCChartViewBase.m
//  CCTrendCharts
//
//  核心基类, 提供坐标系, 参考系, 基本轴绘制, 基本手势等功能.
//
//  框架部分设计灵感来自Charts, 感谢.
//
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewBase.h"

@interface CCChartViewBase () <CALayerDelegate, UIScrollViewDelegate> {
    BOOL _needsPrepare;

    BOOL _needUpdateForRecentFirst;
    BOOL _needTriggerScrollGesture;
    // 标记是否首次显示
    BOOL _isFirstDisplay;

    // 记录 最后的手势平移值
    CGFloat _lastTx;
    // 记录 scroll最后的偏移量
    CGFloat _lastOffsetX;
    // 记录 最后一次更新数据源之前的数据总数
    NSInteger _lastXValsCount;

    NSInteger _longPressLastSelcIndex;

    CCSingleEventManager *_eventManager;
}

/**
 y轴图层
 */
@property (nonatomic, strong) CALayer *yAxisLayer;

/**
 x轴图层
 */
@property (nonatomic, strong) CALayer *xAxisLayer;

/**
 指示器图层
 */
@property (nonatomic, strong) CALayer *cursorLayer;

/// 标记图层
@property (nonatomic, strong) CALayer *markerLayer;

/// 图例图层
@property (nonatomic, strong) CALayer *legendLayer;

/**
 提供横向滚动功能
 */
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation CCChartViewBase
@synthesize xAxis                       = _xAxis;
@synthesize leftAxis                    = _leftAxis;
@synthesize rightAxis                   = _rightAxis;
@synthesize cursor                      = _cursor;
@synthesize viewPixelHandler            = _viewPixelHandler;
@synthesize transformer                 = _transformer;
@synthesize rightTransformer            = _rightTransformer;

// CCProtocolChartViewSync
@synthesize sync_pinchGesutreEnable     = _pinchGesutreEnable;
@synthesize sync_panGesutreEnable       = _panGesutreEnable;
@synthesize sync_longPressGesutreEnable = _longPressGesutreEnable;
@synthesize sync_pinchObservable        = _pinchObservable;
@synthesize sync_panObservable          = _sync_panObservable;
@synthesize sync_longPressObservable    = _longPressObservable;

// 渲染组件变量由子类合成
@dynamic dataRenderer;
@dynamic leftAxisRenderer;
@dynamic rightAxisRenderer;
@dynamic xAxisRenderer;
@dynamic markerRenderer;
@dynamic cursorRenderer;
@dynamic legendRenderer;

@dynamic chartMinX;
@dynamic chartMaxX;
@dynamic chartMinY;
@dynamic chartMaxY;
@dynamic lowestVisibleXIndex;
@dynamic highestVisibleXIndex;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pinchGesutreEnable     = YES;
        _panGesutreEnable       = YES;
        _longPressGesutreEnable = YES;

        _eventManager               = [[CCSingleEventManager alloc] init];

        _scrollView                 = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.delegate        = self;
        _scrollView.backgroundColor = UIColor.clearColor;

        _viewPixelHandler           = [[CCChartViewPixelHandler alloc] init];

        _transformer                = [[CCChartTransformer alloc] initWithViewPixelHandler:_viewPixelHandler];
        _rightTransformer           = [[CCChartTransformer alloc] initWithViewPixelHandler:_viewPixelHandler];

        _gestureHandler             = [[CCGestureDefaultHandler alloc] initWithTransformer:_viewPixelHandler];
        _gestureHandler.baseView    = self;
        _gestureHandler.delegate    = self;

        _clipEdgeInsets             = UIEdgeInsetsMake(8, 8, 8, 8);

        _recentFirst                = YES;
        _needUpdateForRecentFirst   = YES;
        _needTriggerScrollGesture   = YES;
        _lastTx = 0.f;
        _lastOffsetX                = 0.f;

        _isFirstDisplay             = YES;
    }
    return self;
}

- (NSString *)description {
    NSString *desc = [super description];
    return [NSString stringWithFormat:@"%@ --- %@", desc, [NSString stringWithFormat:@"%p", &_leftAxis]];
}

- (void)layoutSubviews {
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.scrollView.frame  = frame;

    [self addSubview:_scrollView];

    self.yAxisLayer.frame  = frame;
    self.xAxisLayer.frame  = frame;
    self.cursorLayer.frame = frame;
    self.markerLayer.frame = frame;
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)rect {
    [super setNeedsDisplayInRect:rect];
}

#pragma mark - Getter & Setter
- (CALayer *)yAxisLayer {
    if (!_yAxisLayer) {
        _yAxisLayer = CALayer.layer;

        // Y轴渲染层放到所有图层的底部
        [self.layer addSublayer:_yAxisLayer];
    }

    return _yAxisLayer;
}

- (CALayer *)xAxisLayer {
    if (!_xAxisLayer) {
        _xAxisLayer = CALayer.layer;

        // X轴渲染层放到滚动视图的最下层, 这样做是方便x轴上元素的滚动
        [self.layer addSublayer:_xAxisLayer];
    }

    return _xAxisLayer;
}

- (CALayer *)cursorLayer {
    if (!_cursorLayer) {
        _cursorLayer = CALayer.layer;
        _cursorLayer.zPosition = 888;
        [self.layer addSublayer:_cursorLayer];
    }

    return _cursorLayer;
}

- (CALayer *)markerLayer {
    if (!_markerLayer) {
        _markerLayer = CALayer.layer;
        _markerLayer.zPosition = 999;
        [self.layer addSublayer:_markerLayer];
    }
    return _markerLayer;
}

- (CALayer *)legendLayer {
    if (!_legendLayer) {
        _legendLayer = CALayer.layer;
        _legendLayer.zPosition = 999;
        [self.layer addSublayer:_legendLayer];
    }
    return _legendLayer;
}

- (void)setSync_panGesutreEnable:(BOOL)sync_panGesutreEnable {
    _panGesutreEnable = sync_panGesutreEnable;
    self.scrollView.scrollEnabled = _panGesutreEnable;
}

- (void)setSync_pinchGesutreEnable:(BOOL)sync_pinchGesutreEnable {
    _pinchGesutreEnable = sync_pinchGesutreEnable;
    self.gestureHandler.pinchGesture.enabled = _pinchGesutreEnable;
}

- (void)setSync_longPressGesutreEnable:(BOOL)sync_longPressGesutreEnable {
    _longPressGesutreEnable = sync_longPressGesutreEnable;
    self.gestureHandler.longPressGesture.enabled = _longPressGesutreEnable;
}

- (void)setLeftAxis:(CCDefaultYAxis *)leftAxis {
    _leftAxis = leftAxis;

    self.cursorRenderer.leftAxis = leftAxis;
    self.leftAxisRenderer.axis = leftAxis;
}

- (void)setRightAxis:(CCDefaultYAxis *)rightAxis {
    _rightAxis = rightAxis;

    self.cursorRenderer.rightAxis = rightAxis;
    self.rightAxisRenderer.axis = rightAxis;
}

- (void)setXAxis:(CCDefaultXAxis *)xAxis {
    _xAxis = xAxis;

    self.cursorRenderer.xAxis = xAxis;
    self.xAxisRenderer.axis = xAxis;
}

- (void)setIndicatorStyle:(UIScrollViewIndicatorStyle)indicatorStyle {
    self.scrollView.indicatorStyle = indicatorStyle;
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator {
    self.scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}

- (BOOL)showsHorizontalScrollIndicator {
    return self.scrollView.showsHorizontalScrollIndicator;
}

#pragma mark - Scroll-func

- (void)_setScrollViewXOffset:(CGFloat)chartTX {
    self.scrollView.contentOffset = CGPointMake(chartTX, 0);
}

#pragma mark - Non-SYS-func
/// scroll view的滚动区间大小, 决定了渲染区域的横向大小
- (void)_updateScrollContent {
    // 滚动区间大小计算公式:
    // 滚动视图内容宽度 = 绘制总长度 - 绘制区间宽度 + 滚动视图宽度
    // 这里需要特别说明totalWidth变量的由来, 假设边缘值都是0
    //
    //      | -- | -- | -- |
    //
    // 如上图, "|"表示一个轴, count=4, 它的总长度其实就是3个线段的大小相加, 所以distanceBetweenSpace函数的参数值是(count-1)
    // 此时左右边缘两个实体的轴分别贴到左右Y轴上.

    CGFloat totalWidth     = fabs([self.transformer distanceBetweenSpace:self.data.xVals.count - 1 + self.xAxis.startMargin + self.xAxis.endMargin]);

    CGFloat needExtraWidth = totalWidth - self.viewPixelHandler.contentWidth;
    self.scrollView.contentSize = CGSizeMake(needExtraWidth + self.bounds.size.width, 0);
}

- (void)_updateViewPixelHandler {
    self.viewPixelHandler.viewFrame   = self.bounds;
    self.viewPixelHandler.contentRect = CGRectClipRectUsingEdge(self.bounds, self.clipEdgeInsets);
}

///  计算view handle的初始矩阵
- (void)_calcViewPixelInitMatrix {
    // 如果视图属于最近信息优先显示的话, 还需要调整初始矩阵, 让最后一个元素在绘制区间里
    // 当前正在进行手势操作的, 表示正在浏览数据, 所以不应该重新计算手势矩阵了
    if (self.recentFirst) {
        if (![self.viewPixelHandler isGestureProcessing]) {
            CGFloat totalWidth     = fabs([self.transformer distanceBetweenSpace:self.data.xVals.count - 1 + self.xAxis.startMargin + self.xAxis.endMargin]);

            CGFloat needExtraWidth = totalWidth - self.viewPixelHandler.contentWidth;

            // recentFirst模式下, 初始矩阵的偏移量和scrollview的偏移量是不同步的, 所以需要重新更新一下lastTx
            self.viewPixelHandler.anInitMatrix = CGAffineTransformMakeTranslation(self.viewPixelHandler.contentWidth, 0);
            _lastTx      =  self.viewPixelHandler.gestureMatrix.tx;
            _lastOffsetX = needExtraWidth;

            _needTriggerScrollGesture = NO;
            [self _setScrollViewXOffset:needExtraWidth];
            _needTriggerScrollGesture = YES;

            // 当数据源太少时, 总宽度比可绘制的内容宽度都小, 这里会得到一个负数
            // 为了让视图实体靠左显示, 这里需要另外把scrollview的offset调整为0
            if (needExtraWidth < 0) {
                [self.scrollView setContentOffset:CGPointZero animated:NO];
            }
        } else {
            // 处于手势操作中的视图, 数据源变动之后, 需要动态调整scrollview 的 offset
            // 这里只需要知道实体的增量即可
            CGFloat incrementWidth = fabs([self.transformer distanceBetweenSpace:self.data.xVals.count - _lastXValsCount]);

            _needTriggerScrollGesture = NO;
            [self _setScrollViewXOffset:self.scrollView.contentOffset.x + incrementWidth];
            _needTriggerScrollGesture = YES;
            _lastOffsetX = self.scrollView.contentOffset.x;
        }
    } else {
        // 触发一次滚动代理事件, 计算出正确的y轴信息
        [self scrollViewDidScroll:self.scrollView];
    }
}

/// 重新计算x,y轴的位置信息. 两个轴的位置和轴文案是紧密相关的.
- (void)_calcviewPixelHandlerOffset {
    // 先恢复ViewPixel的初始值
    [self _updateViewPixelHandler];

    CGFloat offsetLeft = 0, offsetRight = 0, offsetTop = 0, offsetBottom = 0;

    CGSize size;
    if (self.leftAxis) {
        size = self.leftAxis.requireSize;
        // 取得左侧y轴文案的最长宽度, 作为绘制区域的左边的额外距离
        if (self.leftAxis.labelPosition == CCYAxisLabelPositionOutside) {
            offsetLeft = size.width;
        } else if (self.leftAxis.labelPosition == CCYAxisLabelPositionInside) {
            offsetLeft = 0;
        }
    }

    if (self.rightAxis) {
        size = self.rightAxis.requireSize;

        if (self.rightAxis.labelPosition == CCYAxisLabelPositionOutside) {
            offsetRight = size.width;
        } else if (self.rightAxis.labelPosition == CCYAxisLabelPositionInside) {
            offsetRight = 0;
        }
    }

    size         = self.xAxis.requireSize;
    offsetBottom = size.height;

    [self.viewPixelHandler updateContentRectOffsetLeft:offsetLeft offsetRight:offsetRight offsetTop:offsetTop offsetBottom:offsetBottom];
}

- (void)_updateStandardMatrix {
    CGAffineTransform transform = CGAffineTransformIdentity;

    if (self.leftAxis) {
        transform = [self.transformer calcMatrixWithMinValue:self.leftAxis.axisMinValue maxValue:self.leftAxis.axisMaxValue startMargin:self.xAxis.startMargin xSpace:self.xAxis.xSpace rentFirst:self.recentFirst];
        [self.transformer refreshMatrix:transform];
    }

    if (self.rightAxis) {
        transform = [self.transformer calcMatrixWithMinValue:self.rightAxis.axisMinValue maxValue:self.rightAxis.axisMaxValue startMargin:self.xAxis.startMargin xSpace:self.xAxis.xSpace rentFirst:self.recentFirst];
        [self.rightTransformer refreshMatrix:transform];
    }
}

- (void)_updateOffsetMatrix {
    CGAffineTransform transform = CGAffineTransformIdentity;

    // 计算偏差矩阵
    transform = CGAffineTransformMakeTranslation(self.viewPixelHandler.offsetLeft, self.viewPixelHandler.viewHeight - self.viewPixelHandler.offsetBottom);
    [self.transformer refreshOffsetMatrix:transform];
    [self.rightTransformer refreshOffsetMatrix:transform];
}

- (void)_calcYAxisMinMax {
    if (self.leftAxis) {
        [self.leftAxis calculateMinMax:self.data];
    }

    if (self.rightAxis) {
        [self.rightAxis calculateMinMax:self.data];
    }
}

- (void)_calcXAxis {
    if (self.xAxis.autoXSapce) {
        if (self.xAxis.totalCount != 0) {
            // 实体个数n, 则实体中心轴总距离是 (n-1) * space, 所以单个距离是self.viewPixelHandler.contentWidth / (n-1) * space
            self.xAxis.xSpace = self.viewPixelHandler.contentWidth / (self.xAxis.totalCount + self.xAxis.startMargin + self.xAxis.endMargin - 1);
        } else {
            self.xAxis.xSpace = self.viewPixelHandler.contentWidth / (self.xAxis.entities.count + self.xAxis.startMargin + self.xAxis.endMargin - 1);
        }
    }
}

/// 根据当前可见区域, 更新y轴上的内容
- (void)_updateViewYAxisContent {
    [self.data calcMinMaxStart:self.lowestVisibleXIndex End:self.highestVisibleXIndex];
    [self _calcYAxisMinMax];
    [self _updateStandardMatrix];
}

- (void)setNeedsPrepareChart {
    _needsPrepare = YES;
    [self setNeedsDisplay];
}

- (void)prepareChart {
    _lastXValsCount = self.data.xVals.count;

    // 基类只是简单设置数据状态
    _needsPrepare   = NO;
    if (self.dataSource == nil) {
        @throw [NSException exceptionWithName:@"DataSource is nil" reason:@"CCChartViewDataSource can't no be nil" userInfo:nil];
    }

    self.data       = [self.dataSource chartDataInView:self];

    // 这里是为了让后面y轴文案能得到全部数据的最大最小值, 方便_calcViewPixelOffset一次性计算出一个合适值
    [self.data calcMinMaxStart:self.data.minX End:self.data.maxX];

    // 将数据集的数据同步到X轴上
    if (self.data.xVals.count) {
        self.xAxis.entities = self.data.xVals;
    } else {
        return;
    }

    // 计算出y轴上需要绘制的信息
    [self _calcYAxisMinMax];

    // 全部数据计算好之后, 重新调整一下绘制区域的大小
    [self _calcviewPixelHandlerOffset];

    // 确定一下X轴需要更新的信息
    [self _calcXAxis];

    // 根据新的绘制区域,重新计算反射参数
    [self _updateStandardMatrix];
    [self _updateOffsetMatrix];

    // 根据当前数据集, 设置好滚动区域长度
    if (_isFirstDisplay) {
        // _isFirstDisplay为YES的情况包括调用了resetViewGesture方法, 这个时候不需要重复处理滚动手势了.
        _needTriggerScrollGesture = NO;
        [self _updateScrollContent];
        _needTriggerScrollGesture = YES;
    } else {
        [self _updateScrollContent];
    }

    // 确定好绘制的内容和滚动区域一起同步偏移的量, 完成同步滚动.
    [self _calcViewPixelInitMatrix];

    [self _updateViewYAxisContent];
}

- (void)resetViewGesture {
    [self.viewPixelHandler resetGestureMatrix];
    // 重置标志
    _isFirstDisplay = YES;
}

- (void)dataRendering {
    // 不做任何事
}

#pragma mark - CALayerDelegate
- (void)displayLayer:(CALayer *)layer {
    if (_needsPrepare) {
        [self prepareChart];
        _needsPrepare = NO;
    }

    self.layer.backgroundColor = self.backgroundColor.CGColor;

    if (CGSizeEqualToSize(self.viewPixelHandler.viewFrame.size, CGSizeZero)) {
        return;
    }

    UIGraphicsBeginImageContextWithOptions(self.viewPixelHandler.viewFrame.size, NO, 0);

    [self.leftAxisRenderer beginRenderingInLayer:self.yAxisLayer];
    [self.rightAxisRenderer beginRenderingInLayer:self.yAxisLayer];

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // 这里后续可以优化, 毕竟使用Clear的效率还没有直接创建一个新画图高..
    CGContextClearRect(ctx, CGContextGetClipBoundingBox(ctx));

    [self.xAxisRenderer beginRenderingInLayer:self.xAxisLayer];

    UIGraphicsEndImageContext();

    // 单独渲染数据层
    [self dataRendering];

    if (_isFirstDisplay) {
        [self.legendRenderer beginRenderingInLayer:self.legendLayer atIndex:0];
    }
    _isFirstDisplay = NO;
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    NSLog(@"drawRect");
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_needTriggerScrollGesture) {
        return;
    }
    [self.gestureHandler didScrollIncrementOffsetX:scrollView.contentOffset.x - _lastOffsetX];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.sync_panObservable = NSNull.null;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.sync_panObservable = NSNull.null;
    }
}

#pragma mark - Gesture-func
- (void)addDefualtGesture {
    // 指示器反馈
    [self addGestureRecognizer:self.gestureHandler.pinchGesture];
    [self addGestureRecognizer:self.gestureHandler.longPressGesture];
}

#pragma mark - CCGestureHandlerDelegate
- (void)gestureDidPanIncrementOffset:(CGPoint)point matrix:(CGAffineTransform)matrix {
    _lastOffsetX = self.scrollView.contentOffset.x;
    _lastTx      =  self.viewPixelHandler.gestureMatrix.tx;

    [self _updateViewYAxisContent];

    [self setNeedsDisplay];

    // 该属性为NO时, 意味着当前滚动事件是从其他视图传递过来的, 所以直接返回即可.
    if (self.sync_panGesutreEnable) {
        // 检查到边缘时, 通知代理期望获取下一页数据.
        if (self.recentFirst) {
            if (self.scrollView.contentOffset.x <= 0) {
                if ([self.delegate respondsToSelector:@selector(chartViewExpectLoadNextPage:eventManager:)]) {
                    [_eventManager newEventWithBlock:^{
                        [self->_delegate chartViewExpectLoadNextPage:self eventManager:self->_eventManager];
                    }];
                }
            }
        } else {
            if (self.scrollView.contentOffset.x + self.scrollView.bounds.size.width > self.scrollView.contentSize.width) {
                if ([self.delegate respondsToSelector:@selector(chartViewExpectLoadNextPage:eventManager:)]) {
                    [_eventManager newEventWithBlock:^{
                        [self->_delegate chartViewExpectLoadNextPage:self eventManager:self->_eventManager];
                    }];
                }
            }
        }

        self.sync_panObservable = [NSValue valueWithCGPoint:self.scrollView.contentOffset];
    }
}

- (void)gestureDidPinchInLocation:(CGPoint)point matrix:(CGAffineTransform)matrix {
    CGPoint offset = self.scrollView.contentOffset;
    if (self.recentFirst) {
        /*
         这里其实有一个参考系问题, 我们参考的是index=0的实体偏移值, 普通模式下, index=0的实体在最左侧, 放大时tx其实是负数(因为index向左移动了);
         如果是recentFirst模式, index=0的实体是在最右边, 放大时tx代表右移的值, 不能直接调整scrollview的offset, 需要另外计算出实体向左的偏移量.
         公式如下:
         实体左移值 = 滚动宽度变化值 - 实体右移值
         offsetX = offsetX + 实体左移值
         */
        static CGFloat widthChange;
        widthChange = self.scrollView.contentSize.width;

        // 缩小操作会触发scrollViewDidScroll, 为了避免干扰计算这里先把_needTriggerScrollGesture设置为NO
        _needTriggerScrollGesture = NO;
        [self _updateScrollContent];
        _needTriggerScrollGesture = YES;

        // 得到总长度变化了多少
        widthChange = self.scrollView.contentSize.width - widthChange;

        CGFloat txchange   = self.viewPixelHandler.gestureMatrix.tx - _lastTx;

        // 左侧增量
        CGFloat leftChange = widthChange - txchange;
        offset.x += leftChange;
    } else {
        _needTriggerScrollGesture = NO;
        [self _updateScrollContent];
        _needTriggerScrollGesture = YES;

        // 计算出缩放之后内容整体平移了多少, 同步scroll view的contentOffset
        CGFloat tx = self.viewPixelHandler.gestureMatrix.tx - _lastTx;

        // 我们参考的是index=0的实体偏移值, 普通模式下, index=0的实体在最左侧, 放大时tx其实是负数(因为index0向左移动了);
        // 实体向左移动, offset需要变大, 所以最后结果就是 -= tx
        offset.x -= tx;
    }

    _needTriggerScrollGesture = NO;
    [self.scrollView setContentOffset:offset animated:NO];
    _needTriggerScrollGesture = YES;

    _lastOffsetX = offset.x;
    _lastTx      =  self.viewPixelHandler.gestureMatrix.tx;

    [self _updateViewYAxisContent];
    [self setNeedsDisplay];

    if (self.sync_pinchGesutreEnable) {
        self.sync_pinchObservable = [NSValue valueWithCGAffineTransform:self.viewPixelHandler.gestureMatrix];
    }
}

- (void)gestureDidEndPinchInLocation:(CGPoint)point matrix:(CGAffineTransform)matrix {
    // 检查缩放之后scrollview的状态, 如果contentOffset出现过度设置的话, 需要纠正
    if (self.scrollView.contentOffset.x < 0) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        // 有一种情况, 当数据源太少时, 进行放大操作, 会出现左侧超过左边界, 右侧还没到右边界
        // 这时候, 如果直接让右侧靠近右边界的话, 则左侧远离左边界, 这是不符合要求的.
        // 这里需要特殊处理(注意这里self.scrollView.contentSize就是实体的实际宽度)
        if (self.scrollView.contentSize.width < self.scrollView.bounds.size.width) {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        } else {
            if (self.scrollView.contentSize.width < (self.scrollView.contentOffset.x + self.scrollView.bounds.size.width)) {
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.scrollView.bounds.size.width, 0) animated:YES];
            }
        }
    }

    if (self.sync_pinchGesutreEnable) {
        self.sync_pinchObservable = NSNull.null;
    }
}

- (void)gestureDidLongPressInLocation:(CGPoint)point {
    UIGraphicsBeginImageContextWithOptions(self.viewPixelHandler.viewFrame.size, NO, 0);
    [self.cursorRenderer beginRenderingInLayer:self.cursorLayer center:point];

    CGPoint valuePoint = [self.transformer pixelToPoint:CGPointMake(point.x, 0) forAnimationPhaseY:1];

    // 某个对应的实体只连续触发最多1次
    if ((NSInteger)valuePoint.x != _longPressLastSelcIndex) {
        _longPressLastSelcIndex = (NSInteger)valuePoint.x;

        // 添加了震动效果
        if (self.cursor.impactFeedback) {
            if (@available(iOS 13.0, *)) {
                [self.cursor.impactFeedback impactOccurredWithIntensity:self.cursor.intensity];
            } else {
                // Fallback on earlier versions
                [self.cursor.impactFeedback impactOccurred];
            }
        }

        // 绘制标记
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextClearRect(ctx, CGContextGetClipBoundingBox(ctx));
        [self.markerRenderer beginRenderingInLayer:self.markerLayer atIndex:valuePoint.x];

        [self.legendRenderer beginRenderingInLayer:self.legendLayer atIndex:valuePoint.x];

        if ([self.delegate respondsToSelector:@selector(charViewDidLongPressAtIndex:)]) {
            [self.delegate charViewDidLongPressAtIndex:_longPressLastSelcIndex];
        }
    }

    // 处理同步事件
    // 这里需要把点转换成父视图的坐标系
    if (self.sync_longPressGesutreEnable) {
        self.sync_longPressObservable = [NSValue valueWithCGPoint:[self.superview convertPoint:point fromView:self]];
    }

    UIGraphicsEndImageContext();
}

- (void)gestureDidEndLongPressInLocation:(CGPoint)point {
    // 简单演示, 几秒后移除图层即可
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.cursorLayer removeFromSuperlayer];
        self.cursorLayer = nil;
        [self.markerLayer removeFromSuperlayer];
        self.markerLayer = nil;

        [self.legendRenderer beginRenderingInLayer:self.legendLayer atIndex:0];
    });

    if (self.sync_longPressGesutreEnable) {
        self.sync_longPressObservable = NSNull.null;
    }
}

#pragma mark - CCProtocolChartViewSync
- (void)chartViewSyncForPan:(id)panEvent {
    // 该方法被调用时, 说明滚动是从其他组成员传递过来的, 所以自身暂时禁用滚动手势, 这样也可以避免事件又从这里重复传递给其他人
    self.sync_panGesutreEnable = NO;
    [self.scrollView setContentOffset:[((NSValue *)panEvent) CGPointValue] animated:NO];
}

- (void)chartViewSyncEndForPan {
    self.sync_panGesutreEnable = YES;
}

- (void)chartViewSyncForPinch:(id)pinchEvent {
    self.sync_pinchGesutreEnable        = NO;
    self.viewPixelHandler.gestureMatrix = [(NSValue *)pinchEvent CGAffineTransformValue];
    // location参数暂时没用到, 直接传0
    [self gestureDidPinchInLocation:CGPointZero matrix:self.viewPixelHandler.gestureMatrix];
    self.sync_pinchGesutreEnable        = YES;
}

- (void)chartViewSyncEndForPinch {
    self.sync_pinchGesutreEnable = NO;
    [self gestureDidEndPinchInLocation:CGPointZero matrix:self.viewPixelHandler.gestureMatrix];
    self.sync_pinchGesutreEnable = YES;
}

- (void)chartViewSyncForLongPress:(id)longPressEvent {
    self.sync_longPressGesutreEnable = NO;
    CGPoint point = [(NSValue *)longPressEvent CGPointValue];
    [self gestureDidLongPressInLocation:[self convertPoint:point fromView:self.superview]];
    self.sync_longPressGesutreEnable = YES;
}

- (void)chartViewSyncEndForLongPress {
    self.sync_longPressGesutreEnable = NO;
    [self gestureDidEndLongPressInLocation:CGPointZero];
    self.sync_longPressGesutreEnable = YES;
}

#pragma mark - CCProtocolChartDataProvider

- (CGFloat)chartMinY {
    return self.leftAxis.axisMinValue;
}

- (CGFloat)chartMaxY {
    return self.leftAxis.axisMaxValue;
}

- (NSInteger)lowestVisibleXIndex {
    if (self.recentFirst) {
        CGPoint point = CGPointMake(self.viewPixelHandler.contentRight, self.viewPixelHandler.contentBottom);
        point = [self.transformer pixelToPoint:point forAnimationPhaseY:1];

        // 最小的索引是0
        if (point.x <= 0) {
            return 0;
        }
        return ceil(point.x);
    } else {
        CGPoint point = CGPointMake(self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentBottom);
        point = [self.transformer pixelToPoint:point forAnimationPhaseY:1];

        // 最小的索引是0
        if (point.x <= 0) {
            return 0;
        }
        return ceil(point.x);
    }
}

- (NSInteger)highestVisibleXIndex {
    if (self.recentFirst) {
        CGPoint point   = CGPointMake(self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentBottom);
        point = [self.transformer pixelToPoint:point forAnimationPhaseY:1];

        // 最大可见的索引不会大于数据源最大索引
        NSInteger index = floor(point.x);

        return MIN(self.data.xVals.count, index);
    } else {
        CGPoint point   = CGPointMake(self.viewPixelHandler.contentRight, self.viewPixelHandler.contentBottom);
        point = [self.transformer pixelToPoint:point forAnimationPhaseY:1];

        // 最大可见的索引不会大于数据源最大索引
        NSInteger index = floor(point.x);

        return MIN(self.data.xVals.count, index);
    }
}

@end
