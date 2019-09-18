//
//  CCChartViewBase.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewBase.h"
@interface CCChartViewBase ()

/**
 y轴图层
 */
@property (nonatomic, strong) CAShapeLayer *yAxisLayer;

/**
 x轴图层
 */
@property (nonatomic, strong) CAShapeLayer *xAxisLayer;

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
        _leftAxis  = nil;
        _rightAxis = nil;
        _xAxis     = nil;
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
    [self.renderer renderData:nil];
    [self.renderer renderHighlighted:nil];

    [self.yAxisrenderer renderLabels:nil];
    [self.yAxisrenderer renderAxisLine:nil];
    [self.yAxisrenderer renderGridLines:nil];
}

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

// 2
//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//
//    NSLog(@"draw  Layer %@", layer);
//}

// 3
- (void)drawRect:(CGRect)rect {
    NSLog(@"drawRect");
    
    // Core Graphics 测试代码.
    CGRect frame     = CGRectMake(0, 0, 300, 300);
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

void myDrawFlag(CGContextRef context, CGRect *contextRect) {
    int i, j,
        num_six_star_rows      = 5,
        num_five_star_rows     = 4;
    CGFloat start_x            = 5.0,// 1
            start_y            = 108.0,// 2
            red_stripe_spacing = 34.0,// 3
            h_spacing          = 26.0,// 4
            v_spacing          = 22.0;// 5
    CGContextRef myLayerContext1,
                 myLayerContext2;
    CGLayerRef stripeLayer,
               starLayer;
    CGRect myBoundingBox,      // 6
           stripeRect,
           starField;
    // ***** Setting up the primitives *****
    const CGPoint myStarPoints[] = { { 5,    5        },   { 10,   15       },// 7
                                     { 10,   15       },   { 15,   5        },
                                     { 15,   5        },   { 2.5,  11       },
                                     { 2.5,  11       },   { 16.5, 11       },
                                     { 16.5, 11       },   { 5,    5        } };

    stripeRect      = CGRectMake(0, 0, 400, 17); // stripe// 8
    starField       =  CGRectMake(0, 102, 160, 119);// star field// 9

    myBoundingBox   = CGRectMake(0, 0, contextRect->size.width, // 10
                                 contextRect->size.height);

    // ***** Creating layers and drawing to them *****
    stripeLayer     = CGLayerCreateWithContext(context, // 11
                                               stripeRect.size, NULL);
    myLayerContext1 = CGLayerGetContext(stripeLayer); // 12

    CGContextSetRGBFillColor(myLayerContext1, 1, 0, 0, 1);  // 13
    CGContextFillRect(myLayerContext1, stripeRect); // 14

    starLayer       = CGLayerCreateWithContext(context,
                                               starField.size, NULL);// 15
    myLayerContext2 = CGLayerGetContext(starLayer); // 16
    CGContextSetRGBFillColor(myLayerContext2, 1.0, 1.0, 1.0, 1); // 17
    CGContextAddLines(myLayerContext2, myStarPoints, 10); // 18
    CGContextFillPath(myLayerContext2);     // 19

    // ***** Drawing to the window graphics context *****
    CGContextSaveGState(context);    // 20
    for (i = 0; i < 7; i++) { // 21
        CGContextDrawLayerAtPoint(context, CGPointZero, stripeLayer); // 22
        CGContextTranslateCTM(context, 0.0, red_stripe_spacing); // 23
    }
    CGContextRestoreGState(context);// 24

    CGContextSetRGBFillColor(context, 0, 0, 0.329, 1.0); // 25
    CGContextFillRect(context, starField); // 26

    CGContextSaveGState(context);               // 27
    CGContextTranslateCTM(context, start_x, start_y);       // 28
    for (j = 0; j < num_six_star_rows; j++) { // 29
        for (i = 0; i < 6; i++) {
            CGContextDrawLayerAtPoint(context, CGPointZero,
                                      starLayer); // 30
            CGContextTranslateCTM(context, h_spacing, 0); // 31
        }
        CGContextTranslateCTM(context, (-i * h_spacing), v_spacing); // 32
    }
    CGContextRestoreGState(context);

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, start_x + h_spacing / 2, // 33
                          start_y + v_spacing / 2);
    for (j = 0; j < num_five_star_rows; j++) { // 34
        for (i = 0; i < 5; i++) {
            CGContextDrawLayerAtPoint(context, CGPointZero,
                                      starLayer); // 35
            CGContextTranslateCTM(context, h_spacing, 0); // 36
        }
        CGContextTranslateCTM(context, (-i * h_spacing), v_spacing);// 37
    }
    CGContextRestoreGState(context);

    CGLayerRelease(stripeLayer);// 38
    CGLayerRelease(starLayer);        // 39
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
