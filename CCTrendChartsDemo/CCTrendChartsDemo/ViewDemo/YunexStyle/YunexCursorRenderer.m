//
//  YunexCursorRenderer.m
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "YunexCursorRenderer.h"

@implementation YunexCursorRenderer

- (instancetype)initWithDefaultCursorRenderer:(CCDefaultCursorRenderer *)cursorRenderer {
    self = [super initWithCursor:cursorRenderer.cursor viewHandler:cursorRenderer.viewPixelHandler transform:cursorRenderer.transformer DataProvider:cursorRenderer.dataProvider];
    self.leftAxis = cursorRenderer.leftAxis;
    self.rightAxis = cursorRenderer.rightAxis;
    self.xAxis = cursorRenderer.xAxis;
    return self;
}

- (void)renderLeftLabel:(CALayer *)layer center:(CGPoint)center {
    if (!self.leftAxis) {
        return;
    }

    if (center.y < self.viewPixelHandler.contentTop || center.y > self.viewPixelHandler.contentBottom) {
        return;
    }

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // 在label底部画一个绿色长方形, 这里只有一个颜色而且是固定的所以直接写死就可以了.
    // 当然可以重写CCDefaultCursor类把属性加到里面或者新建一个实现CCProtocolCursorBase协议的类即可.

    NSString *text  = [self.leftAxis.formatter stringFromNumber:@([self.transformer pixelToPoint:CGPointMake(0, center.y) forAnimationPhaseY:1].y)];

    CGSize textSize = [text sizeWithAttributes:@{ NSFontAttributeName: self.cursor.font }];

    // 已知游标中心点, 以及文本的尺寸, 可以求得文本底部矩形的对应左轴上的位置.
    CGRect rect     = CGRectMake(self.viewPixelHandler.contentLeft, center.y - textSize.height / 2, textSize.width + 16, textSize.height);

    CGContextSaveGState(ctx);
    {
        CGContextSetFillColorWithColor(ctx, [UIColor stringToColor:@"#55BE55" opacity:1].CGColor);
        // 画y轴上的矩形
        CGContextAddRect(ctx, rect);

        // 画x轴上的矩形
        CGContextFillPath(ctx);
    }
    CGContextRestoreGState(ctx);

    CGPoint textPoint = CGPointMake(self.viewPixelHandler.contentLeft + textSize.width / 2 + 8, center.y);
    [text drawTextIn:ctx x:textPoint.x y:textPoint.y anchor:CGPointMake(0.5, 0.5) attributes:@{ NSFontAttributeName: self.cursor.font, NSForegroundColorAttributeName: self.cursor.labelColor }];
}

- (void)renderRightLabel:(CALayer *)layer center:(CGPoint)center {
    // 不需要渲染右侧信息
}

- (void)renderXLabel:(CALayer *)layer center:(CGPoint)center {
    if (!self.xAxis) {
        return;
    }

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // 简单同步xAxis上的实体
    NSInteger index  = @([self.transformer pixelToPoint:CGPointMake(center.x, 0) forAnimationPhaseY:1].x).integerValue;

    if (index >= 0 && index < self.dataProvider.data.xVals.count) {
        NSString *text  = self.xAxis.entities[index];
        CGSize textSize = [text sizeWithAttributes:@{ NSFontAttributeName: self.cursor.font }];

        CGRect rect     = CGRectMake(center.x - textSize.width / 2 - 8, self.viewPixelHandler.contentBottom, textSize.width + 16, textSize.height);

        CGContextSaveGState(ctx);
        {
            CGContextSetFillColorWithColor(ctx, [UIColor stringToColor:@"#FF1F39" opacity:1].CGColor);
            // 绘制一个圆角矩形
             UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height/2];
            CGContextAddPath(ctx, path.CGPath);
            CGContextFillPath(ctx);
        }
        CGContextRestoreGState(ctx);

        [text drawTextIn:ctx x:center.x y:self.viewPixelHandler.contentBottom anchor:CGPointMake(0.5, 0) attributes:@{ NSFontAttributeName: self.cursor.font, NSForegroundColorAttributeName: self.cursor.labelColor }];
    }
}



@end
