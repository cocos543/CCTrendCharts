//
//  CCChartViewBase.m
//  CCTrendCharts
//
//  核心基类, 提供坐标系, 参考系, 基本轴绘制, 基本手势等功能
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewBase.h"

@interface CCChartViewBase () <CALayerDelegate, UIScrollViewDelegate, CCGestureHandlerDelegate> {
    BOOL _needsPrepare;

    BOOL _needUpdateForRecentFirst;
    BOOL _needTriggerScrollGesture;

    // 记录 最后的手势平移值
    CGFloat _lastTx;
    // 记录 scroll最后的偏移量
    CGFloat _lastOffsetX;
    // 记录 最后一次更新数据源之前的数据总数
    NSInteger _lastXValsCount;
    
    NSInteger _longPressLastSelcIndex;
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
 高亮图层
 */
@property (nonatomic, strong) CAShapeLayer *highlightLayer;

/**
 指示器图层
 */
@property (nonatomic, strong) CALayer *cursorLayer;


/// 标记图层
@property (nonatomic, strong) CALayer *markerLayer;

/**
 提供横向滚动功能
 */
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation CCChartViewBase
@synthesize xAxis            = _xAxis;
@synthesize leftAxis         = _leftAxis;
@synthesize rightAxis        = _rightAxis;
@synthesize cursor           = _cursor;
@synthesize viewPixelHandler = _viewPixelHandler;
@synthesize transformer      = _transformer;
@synthesize rightTransformer = _rightTransformer;

// 渲染组件变量由子类合成
@dynamic renderer;
@dynamic leftAxisRenderer;
@dynamic rightAxisRenderer;
@dynamic xAxisRenderer;
@dynamic markerRenderer;
@dynamic cursorRenderer;

@dynamic chartMinX;
@dynamic chartMaxX;
@dynamic chartMinY;
@dynamic chartMaxY;
@dynamic lowestVisibleXIndex;
@dynamic highestVisibleXIndex;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.delegate                = self;
        _scrollView.backgroundColor         = UIColor.clearColor;

        UIPanGestureRecognizer *twoFingerPan = [[UIPanGestureRecognizer alloc] init];
        twoFingerPan.minimumNumberOfTouches = 2;
        twoFingerPan.maximumNumberOfTouches = 2;
        [_scrollView addGestureRecognizer:twoFingerPan];

        _viewPixelHandler         = [[CCChartViewPixelHandler alloc] init];

        _transformer              = [[CCChartTransformer alloc] initWithViewPixelHandler:_viewPixelHandler];
        _rightTransformer         = [[CCChartTransformer alloc] initWithViewPixelHandler:_viewPixelHandler];

        _gestureHandler           = [[CCGestureDefaultHandler alloc] initWithTransformer:_viewPixelHandler];
        _gestureHandler.baseView  = self;
        _gestureHandler.delegate  = self;

        _clipEdgeInsets           = UIEdgeInsetsMake(8, 8, 8, 8);

