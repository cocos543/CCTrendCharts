//
//  CCChartViewBase.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewBase.h"

@interface CCChartViewBase () <CALayerDelegate, UIScrollViewDelegate, CCGestureHandlerDelegate> {
    BOOL _needsPrepare;
    NSInteger _willPreparePage;
    
    BOOL _needUpdateForRecentFirst;
    BOOL _needTriggerScrollGesture;
    
    // 记录最后的手势平移值
    CGFloat _lastTx;
    // 记录 scroll最后的偏移量
    CGFloat _lastOffsetX;
    
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
 值图层
 */
@property (nonatomic, strong) CAShapeLayer *valuesLayer;

/**
 高亮图层
 */
@property (nonatomic, strong) CAShapeLayer *highlightLayer;

/**
 网格图层
 */
@property (nonatomic, strong) CAShapeLayer *gridLinesLayer;



/**
 提供横向滚动功能
 */
@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation CCChartViewBase
@synthesize xAxis     = _xAxis;
@synthesize leftAxis  = _leftAxis;
@synthesize rightAxis = _rightAxis;
@synthesize viewPixelHandler = _viewPixelHandler;
@synthesize transformer = _transformer;

// 渲染组件变量由子类合成
@dynamic renderer;
@dynamic leftAxisrenderer;
@dynamic rightAxisrenderer;
@dynamic xAxisrenderer;
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
        _scrollView.delegate = self;
        _scrollView.backgroundColor = UIColor.clearColor;
        
        UIPanGestureRecognizer *twoFingerPan = [[UIPanGestureRecognizer alloc] init];
        twoFingerPan.minimumNumberOfTouches = 2;
        twoFingerPan.maximumNumberOfTouches = 2;
        [_scrollView addGestureRecognizer:twoFingerPan];
        
        _viewPixelHandler = [[CCChartViewPixelHandler alloc] init];
        _transformer = [[CCChartTransformer alloc] initWithViewPixelHandler:_viewPixelHandler];
        _gestureHandler = [[CCGestureDefaultHandler alloc] initWithTransformer:_viewPixelHandler];
        _gestureHandler.baseView = self;
        _gestureHandler.delegate = self;
        
        _clipEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        
        _recentFirst = YES;
        _needUpdateForRecentFirst = YES;
        _needTriggerScrollGesture = YES;
        _lastTx = 0.f;
        _lastOffsetX = 0.f;

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

    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    l.text = @"testtets";
    [self.scrollView addSubview:l];
    
    self.yAxisLayer.frame = frame;
    self.xAxisLayer.frame = frame;
}

- (void)setNeedsDisplay {
    [super setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)rect {
    [super setNeedsDisplayInRect:rect];
}

#pragma mark - Scroll-func
/// 返回 Chart view / Scroll view
- (CGFloat)_scrollRatio {
    return 1;
}

- (void)_setScrollViewXOffset:(CGFloat)chartTX {
    self.scrollView.contentOffset = CGPointMake(chartTX, 0);
}



#pragma mark - Non-SYS-func
/// scroll view的滚动区间大小, 决定了渲染区域的横向大小
- (void)_updateScrollContent {
    // 滚动区间大小计算公式:
    // 滚动视图内容宽度 = 绘制总长度 - 绘制区间宽度 + 滚动视图宽度
    // 这里CC_X_INIT_TRANSLATION*2是为了让绘制的时候数据不要和绘制区间左右两边重合
    CGFloat totalWidth = fabs([self.transformer distanceBetweenSpace:self.data.maxX + CC_X_INIT_TRANSLATION * 2]);
    CGFloat needWidth = totalWidth - self.viewPixelHandler.contentWidth;
    self.scrollView.contentSize = CGSizeMake(needWidth + self.bounds.size.width, 0);
}

- (void)_updateViewPixelHandler {
    self.viewPixelHandler.viewFrame = self.bounds;
    self.viewPixelHandler.contentRect = CGRectClipRectUsingEdge(self.bounds, self.clipEdgeInsets);
}


///  计算view handle的初始矩阵
- (void)_calcViewPixelInitMatrix {
    // 如果视图属于最近信息优先显示的话, 还需要调整初始矩阵, 让最后一个元素在绘制区间里
    // 当前正在进行手势操作的, 表示正在浏览数据, 所以不应该重新计算手势矩阵了
    if (self.recentFirst && ![self.viewPixelHandler isGestureProcessing]) {
        CGFloat totalWidth = fabs([self.transformer distanceBetweenSpace:self.data.maxX + CC_X_INIT_TRANSLATION * 2]);
        CGFloat needWidth = totalWidth - self.viewPixelHandler.contentWidth;
        
        [self _setScrollViewXOffset:needWidth];
        
        // recentFirst模式下, 初始矩阵的偏移量和scrollview的偏移量是不同步的, 所以需要重新更新一下lastTx变量
        self.viewPixelHandler.anInitMatrix = CGAffineTransformMakeTranslation(self.viewPixelHandler.contentWidth, 0);
        _lastTx =  self.viewPixelHandler.gestureMatrix.tx;
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
        }else if (self.leftAxis.labelPosition == CCYAxisLabelPositionInside) {
            offsetLeft = 0.f;
        }
    }
    
    if (self.rightAxis) {
        
    }
    
    size = self.xAxis.requireSize;
    offsetBottom = size.height;
    
    [self.viewPixelHandler updateContentRectOffsetLeft:offsetLeft offsetRight:offsetRight offsetTop:offsetTop offsetBottom:offsetBottom];
}

