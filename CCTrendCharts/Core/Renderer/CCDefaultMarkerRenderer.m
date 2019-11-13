//
//  CCDefaultMarkerRenderer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/7.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefaultMarkerRenderer.h"

@interface CCDefaultMarkerRenderer () {
    // 0 左, 1 右
    BOOL _currentMarkerSied;
}

@end

@implementation CCDefaultMarkerRenderer

- (instancetype)initWithViewHandler:(CCChartViewPixelHandler *)viewPixelHandler transform:(CCChartTransformer *)transformer DataProvider:(id<CCProtocolChartDataProvider>)dataProvider {
    self = [super initWithViewHandler:viewPixelHandler transform:transformer DataProvider:dataProvider];
    if (self) {
        _currentMarkerSied = 1;
    }

    return self;
}

- (void)beginRenderingInLayer:(CALayer *)contentLayer atIndex:(NSInteger)index {
    // 获取当前index下完整的实体
    CCChartData *charData     = self.dataProvider.data;
    CCChartDataEntity *entity = [[charData entitiesForIndex:index] lastObject];

    // 作为示例, 这里简单绘制一下标记
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    {
        NSNumberFormatter *fmt   = [[NSNumberFormatter alloc] init];
        fmt.maximumFractionDigits = 4;
        fmt.minimumFractionDigits = 4;

        NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
        dateFmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
        dateFmt.dateFormat        = @"yyyy/MM/dd HH:mm:ss EEEE";

        NSString *yText   = [fmt stringFromNumber:@(entity.value)];
        NSString *xTest   = [NSString stringWithFormat:@"第:%@个", @(entity.xIndex)];
        NSString *title   = [dateFmt stringFromDate:[NSDate dateWithTimeIntervalSince1970:entity.timeInt]];
        UIFont *titleFont = [UIFont systemFontOfSize:10];
        CGSize titleSize  = [title sizeWithAttributes:@{ NSFontAttributeName: titleFont }];

        // 标记的矩形尺寸
        CGRect rect       = CGRectMake(0, self.viewPixelHandler.contentTop, titleSize.width, (titleSize.height + 8) * 3);

        if ([self.transformer pointToPixel:CGPointMake(index, 0) forAnimationPhaseY:1].x > self.viewPixelHandler.contentRight - rect.size.width) {
            rect.origin.x      = self.viewPixelHandler.contentLeft;
            _currentMarkerSied = 0;
        } else if ([self.transformer pointToPixel:CGPointMake(index, 0) forAnimationPhaseY:1].x < self.viewPixelHandler.contentLeft + rect.size.width) {
            rect.origin.x      = self.viewPixelHandler.contentRight - rect.size.width;
            _currentMarkerSied = 1;
        } else {
            if (_currentMarkerSied) {
                rect.origin.x = self.viewPixelHandler.contentRight - rect.size.width;
            } else {
                rect.origin.x = self.viewPixelHandler.contentLeft;
            }
        }

        CGContextSetFillColorWithColor(ctx, UIColor.grayColor.CGColor);
        CGContextAddRect(ctx, rect);
        CGContextFillPath(ctx);

        [title drawTextIn:ctx x:rect.origin.x y:rect.origin.y anchor:CGPointMake(0, 0) attributes:@{ NSFontAttributeName: titleFont }];
        [xTest drawTextIn:ctx x:rect.origin.x y:rect.origin.y + 15 anchor:CGPointZero attributes:@{ NSFontAttributeName: titleFont }];
        [yText drawTextIn:ctx x:rect.origin.x y:rect.origin.y + 30 anchor:CGPointZero attributes:@{ NSFontAttributeName: titleFont }];
    }
    CGContextRestoreGState(ctx);

    CGImageRef img = CGBitmapContextCreateImage(ctx);
    
    [CALayer quickUpdateLayer:^{
        contentLayer.contents = (__bridge_transfer id)img;
    }];
}

@end
