//
//  CCVolumeDataChartRenderer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/20.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCVolumeDataChartRenderer.h"

@interface CCVolumeDataChartRenderer ()

@end

@implementation CCVolumeDataChartRenderer

- (void)renderData:(CALayer *)contentLayer {
    // 交易量柱型图的实体颜色是根据k线实体的涨跌决定的.
    // 所以这里和k线数据渲染器一样, 通过多个图层组合而成.
    CCKLineChartData *data        = self.dataProvider.klineChartData;
    CCVolumeChartDataSet *dataSet = (CCVolumeChartDataSet *)[[data dataSetWithName:kCCVolumeChartDataSet] lastObject];

    CALayer *subContentLayer = self.subContentLayer;
    subContentLayer.masksToBounds = YES;

    [CALayer quickUpdateLayer:^{
        subContentLayer.frame = self.viewPixelHandler.contentRect;
        [contentLayer addSublayer:subContentLayer];
    }];
    
    // 一半宽的大小
    CGFloat halfWidth         = fabs([self.transformer distanceBetweenSpace:CC_KLINE_ENTITY_DISTANCE_PERCENT / 2]);

    // 绘制上升路径
    UIBezierPath *risingPath  = UIBezierPath.bezierPath;
    // 绘制下降路径
    UIBezierPath *fallingPath = UIBezierPath.bezierPath;
    // 用于绘制K线十字星, 这种情况比较少见, 出现了才需要绘制.
    UIBezierPath *flatPath    = nil;

    // 临时路径
    UIBezierPath *path        = UIBezierPath.bezierPath;
    for (CCKLineDataEntity *val in dataSet.entities) {
        // 先确定位置
        CGFloat xPos = [self.transformer pointToPixel:CGPointMake(val.xIndex, 0) forAnimationPhaseY:1].x;
        if (xPos + halfWidth < self.viewPixelHandler.contentLeft || xPos - halfWidth > self.viewPixelHandler.contentRight) {
            continue;
        }
        [path removeAllPoints];

        // 柱高
        CGFloat yVal = val.volume;

        yVal = [self.transformer pointToPixel:CGPointMake(0, yVal) forAnimationPhaseY:1].y;
        
        [path moveToPoint:[subContentLayer convertPoint:CGPointMake(xPos - halfWidth, yVal) fromLayer:contentLayer]];
        [path addLineToPoint:[subContentLayer convertPoint:CGPointMake(xPos + halfWidth, yVal) fromLayer:contentLayer]];
        [path addLineToPoint:[subContentLayer convertPoint:CGPointMake(xPos + halfWidth, self.viewPixelHandler.contentBottom) fromLayer:contentLayer]];
        [path addLineToPoint:[subContentLayer convertPoint:CGPointMake(xPos - halfWidth, self.viewPixelHandler.contentBottom) fromLayer:contentLayer]];
        [path closePath];

        if (val.entityState == CCKLineDataEntityStateFalling) {
            [fallingPath appendPath:path];
        } else if (val.entityState == CCKLineDataEntityStateRising) {
            [risingPath appendPath:path];
        } else if (val.entityState == CCKLineDataEntityStateNone) {
            [flatPath appendPath:path];
        }
    }

    [self renderDataWithRising:risingPath fallingPath:fallingPath flatPath:flatPath usingDataSetName:kCCVolumeChartDataSet inContentLayer:subContentLayer];
}

@end
