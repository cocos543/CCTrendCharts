//
//  CCLineDataChartRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/22.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDataChartRenderer.h"
#import "CCLineChartDataSet.h"
#import "CCLineMADataSet.h"

NS_ASSUME_NONNULL_BEGIN

/// 线形图渲染器
@interface CCLineDataChartRenderer : CCDataChartRenderer

/// 请求获取指定索引下的图层
/// @param index 索引
- (CAShapeLayer *)requestLayersCacheByIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
