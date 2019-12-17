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

@interface CCDefaultYAxisRenderer ()

@end

@implementation CCDefaultYAxisRenderer

- (instancetype)initWithAxis:(nonnull CCDefaultYAxis *)axis viewHandler:(nonnull CCChartViewPixelHandler *)viewPixelHandler transform:(nonnull CCChartTransformer *)transformer {
    self = [super initWithViewHandler:viewPixelHandler transform:transformer DataProvider:nil];
    if (self) {
        _axis = axis;
    }

    return self;
}

- (void)beginRenderingInLayer:(CALayer *)contentLayer {
    [self renderAxisLine:contentLayer];
    [self renderGridLines:contentLayer];
    [self renderLabels:contentLayer];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    CGContextClearRect(ctx, CGContextGetClipBoundingBox(ctx));
    //
    //    if (self.axis.dependency == CCYAsixDependencyRight) {
    //        // 先把当前图层的内容画上去, 在原来的基础上进行绘制
    //        UIImage *oldImg = [UIImage imageWithCGImage:(__bridge CGImageRef)contentLayer.contents scale:CCBaseUtility.currentScale orientation:UIImageOrientationUp];
    //        [oldImg drawAtPoint:CGPointZero];
    //    }

    CGImageRef img = CGBitmapContextCreateImage(ctx);

    // 这里使用__bridge_transfer关键字, img引用计数-1, 所以不需要再调用release方法了
    [CALayer quickUpdateLayer:^{
        contentLayer.contents = (__bridge_transfer id)img;
    }];
}

- (void)renderAxisLine:(CALayer *)contentLayer {
    if (self.axis.axisLineDisabled) {
        return;
    }

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSaveGState(ctx);
    {
        CGContextSetStrokeColorWithColor(ctx, self.axis.axisColor.CGColor);
        CGContextSetLineWidth(ctx, self.axis.axisLineWidth);

        // 这里根据不同配置绘制左右轴
        if (self.axis.dependency == CCYAsixDependencyLeft) {
            CGContextMoveToPoint(ctx, self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentBottom);
            CGContextAddLineToPoint(ctx, self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentTop);
        } else if (self.axis.dependency == CCYAsixDependencyRight) {
            CGContextMoveToPoint(ctx, self.viewPixelHandler.contentRight, self.viewPixelHandler.contentBottom);
            CGContextAddLineToPoint(ctx, self.viewPixelHandler.contentRight, self.viewPixelHandler.contentTop);
        }

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
        CGFloat xPos = 0.f;
        for (NSNumber *num in self.axis.entities) {
            CGPoint position = CGPointMake(0, num.doubleValue);
            position = [self.transformer pointToPixel:position forAnimationPhaseY:1];
            xPos     = self.viewPixelHandler.contentLeft;

            if ([self.viewPixelHandler isInBoundsTop:position.y] && [self.viewPixelHandler isInBoundsBottom:position.y]) {
                CGContextMoveToPoint(ctx, xPos, position.y);
                CGContextAddLineToPoint(ctx, self.viewPixelHandler.contentRight, position.y);
            }
        }
    }

    CGContextStrokePath(ctx);

    CGContextRestoreGState(ctx);
}

- (void)renderLabels:(CALayer *)contentLayer {
    if (self.axis.labelDisable) {
        return;
    }

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSaveGState(ctx);
    {
        // 临时代码, 绘制地基
        CGContextSetStrokeColorWithColor(ctx, self.axis.axisColor.CGColor);
        CGContextSetLineWidth(ctx, self.axis.axisLineWidth);

        // 确定文案x位置
        CGFloat xPos   = 0;
        CGPoint anchor = CGPointZero;
        if (self.axis.dependency == CCYAsixDependencyLeft) {
            if (self.axis.labelPosition == CCYAxisLabelPositionOutside) {
                xPos   = self.viewPixelHandler.contentLeft - self.axis.xLabelOffset;
                anchor = CGPointMake(1, 0.5);
            } else if (self.axis.labelPosition == CCYAxisLabelPositionInside) {
                xPos   = self.viewPixelHandler.contentLeft + self.axis.xLabelOffset;
                anchor = CGPointMake(0, 0.5);
            }
        } else if (self.axis.dependency == CCYAsixDependencyRight) {
            if (self.axis.labelPosition == CCYAxisLabelPositionOutside) {
                xPos   = self.viewPixelHandler.contentRight + self.axis.xLabelOffset;
                anchor = CGPointMake(0, 0.5);
            } else if (self.axis.labelPosition == CCYAxisLabelPositionInside) {
                xPos   = self.viewPixelHandler.contentRight - self.axis.xLabelOffset;
                anchor = CGPointMake(1, 0.5);
            }
        }

        // 确定文案y位置
        for (NSNumber *num in self.axis.entities) {
            CGPoint position = CGPointMake(0, num.doubleValue);
            position   = [self.transformer pointToPixel:position forAnimationPhaseY:1];
            position.x = xPos;
            if ([self.viewPixelHandler isInBoundsTop:position.y] && [self.viewPixelHandler isInBoundsBottom:position.y]) {
                NSString *text = [self.axis.formatter stringFromNumber:num];
                [text drawTextIn:ctx x:position.x y:position.y + self.axis.yLabelOffset anchor:anchor attributes:@{ NSFontAttributeName: self.axis.font, NSForegroundColorAttributeName: self.axis.labelColor }];
            }
        }
        CGContextStrokePath(ctx);
    }

    CGContextRestoreGState(ctx);
}

- (void)processAxisEntities:(CGFloat)min:(CGFloat)max {
}

@end
