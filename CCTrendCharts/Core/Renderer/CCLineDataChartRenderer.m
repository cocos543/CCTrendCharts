//
//  CCLineDataChartRenderer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/22.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCLineDataChartRenderer.h"

#import "CCLineSegment.h"

@interface CCLineDataChartRenderer ()

/// 图层池, 可以动态添加新的图层
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *layersCache;

@end

@implementation CCLineDataChartRenderer

- (void)_removeAllLayers {
    for (CALayer *layer in self.layersCache) {
        [layer removeFromSuperlayer];
    }
}

/// 根据传入的类型, 绘制直线或者贝塞尔线
/// @param path 贝塞尔对象
/// @param start 起点
/// @param end 终点
/// @param type 绘制类型
- (void)_addLineInPath:(UIBezierPath *)path start:(CGPoint)start end:(CGPoint)end using:(CCLineChartDrawType)type {
    // 绘制直线(折现)
    if (type == CCLineChartDrawTypeLine) {
        [path addLineToPoint:end];
    } else if (type == CCLineChartDrawTypeCurve) {
        // 绘制贝塞尔曲线
        [path addCurveToPoint:end controlPoint1:CGPointMake((start.x + end.x) / 2, start.y) controlPoint2:CGPointMake((start.x + end.x) / 2, end.y)];
    }
}


#pragma mark - Public

- (CAShapeLayer *)requestLayersCacheByIndex:(NSInteger)index {
    if (index >= self.layersCache.count) {
        [self.layersCache addObject:CAShapeLayer.layer];
    }
    return self.layersCache[index];
}


#pragma mark - CCProtocolDataChartRenderer

- (void)renderData:(CALayer *)contentLayer {
    [self _removeAllLayers];
    
    NSArray <CCLineChartDataSet *> *array = [self.dataProvider.data dataSetWithName:kCCNameLineDataSet];

    // 每一个dataSet都对应一条完整的线型, 这里直接遍历dataSet数组进行渲染
    for (int i = 0; i < array.count; i++) {
        CCLineChartDataSet *dataSet = array[i];

        UIBezierPath *path = UIBezierPath.bezierPath;

        CAShapeLayer *layer         = [self requestLayersCacheByIndex:i];
        layer.masksToBounds = YES;
        layer.frame         = self.viewPixelHandler.contentRect;
        [contentLayer addSublayer:layer];

        layer.strokeColor   = dataSet.color.CGColor;
        layer.lineWidth     = dataSet.lineWidth;
        layer.lineCap       = dataSet.lineCap;
        layer.lineJoin      = dataSet.lineJoin;
        layer.fillColor     = dataSet.fillColor.CGColor;

        BOOL fillRequire = NO;
        if (![dataSet.fillColor isEqual:UIColor.clearColor]) {
            fillRequire = YES;
        }

        // 边缘点到区域外的点之间的连线, 如果是在区域内的部分, 需要画出来, 这样看起来线段才能充满屏幕.

        // 标记是否开始绘制第一个节点
        BOOL flag       = NO;
        NSInteger lastX = 0;

        // 只有一个点, 无需绘制
        if (dataSet.entities.count < 1) {
            return;
        }
        for (int i = 1; i < dataSet.entities.count; i++) {
            id<CCProtocolChartDataEntityBase> entity    = dataSet.entities[i];
            id<CCProtocolChartDataEntityBase> perEntity = dataSet.entities[i - 1];

            CGPoint start = [self.transformer pointToPixel:CGPointMake(perEntity.xIndex, perEntity.value) forAnimationPhaseY:1];
            CGPoint end   = [self.transformer pointToPixel:CGPointMake(entity.xIndex, entity.value) forAnimationPhaseY:1];

            // 线段两个点都在区域外时, 不需要绘制
            if (start.x < self.viewPixelHandler.contentLeft && end.x < self.viewPixelHandler.contentLeft) {
                continue;
            }
            if (start.x > self.viewPixelHandler.contentRight && end.x > self.viewPixelHandler.contentRight) {
                continue;
            }

            // 因为当前的layer和contentLayer的frame不同, 所以需要把点的坐标系调整到layer的坐标系上
            start = [layer convertPoint:start fromLayer:contentLayer];
            end   = [layer convertPoint:end fromLayer:contentLayer];

            // 填充和非填充分开绘制
            if (fillRequire) {
                if (!flag) {
                    // 确保起始位置从y轴原点位置开始
                    [path moveToPoint:[layer convertPoint:[self.transformer pointToPixel:CGPointMake(perEntity.xIndex, self.dataProvider.chartMinY - dataSet.lineWidth) forAnimationPhaseY:1] fromLayer:contentLayer]];
                    [path addLineToPoint:start];

                    flag = YES;
                }
                
                [self _addLineInPath:path start:start end:end using:dataSet.drawType];
                lastX = i;
            } else {
                // 非填充的, 只需要把每个线段都作为子线段单独绘制即可
                [path moveToPoint:start];
                [self _addLineInPath:path start:start end:end using:dataSet.drawType];
            }
        }

        if (fillRequire) {
            [path addLineToPoint:[layer convertPoint:[self.transformer pointToPixel:CGPointMake(lastX, self.dataProvider.chartMinY - dataSet.lineWidth) forAnimationPhaseY:1] fromLayer:contentLayer]];
            [path closePath];
        }

        layer.path = path.CGPath;
    }
}

#pragma mark - Setter & Getter
- (NSMutableArray<CAShapeLayer *> *)layersCache {
    if (!_layersCache) {
        _layersCache = @[].mutableCopy;
    }

    return _layersCache;
}
@end