- (void)_updateStandardMatrix {
    // 暂时只处理左轴
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (self.leftAxis) {
        transform = [self.transformer calcMatrixWithMinValue:self.leftAxis.axisMinValue maxValue:self.leftAxis.axisMaxValue xSpace:self.data.xSpace rentFirst:self.recentFirst];
    }else if (self.rightAxis) {
        
    }
    
    [self.transformer refreshMatrix:transform];
}

- (void)_updateOffsetMatrix {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // 计算偏差矩阵
    transform = CGAffineTransformMakeTranslation(self.viewPixelHandler.offsetLeft, self.viewPixelHandler.viewHeight - self.viewPixelHandler.offsetBottom);
    [self.transformer refreshOffsetMatrix:transform];
}

- (void)setNeedsPrepareChart:(NSInteger)page {
    _needsPrepare = YES;
    _willPreparePage = page;
    [self setNeedsDisplay];
}

- (void)prepareChart {
    // 基类只是简单设置数据状态
    _needsPrepare = NO;
    self.data = [self.dataSource chartDataForPage:_willPreparePage inView:self];
    
    [self.data calcMinMaxStart:self.data.minX End:self.data.maxX];
    
    
    // 将数据集的数据同步到X轴上
    if (self.data.xVals) {
        self.xAxis.entities = self.data.xVals;
    }
    
    // 计算出y轴上需要绘制的信息
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
    
    
    // 全部数据计算好之后, 重新调整一下绘制区域的大小
    [self _calcViewPixelOffset];
    
    // 根据新的绘制区域,重新计算反射参数
    [self _updateStandardMatrix];
    [self _updateOffsetMatrix];
    
    
    // 根据当前数据集, 设置好滚动区域长度
    [self _updateScrollContent];
    
    [self _calcViewPixelInitMatrix];
    
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



#pragma mark - CALayerDelegate
- (void)displayLayer:(CALayer *)layer {
    if (_needsPrepare) {
        [self prepareChart];
        _needsPrepare = NO;
    }
    
//    NSLog(@"displayLayer: 根图层重绘, 全部子图层需要重新渲染");
    
    UIGraphicsBeginImageContextWithOptions(self.viewPixelHandler.viewFrame.size, NO, 0);
    
    [self.leftAxisrenderer renderAxisLine:self.yAxisLayer];
    [self.xAxisrenderer renderAxisLine:self.xAxisLayer];
    
    if (self.xAxis.entities) {
        [self.xAxisrenderer renderLabels:self.xAxisLayer];
    }
    
    if (self.leftAxis.entities) {
        [self.leftAxisrenderer renderLabels:self.yAxisLayer];
    }

    if (self.rightAxis.entities) {
        [self.rightAxisrenderer renderLabels:self.yAxisLayer];
    }
    
    
    UIGraphicsEndImageContext();
    
    self.layer.backgroundColor = self.backgroundColor.CGColor;
}

#pragma mark - Drawing


/**
 下面的代码都是测试用的, 不一定会被调用, 后期会删除

 */
- (void)drawRect:(CGRect)rect {
    NSLog(@"drawRect");
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_needTriggerScrollGesture) {
        return;
    }
    
    
    [self.gestureHandler didScrollIncrementOffsetX:scrollView.contentOffset.x - _lastOffsetX];
    
    _lastOffsetX = scrollView.contentOffset.x;
    _lastTx =  self.viewPixelHandler.gestureMatrix.tx;
    
    [self setNeedsDisplay];
}

#pragma mark - Gesture-func
- (void)addDefualtGesture {
    [self addGestureRecognizer:self.gestureHandler.pinchGesture];
}

#pragma mark - CCGestureHandlerDelegate
- (void)gestureDidPinchInLocation:(CGPoint)point matrix:(CGAffineTransform)matrix {
    [self _updateScrollContent];
    
    // 计算出缩放之后内容整体平移了多少, 同步scroll view的contentOffset
    CGFloat tx = self.viewPixelHandler.gestureMatrix.tx - _lastTx;
    
    CGPoint offset = self.scrollView.contentOffset;
    
    // 这里其实有一个参考系问题, 我们参考的是index=0的实体偏移值, 普通模式下, index=0的实体在最左侧, 放大时tx其实是负数(因为index向左移动了);
    // 如果是recentFirst模式, index=0的实体是在最右边, 放大时tx其实变成正数了(index向右移动了);
    // 这里tx为负数说明绘制内容往左移动, 意味着offset更大, 所以减去负数
    if (self.recentFirst) {
        offset.x += tx;
    }else {
        offset.x -= tx;
    }
    
    _needTriggerScrollGesture = NO;
    [self.scrollView setContentOffset:offset animated:NO];
    _needTriggerScrollGesture = YES;
    
    _lastOffsetX = offset.x;
    _lastTx =  self.viewPixelHandler.gestureMatrix.tx;
    
    [self setNeedsDisplay];
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
        
    }else {
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
        CGPoint point = CGPointMake(self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentBottom);
        point = [self.transformer pixelToPoint:point forAnimationPhaseY:1];
        
        // 最大可见的索引不会大于数据源最大索引
        NSInteger index = floor(point.x);
        
        return MIN(self.data.maxX, index);
    }else {
        CGPoint point = CGPointMake(self.viewPixelHandler.contentRight, self.viewPixelHandler.contentBottom);
        point = [self.transformer pixelToPoint:point forAnimationPhaseY:1];
        
        // 最大可见的索引不会大于数据源最大索引
        NSInteger index = floor(point.x);
        
        return MIN(self.data.maxX, index);
    }
    
}

@end
