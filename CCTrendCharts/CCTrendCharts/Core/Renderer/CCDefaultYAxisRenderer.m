//
//  CCDefaultYAxisRenderer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/12.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefaultYAxisRenderer.h"
#import "CCRendererBase+LayerCache.h"
@import CoreText.CTFont;

@interface CCDefaultYAxisRenderer ()

@end

@implementation CCDefaultYAxisRenderer

- (instancetype)initWithAxis:(nonnull CCDefaultYAxis *)axis viewHandler:(nonnull CCChartViewPixelHandler *)viewPixelHandler transform:(nonnull CCChartTransformer *)transformer {
    self = [super initWithViewHandler:viewPixelHandler transform:transformer DataProvider:nil];
    if (self) {
        _axis = axis;

        [self cc_registerLayerMaker:^__kindof CALayer *_Nonnull {
            return CAShapeLayer.layer;
        } forKey:NSStringFromClass(CAShapeLayer.class)];

        [self cc_registerLayerMaker:^__kindof CALayer *_Nonnull {
            return CATextLayer.layer;
        } forKey:NSStringFromClass(CATextLayer.class)];
    }

    return self;
}

- (void)beginRenderingInLayer:(CALayer *)contentLayer {
    if (!self.axis) {
        return;
    }
    
    [self cc_releaseAllLayerBackToBufferPool];

    [self renderAxisLine:contentLayer];
    [self renderGridLines:contentLayer];
    [self renderLabels:contentLayer];

//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGImageRef img = CGBitmapContextCreateImage(ctx);
//
//    // 这里使用__bridge_transfer关键字, img引用计数-1, 所以不需要再调用release方法了
//    [CALayer quickUpdateLayer:^{
//        contentLayer.contents = (__bridge_transfer id)img;
//    }];
}

- (void)renderAxisLine:(CALayer *)contentLayer {
    if (self.axis.axisLineDisabled) {
        return;
    }

    CAShapeLayer *layer = [self cc_requestLayersCacheWithMakerKey:NSStringFromClass(CAShapeLayer.class)];
    [CALayer quickUpdateLayer:^{
        layer.frame         = self.viewPixelHandler.contentRect;
        [contentLayer addSublayer:layer];
    }];

    UIBezierPath *path = UIBezierPath.bezierPath;
    if (self.axis.dependency == CCYAsixDependencyLeft) {
        [path moveToPoint:[contentLayer convertPoint:CGPointMake(self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentBottom) toLayer:layer]];
        [path addLineToPoint:[contentLayer convertPoint:CGPointMake(self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentTop) toLayer:layer]];
    } else if (self.axis.dependency == CCYAsixDependencyRight) {
        [path moveToPoint:[contentLayer convertPoint:CGPointMake(self.viewPixelHandler.contentRight, self.viewPixelHandler.contentBottom) toLayer:layer]];
        [path addLineToPoint:[contentLayer convertPoint:CGPointMake(self.viewPixelHandler.contentRight, self.viewPixelHandler.contentTop) toLayer:layer]];
    }

    [CALayer quickUpdateLayer:^{
        layer.masksToBounds = YES;
        layer.strokeColor   = self.axis.axisColor.CGColor;
        layer.lineWidth     = self.axis.axisLineWidth;
        layer.path = path.CGPath;
    }];
}

- (void)renderGridLines:(CALayer *)contentLayer {
    if (!self.axis.gridLineEnabled) {
        return;
    }

    CAShapeLayer *layer = [self cc_requestLayersCacheWithMakerKey:NSStringFromClass(CAShapeLayer.class)];
    [CALayer quickUpdateLayer:^{
        layer.frame         = self.viewPixelHandler.contentRect;
        [contentLayer addSublayer:layer];
    }];

    UIBezierPath *path = UIBezierPath.bezierPath;
    CGFloat xPos       = 0.f;
    for (NSNumber *num in self.axis.entities) {
        CGPoint position = CGPointMake(0, num.doubleValue);
        position = [self.transformer pointToPixel:position forAnimationPhaseY:1];
        xPos     = self.viewPixelHandler.contentLeft;

        if ([self.viewPixelHandler isInBoundsTop:position.y] && [self.viewPixelHandler isInBoundsBottom:position.y]) {
            [path moveToPoint:[contentLayer convertPoint:CGPointMake(xPos, position.y) toLayer:layer]];
            [path addLineToPoint:[contentLayer convertPoint:CGPointMake(self.viewPixelHandler.contentRight, position.y) toLayer:layer]];
        }
    }

    [CALayer quickUpdateLayer:^{
        layer.masksToBounds = YES;
        layer.strokeColor   = self.axis.gridColor.CGColor;
        layer.lineWidth     = self.axis.gridLineWidth;
        layer.path = path.CGPath;
        [contentLayer addSublayer:layer];
    }];
}

- (void)renderLabels:(CALayer *)contentLayer {
    if (self.axis.labelDisable) {
        return;
    }

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
            CATextLayer *layer = [self cc_requestLayersCacheWithMakerKey:NSStringFromClass(CATextLayer.class)];

            [CALayer quickUpdateLayer:^{
                layer.masksToBounds = YES;
                layer.font          = (__bridge CTFontRef)self.axis.font;
                layer.fontSize        = self.axis.font.pointSize;
                layer.foregroundColor = self.axis.labelColor.CGColor;
                layer.contentsScale   = CCBaseUtility.currentScale;
                layer.alignmentMode   = kCAAlignmentCenter;

                [text drawTextInLayer:layer point:CGPointMake(position.x, position.y + self.axis.yLabelOffset) anchor:anchor attributes:@{ NSFontAttributeName: self.axis.font, NSForegroundColorAttributeName: self.axis.labelColor }];

                [contentLayer addSublayer:layer];
            }];
        }
    }
}

- (void)processAxisEntities:(CGFloat)min:(CGFloat)max {
}

@end
