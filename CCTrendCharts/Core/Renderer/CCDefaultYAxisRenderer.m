//
//  CCDefaultYAxisRenderer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/12.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefaultYAxisRenderer.h"


//void Hello(int a) {
//    printf("hello %d\n", a);
//}

@interface CCDefaultYAxisRenderer()

@end

@implementation CCDefaultYAxisRenderer

@synthesize viewPixelHandler = _viewPixelHandler;
@synthesize transformer = _transformer;

- (instancetype)initWithAxis:(nonnull CCDefaultYAxis *)axis viewHandler:(nonnull CCChartViewPixelHandler *)viewPixelHandler transform:(nonnull CCChartTransformer *)transformer {
    self = [super init];
    if (self) {
        _axis = axis;
        _viewPixelHandler = viewPixelHandler;
        _transformer = transformer;
    }
    
    return self;
}

- (void)renderAxisLine:(CALayer *)contentLayer {
    NSLog(@"渲染层接到画y轴直线通知~");

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(ctx, CGContextGetClipBoundingBox(ctx));
    
    CGContextSaveGState(ctx);
    {
        CGContextSetStrokeColorWithColor(ctx, self.axis.axisColor.CGColor);
        CGContextSetLineWidth(ctx, self.axis.axisLineWidth);
        
        // 这里根据不同配置绘制左右轴
        if (self.axis.dependency == CCYAsixDependencyLeft) {
            CGContextMoveToPoint(ctx, self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentBottom);
            CGContextAddLineToPoint(ctx, self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentTop);
        }else if (self.axis.dependency == CCYAsixDependencyRight) {
            CGContextMoveToPoint(ctx, self.viewPixelHandler.contentRight, self.viewPixelHandler.contentBottom);
            CGContextAddLineToPoint(ctx, self.viewPixelHandler.contentRight, self.viewPixelHandler.contentTop);
        }
        
        CGContextStrokePath(ctx);
    }
    
    CGContextRestoreGState(ctx);
    
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    
    // 这里使用__bridge_transfer关键字, img引用计数-1, 所以不需要再调用release方法了
    contentLayer.contents = (__bridge_transfer id)img;
    
}

- (void)renderGridLines:(CALayer *)contentLayer {
    
}

- (void)renderLabels:(CALayer *)contentLayer {
    NSLog(@"准备开始渲染y轴 label 信息");
}

- (void)processAxisEntities:(CGFloat)min :(CGFloat)max {
    
}

@end
