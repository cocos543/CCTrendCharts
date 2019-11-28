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

- (CALayer *)subContentLayer {
    if (!_subContentLayer) {
        _subContentLayer = CALayer.layer;
    }

    return _subContentLayer;
}

#pragma mark - Public
- (void)renderDataWithRising:(UIBezierPath *)risingPath fallingPath:(UIBezierPath *)fallingPath flatPath:(UIBezierPath *)flatPath usingDataSetName:(CCDataSetName)name inContentLayer:(CALayer *)contentLayer {
    CCKLineChartData *data       = self.dataProvider.klineChartData;
    CCKLineChartDataSet *dataSet = [[data dataSetWithName:name] lastObject];

    // 上升图层
    CAShapeLayer *risingLayer    = self.risingLayer;
    risingLayer.frame       = CGRectMake(0, 0, contentLayer.frame.size.width, contentLayer.frame.size.height);
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
    fallingLayer.frame = CGRectMake(0, 0, contentLayer.frame.size.width, contentLayer.frame.size.height);
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
        flatLayer.frame       = CGRectMake(0, 0, contentLayer.frame.size.width, contentLayer.frame.size.height);
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
    
    // 创建一个临时图层, 用于转换坐标系(因为图层的frame和contentLayer.frame不同)
    CALayer *subContentLayer = self.subContentLayer;
    subContentLayer.masksToBounds = YES;

    [CALayer quickUpdateLayer:^{
        subContentLayer.frame = self.viewPixelHandler.contentRect;
        [contentLayer addSublayer:subContentLayer];
    }];
    
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
        if (xPos + halfWidth < self.viewPixelHandler.contentLeft || xPos - halfWidth > self.viewPixelHandler.contentRight) {
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
        [path moveToPoint:[subContentLayer convertPoint:CGPointMake(xPos, yMax) fromLayer:contentLayer]];
        [path addLineToPoint:[subContentLayer convertPoint:CGPointMake(xPos, candleTop) fromLayer:contentLayer]];

        [path moveToPoint:[subContentLayer convertPoint:CGPointMake(xPos, yMin) fromLayer:contentLayer]];
        [path addLineToPoint:[subContentLayer convertPoint:CGPointMake(xPos, candleBottom) fromLayer:contentLayer]];

        // 绘制蜡烛部分
        [path moveToPoint:[subContentLayer convertPoint:CGPointMake(xPos - halfWidth, candleTop) fromLayer:contentLayer]];
        [path addLineToPoint:[subContentLayer convertPoint:CGPointMake(xPos + halfWidth, candleTop) fromLayer:contentLayer]];
        [path addLineToPoint:[subContentLayer convertPoint:CGPointMake(xPos + halfWidth, candleBottom) fromLayer:contentLayer]];
        [path addLineToPoint:[subContentLayer convertPoint:CGPointMake(xPos - halfWidth, candleBottom) fromLayer:contentLayer]];
        [path closePath];

        if (val.entityState == CCKLineDataEntityStateFalling) {
            [fallingPath appendPath:path];
        } else if (val.entityState == CCKLineDataEntityStateRising) {
            [risingPath appendPath:path];
        } else if (val.entityState == CCKLineDataEntityStateNone) {
            [flatPath appendPath:path];
        }
    }

    [self renderDataWithRising:risingPath fallingPath:fallingPath flatPath:flatPath usingDataSetName:kCCNameKLineDataSet inContentLayer:subContentLayer];
    
}

- (void)renderHighlighted:(CAShapeLayer *)contentLayer {
}

@end
