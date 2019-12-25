//
//  CCBarDataChartRenderer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/20.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCBarDataChartRenderer.h"
#import "CCRendererBase+LayerCache.h"

@implementation CCBarDataChartRenderer
- (instancetype)initWithViewHandler:(CCChartViewPixelHandler *)viewPixelHandler transform:(CCChartTransformer *)transformer DataProvider:(id<CCProtocolChartDataProvider>)dataProvider {
    self = [super initWithViewHandler:viewPixelHandler transform:transformer DataProvider:dataProvider];
    if (self) {
        [self cc_registerLayerMaker:^__kindof CALayer *_Nonnull {
            return CAShapeLayer.layer;
        } forKey:NSStringFromClass(CAShapeLayer.class)];
    }
    return self;
}

- (void)renderData:(CALayer *)contentLayer {
    [self cc_releaseAllLayerBackToBufferPool];

    CCChartData *data = self.dataProvider.data;
    CCBarChartDataSet *dataSet = [[data dataSetWithName:kCCNameBarDataSet] lastObject];
    if (dataSet == nil) {
        return;
    }

    CGFloat barWidth   = fabs([self.transformer distanceBetweenSpace:dataSet.entityDistancePercent]);
    CGFloat halfBarWidth = barWidth / 2;

    CAShapeLayer *layer = [self cc_requestLayersCacheWithMakerKey:NSStringFromClass(CAShapeLayer.class)];
    [CALayer quickUpdateLayer:^{
        layer.frame         = self.viewPixelHandler.contentRect;
        [contentLayer addSublayer:layer];
    }];
    
    UIBezierPath *path = UIBezierPath.bezierPath;
    
    for (NSInteger i = 0; i < dataSet.entities.count; i++) {
        id<CCProtocolChartDataEntityBase> entity = dataSet.entities[i];
        CGPoint pixel = [self.transformer pointToPixel:CGPointMake(i, entity.value) forAnimationPhaseY:1];
        if ([self.viewPixelHandler isInBoundsLeft:pixel.x + halfBarWidth] && [self.viewPixelHandler isInBoundsRight: pixel.x - halfBarWidth]) {
            // 这里画一个圆角矩形
            [path appendPath:[UIBezierPath bezierPathWithRoundedRect:[contentLayer convertRect:CGRectMake(pixel.x - halfBarWidth, pixel.y,barWidth, self.viewPixelHandler.contentBottom - pixel.y) toLayer:layer] cornerRadius:halfBarWidth]];
        }
    }
    
    [CALayer quickUpdateLayer:^{
        layer.path = path.CGPath;
        layer.fillColor = dataSet.color.CGColor;
        layer.masksToBounds = YES;
    }];
}

@end
