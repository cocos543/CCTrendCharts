//
//  CCTAILegendRenderer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/12/2.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCTAILegendRenderer.h"
#import <CoreText/CTFont.h>

@interface CCTAILegendRenderer () {
    CGFloat xPos;
}

@end

@implementation CCTAILegendRenderer

- (void)beginRenderingInLayer:(CALayer *)contentLayer atIndex:(NSInteger)index {
    xPos = 24;
    int i = 0;
    CCChartData *data = self.dataProvider.data;
    for (id<CCProtocolChartDataSet> dataSet in data.dataSets) {
        if ([dataSet conformsToProtocol:@protocol(CCProtocolTAIDataSet)]) {
            id<CCProtocolTAIDataSet> taiDataSet   = (id<CCProtocolTAIDataSet>)dataSet;
            id<CCProtocolChartDataEntityBase> val;
            if (index < dataSet.entities.count) {
                val = taiDataSet.entities[index];
            }

            CATextLayer *layer = [self requestLayersCacheByIndex:i layerClass:^__kindof CALayer *_Nonnull {
                return CATextLayer.layer;
            }];

            // 根据文案的长度设置layer的frame
            NSString *label;
            if (!val) {
                label = [NSString stringWithFormat:@"%@:-", taiDataSet.label];
            } else {
                label = [NSString stringWithFormat:@"%@:%@", taiDataSet.label, [taiDataSet.formatter stringFromNumber:@(val.value)]];
            }

            CGSize size = [label sizeWithAttributes:@{ NSFontAttributeName: taiDataSet.font }];

            [CALayer quickUpdateLayer:^{
                [contentLayer addSublayer:layer];

                layer.frame           = CGRectMake(self->xPos, 0, size.width, size.height);
                layer.font            = (__bridge CTFontRef)taiDataSet.font;
                layer.fontSize        = taiDataSet.font.pointSize;
                layer.string          = label;

                layer.foregroundColor = taiDataSet.color.CGColor;
                layer.contentsScale   = CCBaseUtility.currentScale;
                layer.alignmentMode   = kCAAlignmentCenter;
            }];

            xPos = xPos + taiDataSet.rightInterval + size.width;
            i++;
        }
    }
}

@end
