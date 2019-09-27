//
//  CCDefaultXAxisRenderer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/12.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefaultXAxisRenderer.h"

@implementation CCDefaultXAxisRenderer

@synthesize viewPixelHandler = _viewPixelHandler;
@synthesize transformer = _transformer;

- (instancetype)initWithAxis:(nonnull CCDefaultXAxis *)axis viewHandler:(nonnull CCChartViewPixelHandler *)viewPixelHandler transform:(nonnull CCChartTransformer *)transformer {
    self = [super init];
    if (self) {
        _axis = axis;
        _viewPixelHandler = viewPixelHandler;
        _transformer = transformer;
    }
    
    return self;
}


- (void)renderAxisLine:(CALayer *)contentLayer {
    NSLog(@"渲染层接到画x轴直线通知~");
    
    UIGraphicsBeginImageContextWithOptions(self.viewPixelHandler.viewFrame.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    {
        CGContextSetStrokeColorWithColor(ctx, self.axis.axisColor.CGColor);
        CGContextSetLineWidth(ctx, self.axis.axisLineWidth);
        CGContextMoveToPoint(ctx, self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentBottom);
        CGContextAddLineToPoint(ctx, self.viewPixelHandler.contentRight, self.viewPixelHandler.contentBottom);
        CGContextStrokePath(ctx);
    }
    CGContextStrokePath(ctx);
    
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    
    UIGraphicsEndImageContext();
    
    // 这里使用__bridge_transfer关键字, img引用计数-1, 所以不需要再调用release方法了
    contentLayer.contents = (__bridge_transfer id)img;
    
}

- (void)renderGridLines:(CALayer *)contentLayer {
    
}

- (void)renderLabels:(CALayer *)contentLayer {
    NSLog(@"准备开始渲染x轴 label 信息");
    
    
}

- (void)processAxisEntities:(NSArray<NSString *> *)entities {
    
}

@end
