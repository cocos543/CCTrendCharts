//
//  CCDefaultXAxisRenderer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/12.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefaultXAxisRenderer.h"
#import "CCRendererBase+LayerCache.h"
@import CoreText.CTFont;

@implementation CCDefaultXAxisRenderer

- (instancetype)initWithAxis:(nonnull CCDefaultXAxis *)axis viewHandler:(nonnull CCChartViewPixelHandler *)viewPixelHandler transform:(nonnull CCChartTransformer *)transformer {
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
    [self cc_releaseAllLayerBackToBufferPool];
    [self.axis.formatter calcModulusWith:self.viewPixelHandler.contentWidth xSpace:[self.transformer distanceBetweenSpace:1] labelSize:self.axis.requireSize];

    [self renderAxisLine:contentLayer];
    [self renderGridLines:contentLayer];
    [self renderLabels:contentLayer];
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
    [path moveToPoint:[contentLayer convertPoint:CGPointMake(self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentBottom) toLayer:layer]];
    [path addLineToPoint:[contentLayer convertPoint:CGPointMake(self.viewPixelHandler.contentRight, self.viewPixelHandler.contentBottom) toLayer:layer]];

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
    for (int i = 0; i < self.axis.entities.count; i++) {
        CGPoint position = CGPointMake(i, 0);
        position = [self.transformer pointToPixel:position forAnimationPhaseY:1];
        if (position.x > self.viewPixelHandler.contentLeft && position.x < self.viewPixelHandler.contentRight) {
            if ([self.axis.formatter needToDrawLabelAt:i]) {
                [path moveToPoint:[contentLayer convertPoint:CGPointMake(position.x, self.viewPixelHandler.contentBottom) toLayer:layer]];
                [path addLineToPoint:[contentLayer convertPoint:CGPointMake(position.x, self.viewPixelHandler.contentTop) toLayer:layer]];
            }
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

    // 把文案绘制在x轴底部
    CGFloat yPos = 0.f;
    if (self.axis.labelPosition == CCXAxisLabelPositionBottom) {
        yPos = self.viewPixelHandler.contentBottom + self.axis.yLabelOffset;

        for (int i = 0; i < self.axis.entities.count; i++) {
            CGPoint position = CGPointMake(i, 0);
            position = [self.transformer pointToPixel:position forAnimationPhaseY:1];

            // 只绘制可视区域内的元素
            if (position.x >= self.viewPixelHandler.contentLeft && position.x <= self.viewPixelHandler.contentRight) {
                if ([self.axis.formatter needToDrawLabelAt:i]) {
                    CATextLayer *layer = [self cc_requestLayersCacheWithMakerKey:NSStringFromClass(CATextLayer.class)];

                    NSString *text     = self.axis.entities[i];
                    text = [self.axis.formatter stringForIndex:i origin:text];
                    [CALayer quickUpdateLayer:^{
                        layer.masksToBounds = YES;
                        layer.font          = (__bridge CTFontRef)self.axis.font;
                        layer.fontSize        = self.axis.font.pointSize;
                        layer.foregroundColor = self.axis.labelColor.CGColor;
                        layer.contentsScale   = CCBaseUtility.currentScale;
                        layer.alignmentMode   = kCAAlignmentCenter;

                        [text drawTextInLayer:layer point:CGPointMake(position.x, yPos) anchor:CGPointMake(0.5, 0) attributes:@{ NSFontAttributeName: self.axis.font, NSForegroundColorAttributeName: self.axis.labelColor }];

                        [contentLayer addSublayer:layer];
                    }];
                }
            }
        }
    } else if (self.axis.labelPosition == CCXAxisLabelPositionTop) {
        // 文案绘制在x轴顶部
    }
}

@end
