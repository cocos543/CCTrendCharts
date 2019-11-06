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
@synthesize transformer      = _transformer;

- (instancetype)initWithAxis:(nonnull CCDefaultXAxis *)axis viewHandler:(nonnull CCChartViewPixelHandler *)viewPixelHandler transform:(nonnull CCChartTransformer *)transformer {
    self = [super init];
    if (self) {
        _axis             = axis;
        _viewPixelHandler = viewPixelHandler;
        _transformer      = transformer;
    }

    return self;
}

- (void)beginRenderingInLayer:(CALayer *)contentLayer {

    [self renderAxisLine:contentLayer];
    [self renderGridLines:contentLayer];

    if (self.axis.entities) {
        [self renderLabels:contentLayer];
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGImageRef img   = CGBitmapContextCreateImage(ctx);

    // 这里使用__bridge_transfer关键字, img引用计数-1, 所以不需要再调用release方法了
    contentLayer.contents = (__bridge_transfer id)img;
}

- (void)renderAxisLine:(CALayer *)contentLayer {
//    NSLog(@"渲染层接到画x轴直线通知~");

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSaveGState(ctx);
    {
        CGContextSetStrokeColorWithColor(ctx, self.axis.axisColor.CGColor);
        CGContextSetLineWidth(ctx, self.axis.axisLineWidth);
        CGContextMoveToPoint(ctx, self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentBottom);
        CGContextAddLineToPoint(ctx, self.viewPixelHandler.contentRight, self.viewPixelHandler.contentBottom);
        CGContextStrokePath(ctx);
    }
    CGContextRestoreGState(ctx);
}

- (void)renderGridLines:(CALayer *)contentLayer {
    if (!self.axis.gridLineEnabled) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    {
        CGContextSetStrokeColorWithColor(ctx, self.axis.gridColor.CGColor);
        CGContextSetLineWidth(ctx, self.axis.gridLineWidth);
        CGFloat yPos = 0.f;
        for (int i = 0; i < self.axis.entities.count; i++) {
            CGPoint position = CGPointMake(i, 0);
            position = [self.transformer pointToPixel:position forAnimationPhaseY:1];
            yPos = self.viewPixelHandler.contentBottom;
            if (position.x > self.viewPixelHandler.contentLeft && position.x < self.viewPixelHandler.contentRight) {
                if ([self.axis.formatter needToDrawLabelAt:i]) {
                    CGContextMoveToPoint(ctx, position.x, yPos);
                    CGContextAddLineToPoint(ctx, position.x, self.viewPixelHandler.contentTop);
                }
            }
        }
    }
    
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}

- (void)renderLabels:(CALayer *)contentLayer {
//    NSLog(@"准备开始渲染x轴 label 信息");
    [self.axis.formatter calcModulusWith:self.viewPixelHandler.contentWidth xSpace:[self.transformer distanceBetweenSpace:1] labelSize:self.axis.requireSize];

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSaveGState(ctx);
    {
        // 临时代码, 画地基用.
        CGContextSetStrokeColorWithColor(ctx, self.axis.axisColor.CGColor);
        CGContextSetLineWidth(ctx, self.axis.axisLineWidth);

        // 把文案绘制在x轴底部
        CGFloat yPos = 0.f;
        if (self.axis.labelPosition == CCXAxisLabelPositionBottom) {
            yPos = self.viewPixelHandler.contentBottom + self.axis.yLabelOffset;

            for (int i = 0; i < self.axis.entities.count; i++) {
                CGPoint position = CGPointMake(i, 0);
                position = [self.transformer pointToPixel:position forAnimationPhaseY:1];

                // 只绘制可视区域内的元素
                if (position.x >= self.viewPixelHandler.contentLeft && position.x <= self.viewPixelHandler.contentRight) {
                    CGContextMoveToPoint(ctx, position.x, yPos);
                    CGContextAddLineToPoint(ctx, position.x, yPos - 5);
                    //NSLog(@"x轴渲染层: 正在绘制第%@个中心轴地基, 坐标(%@,%@)", @(i), @(position.x), @(yPos));

                    if ([self.axis.formatter needToDrawLabelAt:i]) {
                        NSString *text = self.axis.entities[i];
                        text = [self.axis.formatter stringForIndex:i origin:text];

                        [text drawTextIn:ctx x:position.x y:yPos anchor:CGPointMake(0.5, 0) attributes:@{ NSFontAttributeName: self.axis.font, NSForegroundColorAttributeName: self.axis.labelColor }];
                    }
                } else {
                    //NSLog(@"x轴渲染层: 忽略绘制第%@个中心轴地基, 坐标(%@,%@)", @(i), @(position.x), @(yPos));
                }
            }
        } else if (self.axis.labelPosition == CCXAxisLabelPositionTop) {
            // 文案绘制在x轴顶部
        }

        CGContextStrokePath(ctx);
    }
    CGContextRestoreGState(ctx);
}

@end
