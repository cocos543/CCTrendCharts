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
    
    UIGraphicsBeginImageContextWithOptions(_viewPixelHandler.contentRect.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextIndependent(ctx, {
        CGContextSetStrokeColorWithColor(ctx, UIColor.redColor.CGColor);
        CGContextSetLineWidth(ctx, 1);
        CGContextMoveToPoint(ctx, 30, 30);
        CGContextAddLineToPoint(ctx, 30, 200);
        CGContextStrokePath(ctx);
    })
    
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    
    UIGraphicsEndImageContext();
    
    // 这里使用__bridge_transfer关键字, img引用计数-1, 所以不需要再调用release方法了
    contentLayer.contents = (__bridge_transfer id)img;
    
}

- (void)renderGridLines:(CALayer *)contentLayer {
    
}

- (void)renderLabels:(CALayer *)contentLayer {
    
}

- (void)processAxisEntities:(CGFloat)min :(CGFloat)max {
    
}

@end
