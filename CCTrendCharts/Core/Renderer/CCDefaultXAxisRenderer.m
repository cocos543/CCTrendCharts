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
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(ctx, CGContextGetClipBoundingBox(ctx));
    
    CGContextSaveGState(ctx);
    {
        CGContextSetStrokeColorWithColor(ctx, self.axis.axisColor.CGColor);
        CGContextSetLineWidth(ctx, self.axis.axisLineWidth);
        CGContextMoveToPoint(ctx, self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentBottom);
        CGContextAddLineToPoint(ctx, self.viewPixelHandler.contentRight, self.viewPixelHandler.contentBottom);
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
    NSLog(@"准备开始渲染x轴 label 信息");
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(ctx, CGContextGetClipBoundingBox(ctx));
    // 先把当前图层的内容画上去, 在原来的基础上进行绘制
    UIImage *imgT = [UIImage imageWithCGImage:(__bridge CGImageRef)(contentLayer.contents)];
    
    [imgT drawInRect:CGContextGetClipBoundingBox(ctx)];
    
    CGContextSaveGState(ctx);
    {
        CGContextSetStrokeColorWithColor(ctx, self.axis.axisColor.CGColor);
        CGContextSetLineWidth(ctx, self.axis.axisLineWidth);

        // 把文案绘制在x轴底部
        if (self.axis.labelPosition == CCXAxisLabelPositionBottom) {
            for (int i = 0; i < self.axis.entities.count; i++) {
                CGPoint position = CGPointMake(i, 0);
                position = [self.transformer pointToPixel:position forAnimationPhaseY:1];
                CGContextMoveToPoint(ctx, position.x, position.y);
                CGContextAddLineToPoint(ctx, position.x, position.y - 10);
            }
        }

        CGContextStrokePath(ctx);
    }
    CGContextRestoreGState(ctx);
    
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    
    contentLayer.contents = (__bridge_transfer id)img;
    
}

- (void)processAxisEntities:(NSArray<NSString *> *)entities {
    
}

@end
