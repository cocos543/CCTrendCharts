//
//  CCChartViewBase.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewBase.h"
@interface CCChartViewBase () <CALayerDelegate>

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
 承载数据绘制的视图
 */
@property (nonatomic, strong) UIScrollView *dataPanelView;

@end

@implementation CCChartViewBase
@synthesize xAxis     = _xAxis;
@synthesize leftAxis  = _leftAxis;
@synthesize rightAxis = _rightAxis;

// 渲染组件变量由子类合成
@dynamic renderer;
@dynamic yAxisrenderer;
@dynamic xAxisrenderer;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dataPanelView = [[UIScrollView alloc] initWithFrame:frame];
        _dataPanelView.backgroundColor = UIColor.clearColor;
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
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);;
    self.dataPanelView.frame = frame;
    self.dataPanelView.contentSize = CGSizeMake(1000, 300);
    [self addSubview:_dataPanelView];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    l.text = @"testtets";
    [self.dataPanelView addSubview:l];
    
    self.yAxisLayer.frame = frame;
    self.xAxisLayer.frame = frame;
}

#pragma mark - Getter & Setter
- (CALayer *)yAxisLayer {
    if (!_yAxisLayer) {
        _yAxisLayer = CALayer.layer;
        // 这里设置delegate会奔溃..明天再查查看...
        //_yAxisLayer.delegate = self;
        
        // Y轴渲染层放到所有图层的底部
        [self.layer addSublayer:_yAxisLayer];
        _yAxisLayer.zPosition = -100;
    }
    
    return _yAxisLayer;
}

- (CALayer *)xAxisLayer {
    if (!_xAxisLayer) {
        _xAxisLayer = CALayer.layer;
        //_xAxisLayer.delegate = self;
        
        // X轴渲染层放到滚动视图的最下层, 这样做是方便x轴上元素的滚动
        [self.dataPanelView.layer addSublayer:_xAxisLayer];
        _xAxisLayer.zPosition = -100;
    }
    
    return _xAxisLayer;
}



#pragma mark - CALayerDelegate
//- (void)displayLayer:(CALayer *)layer {
//    if (layer == self.layer) {
//
//        NSLog(@"根图层重绘, 全部子图层需要重新渲染");
//        [self.yAxisrenderer renderAxisLine:self.yAxisLayer];
//        [self.xAxisrenderer renderAxisLine:self.xAxisLayer];
//    }
//}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    if (layer == self.layer) {
        [super drawLayer:layer inContext:ctx];
        return;
    }
}

#pragma mark - Drawing

//- (void)displayLayer:(CALayer *)layer {
//    layer.backgroundColor = self.backgroundColor.CGColor;
//    NSLog(@"displayLayer:%@", layer);
//
//    [self.renderer renderValues:nil];
//    [self.renderer renderHighlighted:nil];
//
//    [self.yAxisrenderer renderLabels:nil];
//    [self.yAxisrenderer renderAxisLine:nil];
//    [self.yAxisrenderer renderGridLines:nil];
//}

// 3
- (void)drawRect:(CGRect)rect {
    NSLog(@"drawRect");
    
    // Core Graphics 测试代码.
    //UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
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
//
//
//
//
//    myDrawFlag(ctx, &frame);
//
//
//
//    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
//
//    UIGraphicsEndImageContext();
//
//    [[UIImage imageWithCGImage:cgimg scale:2 orientation:UIImageOrientationDownMirrored] drawAtPoint:CGPointMake(0,0)];

    //self.layer.contents = (__bridge id)CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
}

@end
