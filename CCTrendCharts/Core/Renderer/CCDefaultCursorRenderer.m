//
//  CCDefaultCursorRenderer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/4.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefaultCursorRenderer.h"

@interface CCDefaultCursorRenderer ()
@end

@implementation CCDefaultCursorRenderer
@synthesize cursor = _cursor;

- (instancetype)initWithCursor:(id<CCProtocolCursorBase>)cursor viewHandler:(CCChartViewPixelHandler *)viewPixelHandler transform:(CCChartTransformer *)transformer DataProvider:(id<CCProtocolChartDataProvider>)dataProvider {
    self = [super initWithViewHandler:viewPixelHandler transform:transformer DataProvider:dataProvider];
    if (self) {
        _cursor = cursor;
    }
    return self;
}

- (void)beginRenderingInLayer:(CALayer *)layer center:(CGPoint)center {
    CGPoint point = [self.transformer pixelToPoint:CGPointMake(center.x, 0) forAnimationPhaseY:1];

    // 将center的x坐标强制绑定到匹配的index上.
    center.x = [self.transformer pointToPixel:CGPointMake((NSInteger)point.x, 0) forAnimationPhaseY:1].x;

    [self renderCursor:layer center:center];

    [self renderLeftLabel:layer center:center];

    [self renderRightLabel:layer center:center];

    [self renderXLabel:layer center:center];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGImageRef img   = CGBitmapContextCreateImage(ctx);

    [CALayer quickUpdateLayer:^{
        layer.contents = (__bridge_transfer id)img;
    }];
}

- (void)renderCursor:(CALayer *)layer center:(CGPoint)center {
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSaveGState(ctx);
    {
        CGContextSetStrokeColorWithColor(ctx, self.cursor.lineColor.CGColor);
        CGContextSetLineWidth(ctx, self.cursor.lineWidth);
        CGContextSetLineCap(ctx, self.cursor.lineCap);

        if (self.cursor.lineDashLengths.count) {
            CGFloat *carr = malloc(sizeof(CGFloat) * self.cursor.lineDashLengths.count);
            for (int i = 0; i < self.cursor.lineDashLengths.count; i++) {
                carr[i] = [self.cursor.lineDashLengths[i] floatValue];
            }
            CGContextSetLineDash(ctx, self.cursor.lineDashPhase, carr, self.cursor.lineDashLengths.count);
            free(carr);
        }

        CGPoint horizontalStart, horizontalEnd, verticalStart, verticalEnd;
        horizontalStart = CGPointMake(self.viewPixelHandler.contentLeft, center.y);
        horizontalEnd   = CGPointMake(self.viewPixelHandler.contentRight, center.y);

        verticalStart   = CGPointMake(center.x, self.viewPixelHandler.contentTop);
        verticalEnd     = CGPointMake(center.x, self.viewPixelHandler.contentBottom);

        CGContextMoveToPoint(ctx, horizontalStart.x, center.y);
        CGContextAddLineToPoint(ctx, horizontalEnd.x, center.y);

        CGContextMoveToPoint(ctx, center.x, verticalStart.y);
        CGContextAddLineToPoint(ctx, center.x, verticalEnd.y);

        CGContextStrokePath(ctx);
    }
    CGContextRestoreGState(ctx);
}

/// 简单绘制出指示器Y方向对应的值
/// @param layer 图层
/// @param center 指示器中心位置
- (void)renderLeftLabel:(CALayer *)layer center:(CGPoint)center {
    if (!self.leftAxis) {
        return;
    }
    
    if (center.y < self.viewPixelHandler.contentTop || center.y > self.viewPixelHandler.contentBottom) {
        return;
    }

    CGContextRef ctx  = UIGraphicsGetCurrentContext();

    NSString *text    = [self.leftAxis.formatter stringFromNumber:@([self.transformer pixelToPoint:CGPointMake(0, center.y) forAnimationPhaseY:1].y)];

    CGSize textSize   = [text sizeWithAttributes:@{ NSFontAttributeName: self.cursor.font }];
    CGPoint textPoint = CGPointMake(self.viewPixelHandler.contentLeft + textSize.width / 2, center.y);
    [text drawTextIn:ctx x:textPoint.x y:textPoint.y anchor:CGPointMake(0.5, 1) attributes:@{ NSFontAttributeName: self.cursor.font, NSForegroundColorAttributeName: self.cursor.labelColor }];
}

- (void)renderRightLabel:(CALayer *)layer center:(CGPoint)center {
    if (!self.rightAxis) {
        return;
    }

    if (center.y < self.viewPixelHandler.contentTop || center.y > self.viewPixelHandler.contentBottom) {
        return;
    }

    CGContextRef ctx  = UIGraphicsGetCurrentContext();

    NSString *text    = [self.leftAxis.formatter stringFromNumber:@([self.transformer pixelToPoint:CGPointMake(0, center.y) forAnimationPhaseY:1].y)];

    CGSize textSize   = [text sizeWithAttributes:@{ NSFontAttributeName: self.cursor.font }];
    CGPoint textPoint = CGPointMake(self.viewPixelHandler.contentRight - textSize.width / 2, center.y);

    [text drawTextIn:ctx x:textPoint.x y:textPoint.y anchor:CGPointMake(0.5, 1) attributes:@{ NSFontAttributeName: self.cursor.font, NSForegroundColorAttributeName: self.cursor.labelColor }];
}

- (void)renderXLabel:(CALayer *)layer center:(CGPoint)center {
    if (!self.xAxis) {
        return;
    }

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // 简单同步xAxis上的实体
    NSInteger index  = @([self.transformer pixelToPoint:CGPointMake(center.x, 0) forAnimationPhaseY:1].x).integerValue;

    if (index >= 0 && index < self.dataProvider.data.xVals.count) {
        NSString *text = self.xAxis.entities[index];
        [text drawTextIn:ctx x:center.x y:self.viewPixelHandler.contentBottom anchor:CGPointMake(0.5, 0) attributes:@{ NSFontAttributeName: self.cursor.font, NSForegroundColorAttributeName: self.cursor.labelColor }];
    }
}

@end
