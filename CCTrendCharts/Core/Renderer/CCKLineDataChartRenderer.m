//
//  CCKLineDataChartRenderer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/13.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCKLineDataChartRenderer.h"

@interface CCKLineDataChartRenderer ()

/// 图层池, 可以动态添加新的图层
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *layersCache;

@end

@implementation CCKLineDataChartRenderer


#pragma mark - Setter & Getter

- (CAShapeLayer *)risingLayer {
    if (!_risingLayer) {
        _risingLayer = CAShapeLayer.layer;
    }

    return _risingLayer;
}

- (CAShapeLayer *)fallingLayer {
    if (!_fallingLayer) {
        _fallingLayer = CAShapeLayer.layer;
    }

    return _fallingLayer;
}

- (CAShapeLayer *)flatLayer {
    if (!_flatLayer) {
        _flatLayer = CAShapeLayer.layer;
    }

    return _flatLayer;
}

#pragma mark - Public
- (void)renderDataWithRising:(UIBezierPath *)risingPath fallingPath:(UIBezierPath *)fallingPath flatPath:(UIBezierPath *)flatPath usingDataSetName:(CCDataSetName)name inContentLayer:(CALayer *)contentLayer {
    CCKLineChartData *data       = self.dataProvider.klineChartData;
    CCKLineChartDataSet *dataSet = [[data dataSetWithName:name] lastObject];

    // 上升图层
    CAShapeLayer *risingLayer    = self.risingLayer;
    risingLayer.frame       = contentLayer.frame;
    if (dataSet.isRisingFill) {
        risingLayer.fillColor = dataSet.risingColor.CGColor;
    } else {
        risingLayer.fillColor = UIColor.clearColor.CGColor;
    }
    risingLayer.lineWidth   = dataSet.lineWidth;
    risingLayer.strokeColor = dataSet.risingColor.CGColor;

    [contentLayer addSublayer:risingLayer];
    [CALayer quickUpdateLayer:^{
        risingLayer.path = risingPath.CGPath;
    }];

    // 下降图层
    CAShapeLayer *fallingLayer = self.fallingLayer;
    fallingLayer.frame = contentLayer.frame;
    if (dataSet.isFallingFill) {
        fallingLayer.fillColor = dataSet.fallingColor.CGColor;
    } else {
        fallingLayer.fillColor = UIColor.clearColor.CGColor;
    }

    fallingLayer.lineWidth   = dataSet.lineWidth;
    fallingLayer.strokeColor = dataSet.fallingColor.CGColor;
    [contentLayer addSublayer:fallingLayer];

    [CALayer quickUpdateLayer:^{
        fallingLayer.path = fallingPath.CGPath;
    }];

    // 平价图层
    if (flatPath) {
        CAShapeLayer *flatLayer = self.flatLayer;
        flatLayer.frame       = contentLayer.frame;
        flatLayer.lineWidth   = dataSet.lineWidth;
        flatLayer.strokeColor = dataSet.flatColor.CGColor;
        [contentLayer addSublayer:flatLayer];
        [CALayer quickUpdateLayer:^{
            flatLayer.path = flatPath.CGPath;
        }];
    } else {
        [self.flatLayer removeFromSuperlayer];
    }
}

- (void)renderData:(CALayer *)contentLayer {
    CCKLineChartData *data       = self.dataProvider.klineChartData;
    CCKLineChartDataSet *dataSet = [[data dataSetWithName:kCCNameKLineDataSet] lastObject];

    // 把两个实体中心轴分成3份, 分别占35%, 30%, 35%. 其中30%就是两个蜡烛图的距离, 35%是蜡烛图一半的大小.
    // 三部分共计100%
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
        if (xPos < self.viewPixelHandler.contentLeft || xPos > self.viewPixelHandler.contentRight) {
            continue;
        }
        [path removeAllPoints];

        // 确定蜡烛图最大值, 最小值
        CGFloat yMax = val.highest;
        CGFloat yMin = val.lowest;

        // 根据实体状态, 确定蜡烛矩形的顶部, 底部位置
        CGFloat candleTop = 0, candleBottom = 0;

        if (val.entityState == CCKLineDataEntityStateFalling) {
            candleTop    = val.opening;
            candleBottom = val.closing;
        } else if (val.entityState == CCKLineDataEntityStateRising) {
            candleBottom = val.opening;
            candleTop    = val.closing;
        } else if (val.entityState == CCKLineDataEntityStateNone) {
            if (!flatPath) {
                flatPath = UIBezierPath.bezierPath;
            }
            candleTop = candleBottom = val.opening;
        }

        yMax         = [self.transformer pointToPixel:CGPointMake(0, yMax) forAnimationPhaseY:1].y;
        yMin         = [self.transformer pointToPixel:CGPointMake(0, yMin) forAnimationPhaseY:1].y;
        candleTop    = [self.transformer pointToPixel:CGPointMake(0, candleTop) forAnimationPhaseY:1].y;
        candleBottom = [self.transformer pointToPixel:CGPointMake(0, candleBottom) forAnimationPhaseY:1].y;

        // 开始绘制内容
        [path moveToPoint:CGPointMake(xPos, yMax)];
        [path addLineToPoint:CGPointMake(xPos, candleTop)];

        [path moveToPoint:CGPointMake(xPos, yMin)];
        [path addLineToPoint:CGPointMake(xPos, candleBottom)];

        // 绘制蜡烛部分
        [path moveToPoint:CGPointMake(xPos - halfWidth, candleTop)];
        [path addLineToPoint:CGPointMake(xPos + halfWidth, candleTop)];
        [path addLineToPoint:CGPointMake(xPos + halfWidth, candleBottom)];
        [path addLineToPoint:CGPointMake(xPos - halfWidth, candleBottom)];
        [path closePath];

        if (val.entityState == CCKLineDataEntityStateFalling) {
            [fallingPath appendPath:path];
        } else if (val.entityState == CCKLineDataEntityStateRising) {
            [risingPath appendPath:path];
        } else if (val.entityState == CCKLineDataEntityStateNone) {
            [flatPath appendPath:path];
        }
    }

    [self renderDataWithRising:risingPath fallingPath:fallingPath flatPath:flatPath usingDataSetName:kCCNameKLineDataSet inContentLayer:contentLayer];
}

- (void)renderHighlighted:(CAShapeLayer *)contentLayer {
}

@end
