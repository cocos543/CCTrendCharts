//
//  CCLineChartDataSet.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/22.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartDataSetBase.h"

extern CCDataSetName const _Nonnull kCCNameLineDataSet;

typedef NS_ENUM (NSUInteger, CCLineChartDrawType) {
    CCLineChartDrawTypeLine = 0, // 折线图
    CCLineChartDrawTypeCurve // 曲线图
};

NS_ASSUME_NONNULL_BEGIN

/// 线形图数据集
///
/// 用于充当线形图渲染器的数据提供者
@interface CCLineChartDataSet : CCChartDataSetBase

/// 绘制类型
@property (nonatomic, assign) CCLineChartDrawType drawType;

/// 线宽
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) CAShapeLayerLineCap lineCap;

@property (nonatomic, assign) CAShapeLayerLineJoin lineJoin;

// 填充线条和两轴之间的颜色
@property (nonatomic, strong) UIColor *fillColor;

@end

NS_ASSUME_NONNULL_END
