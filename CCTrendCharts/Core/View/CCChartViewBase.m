//
//  CCChartViewBase.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewBase.h"
#import "CCGestureHandler.h"

@interface CCChartViewBase () <CALayerDelegate, UIScrollViewDelegate> {
    BOOL _needsPrepare;
    BOOL _needUpdateForRecentFirst;
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


/// 处理手势操作的具体功能
@property (nonatomic, strong) id<CCGestureHandlerProtocol> gestureHandler;

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
        
        _viewPixelHandler = [[CCChartViewPixelHandler alloc] init];
        _transformer = [[CCChartTransformer alloc] initWithViewPixelHandler:_viewPixelHandler];
        _gestureHandler = [[CCGestureHandler alloc] initWithTransformer:_viewPixelHandler];
        
        _clipEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        
        _recentFirst = YES;
        _needUpdateForRecentFirst = YES;
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

- (void)_setChartViewTX:(CGFloat)scrollX {
    
}



#pragma mark - Non-SYS-func
- (void)updateScrollContent {
    // 滚动区间大小计算公式:
    // 滚动视图内容宽度 = 绘制总长度 - 绘制区间宽度 + 滚动视图宽度
    CGFloat totalWidth = [self.transformer distanceBetweenSpace:self.data.maxX + CC_X_INIT_TRANSLATION];
    CGFloat needWidth = totalWidth - self.viewPixelHandler.contentWidth;
    self.scrollView.contentSize = CGSizeMake(needWidth + self.bounds.size.width, 0);
}

- (void)updateViewPixelHandler {
    self.viewPixelHandler.viewFrame = self.bounds;
    self.viewPixelHandler.contentRect = CGRectClipRectUsingEdge(self.bounds, self.clipEdgeInsets);
}


///  计算view handle的初始矩阵
- (void)calcViewPixelInitMatrix {
    // 如果视图属于最近信息优先显示的话, 还需要调整初始矩阵, 让最后一个元素在绘制区间里
    if (self.recentFirst) {
        CGFloat totalWidth = [self.transformer distanceBetweenSpace:self.data.maxX + CC_X_INIT_TRANSLATION];
        CGFloat needWidth = totalWidth - self.viewPixelHandler.contentWidth;
        
        [self _setScrollViewXOffset:needWidth];
        
        self.viewPixelHandler.anInitMatrix = CGAffineTransformMakeTranslation(-needWidth, 0);
    }
}


/// 重新计算x,y轴的位置信息. 两个轴的位置和轴文案是紧密相关的.
- (void)calcViewPixelOffset {
    // 先恢复ViewPixel的初始值
    [self updateViewPixelHandler];
    
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

- (void)updateStandardMatrix {
    // 暂时只处理左轴
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (self.leftAxis) {
        transform = [self.transformer calcMatrixWithMinValue:self.leftAxis.axisMinValue maxValue:self.leftAxis.axisMaxValue xSpace:self.data.xSpace];
    }else if (self.rightAxis) {
        
    }
    
    [self.transformer refreshMatrix:transform];
}

- (void)updateOffsetMatrix {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // 计算偏差矩阵
    transform = CGAffineTransformMakeTranslation(self.viewPixelHandler.offsetLeft, self.viewPixelHandler.viewHeight - self.viewPixelHandler.offsetBottom);
    [self.transformer refreshOffsetMatrix:transform];
}

- (void)setNeedsPrepareChart {
    _needsPrepare = YES;
    [self setNeedsDisplay];
}

- (void)prepareChart {
    // 基类只是简单设置数据状态
    _needsPrepare = NO;
    
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
    [self calcViewPixelOffset];
    
    // 根据新的绘制区域,重新计算反射参数
    [self updateStandardMatrix];
    [self updateOffsetMatrix];
    
    
    // 根据当前数据集, 设置好滚动区域长度
    [self updateScrollContent];
    
    [self calcViewPixelInitMatrix];
    
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
    
    NSLog(@"displayLayer: 根图层重绘, 全部子图层需要重新渲染");
    
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
    
    // Core Graphics 测试代码.
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSaveGState(ctx);
    {

        
        // 三角形
        CGContextTranslateCTM(ctx, 80, 25);
        
        CGContextSetFillColorWithColor(ctx, [[UIColor redColor] CGColor]);
        CGContextMoveToPoint(ctx, 0, 0);
        CGContextAddLineToPoint(ctx, 20, -25);
        CGContextAddLineToPoint(ctx, 40, 0);
        
        CGContextFillPath(ctx);
        CGContextRestoreGState(ctx); // 完成裁剪
        
        CGContextSaveGState(ctx);
        
        
        //// 裁剪
        CGContextSetLineWidth(ctx, 1);
        
        CGContextAddRect(ctx, CGContextGetClipBoundingBox(ctx));
        
        CGContextMoveToPoint(ctx, 90, 100);
        CGContextAddLineToPoint(ctx, 100, 90);
        CGContextAddLineToPoint(ctx, 110, 100);
        CGContextClosePath(ctx);
        
        // 上面矩形内有一个三角形, 三角形就是被掏空的区域, 下面垂线不会填充挖空区域
        CGContextEOClip(ctx);
        
        // 绘制垂线
        CGContextMoveToPoint(ctx, 100, 100);
        CGContextAddLineToPoint(ctx, 100, 19);
        CGContextSetLineWidth(ctx, 20);
        // 使用路径的描边版本替换图形上下文的路径
        CGContextReplacePathWithStrokedPath(ctx);
        
        CGContextClip(ctx);
        
        // 绘制渐变
        CGFloat locs[3]    = { 0.0, 0.5, 1.0 };
        CGFloat colors[12] = {
            0.3, 0.3, 0.3, 0.8, // 开始颜色，透明灰
            0.0, 0.0, 0.0, 1.0, // 中间颜色，黑色
            0.3, 0.3, 0.3, 0.8 // 末尾颜色，透明灰
        };

        CGColorSpaceRef sp = CGColorSpaceCreateDeviceGray();
        CGGradientRef grad = CGGradientCreateWithColorComponents(sp, colors, locs, 3);
        CGContextDrawLinearGradient(ctx, grad, CGPointMake(89, 0), CGPointMake(111, 0), 0);
        CGColorSpaceRelease(sp);
        CGGradientRelease(grad);
        
        CGContextRestoreGState(ctx); // 完成裁剪
        
        
        CGContextSetFillColorWithColor(ctx, UIColor.redColor.CGColor);
        CGContextFillRect(ctx, CGRectMake(10, 200, 0.1, 200));
        
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    printf("retain count = %ld\n",CFGetRetainCount(cgimg));
    
    UIGraphicsEndImageContext();

    self.layer.contents = (__bridge id)cgimg;
    printf("retain count = %ld\n",CFGetRetainCount(cgimg));
    
    CGImageRelease(cgimg);
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scroll offset:%@", NSStringFromCGPoint(scrollView.contentOffset));
    
    [self.gestureHandler didScroll:scrollView.contentOffset];
    
    [self setNeedsDisplay];
}


#pragma mark - CCProtocolChartDataProvider
- (NSInteger)lowestVisibleXIndex {
    CGPoint point = CGPointMake(self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentBottom);
    point = [self.transformer pixelToPoint:point forAnimationPhaseY:1];
    
    // 最小的索引是0
    if (point.x <= 0) {
        return 0;
    }
    return ceil(point.x);
}

- (NSInteger)highestVisibleXIndex {
    CGPoint point = CGPointMake(self.viewPixelHandler.contentRight, self.viewPixelHandler.contentBottom);
    point = [self.transformer pixelToPoint:point forAnimationPhaseY:1];
    
    // 最大可见的索引不会大于数据源最大索引
    NSInteger index = floor(point.x);
    
    return MIN(self.data.maxX, index);
}

@end