        _recentFirst              = YES;
        _needUpdateForRecentFirst = YES;
        _needTriggerScrollGesture = YES;
        _lastTx = 0.f;
        _lastOffsetX              = 0.f;
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (NSString *)description {
    NSString *desc = [super description];
    return [NSString stringWithFormat:@"%@ --- %@", desc, [NSString stringWithFormat:@"%p", &_leftAxis]];
}

- (void)layoutSubviews {
    NSLog(@"layoutSubviews");

    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.scrollView.frame = frame;
    [self addSubview:_scrollView];

    UILabel *l   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    l.text = @"testtets";
    [self.scrollView addSubview:l];

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

#pragma mark - Scroll-func

- (void)_setScrollViewXOffset:(CGFloat)chartTX {
    self.scrollView.contentOffset = CGPointMake(chartTX, 0);
}

#pragma mark - Non-SYS-func
/// scroll view的滚动区间大小, 决定了渲染区域的横向大小
- (void)_updateScrollContent {
    // 滚动区间大小计算公式:
    // 滚动视图内容宽度 = 绘制总长度 - 绘制区间宽度 + 滚动视图宽度
    CGFloat totalWidth     = fabs([self.transformer distanceBetweenSpace:self.data.xVals.count]);
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
            CGFloat totalWidth     = fabs([self.transformer distanceBetweenSpace:self.data.xVals.count]);
            CGFloat needExtraWidth = totalWidth - self.viewPixelHandler.contentWidth;

            // recentFirst模式下, 初始矩阵的偏移量和scrollview的偏移量是不同步的, 所以需要重新更新一下lastTx
            self.viewPixelHandler.anInitMatrix = CGAffineTransformMakeTranslation(self.viewPixelHandler.contentWidth, 0);
            _lastTx      =  self.viewPixelHandler.gestureMatrix.tx;
            _lastOffsetX = needExtraWidth;

            _needTriggerScrollGesture = NO;
            [self _setScrollViewXOffset:needExtraWidth];
            _needTriggerScrollGesture = YES;
        } else {
            // 处于手势操作中的视图, 数据源变动之后, 需要动态调整scrollview 的 offset
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
- (void)_calcViewPixelOffset {
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
    // 暂时只处理左轴
    CGAffineTransform transform = CGAffineTransformIdentity;

    if (self.leftAxis) {
        transform = [self.transformer calcMatrixWithMinValue:self.leftAxis.axisMinValue maxValue:self.leftAxis.axisMaxValue xSpace:self.data.xSpace rentFirst:self.recentFirst];
        [self.transformer refreshMatrix:transform];
    }

    if (self.rightAxis) {
        transform = [self.transformer calcMatrixWithMinValue:self.rightAxis.axisMinValue maxValue:self.rightAxis.axisMaxValue xSpace:self.data.xSpace rentFirst:self.recentFirst];
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
        if (!self.leftAxis.customValue) {
            [self.leftAxis calculateMinMax:self.data];
        }
    }

    if (self.rightAxis) {
        if (!self.rightAxis.customValue) {
            [self.rightAxis calculateMinMax:self.data];
        }
    }
}

- (void)setNeedsPrepareChart {
    _needsPrepare = YES;
    [self setNeedsDisplay];
}

- (void)prepareChart {
    _lastXValsCount = self.data.xVals.count;

    // 基类只是简单设置数据状态
    _needsPrepare   = NO;
    self.data       = [self.dataSource chartDataInView:self];

    // 这里是为了让后面y轴文案能得到全部数据的最大最小值, 方便_calcViewPixelOffset一次性计算出一个合适值
    [self.data calcMinMaxStart:self.data.minX End:self.data.maxX];

    // 将数据集的数据同步到X轴上
    if (self.data.xVals) {
        self.xAxis.entities = self.data.xVals;
    }

    // 计算出y轴上需要绘制的信息
    [self _calcYAxisMinMax];

    // 全部数据计算好之后, 重新调整一下绘制区域的大小
    [self _calcViewPixelOffset];

    // 根据新的绘制区域,重新计算反射参数
    [self _updateStandardMatrix];
    [self _updateOffsetMatrix];

    // 根据当前数据集, 设置好滚动区域长度
    [self _updateScrollContent];

    // 确定好绘制的内容和滚动区域一起同步偏移的量, 完成同步滚动.
    [self _calcViewPixelInitMatrix];
}

- (void)dataRendering {
    // 不做任何事
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

#pragma mark - CALayerDelegate
- (void)displayLayer:(CALayer *)layer {
    if (_needsPrepare) {
        [self prepareChart];
        _needsPrepare = NO;
    }

    UIGraphicsBeginImageContextWithOptions(self.viewPixelHandler.viewFrame.size, NO, 0);

    [self.leftAxisRenderer beginRenderingInLayer:self.yAxisLayer];
    [self.rightAxisRenderer beginRenderingInLayer:self.yAxisLayer];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, CGContextGetClipBoundingBox(ctx));

    [self.xAxisRenderer beginRenderingInLayer:self.xAxisLayer];
    
    UIGraphicsEndImageContext();
    
    // 单独渲染数据层
    [self dataRendering];

    self.layer.backgroundColor = self.backgroundColor.CGColor;
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

    // 滚动之后, 重新计算y轴信息
    [self.data calcMinMaxStart:self.lowestVisibleXIndex End:self.highestVisibleXIndex];
    [self _calcYAxisMinMax];
    [self _updateStandardMatrix];
    [self setNeedsDisplay];
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
    [self setNeedsDisplay];
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
    }
    
    UIGraphicsEndImageContext();
    
    
}

- (void)gestureDidEndLongPressInLocation:(CGPoint)point {
    NSLog(@"结束长按");
    // 简单演示, 几秒后移除图层即可
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->_cursorLayer removeFromSuperlayer];
        self->_cursorLayer = nil;
        [self->_markerLayer removeFromSuperlayer];
        self->_markerLayer = nil;
    });
}

#pragma mark - CCProtocolChartDataProvider
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
