//
//  CCBarChartDataSet.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/12/24.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartDataSetBase.h"

NS_ASSUME_NONNULL_BEGIN

extern CCDataSetName const _Nonnull kCCNameBarDataSet;

/// 适用于柱型图
@interface CCBarChartDataSet : CCChartDataSetBase


/// 实体绘制的尺寸在两个轴的百分比
///
/// 默认值 0.7
@property (nonatomic, assign) CGFloat entityDistancePercent;

@end

NS_ASSUME_NONNULL_END
