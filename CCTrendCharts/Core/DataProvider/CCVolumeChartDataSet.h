//
//  CCVolumeChartDataSet.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/21.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCKLineChartDataSet.h"
#import "CCVolumeDataEntity.h"

extern CCDataSetName const _Nonnull kCCVolumeChartDataSet;

NS_ASSUME_NONNULL_BEGIN


/// 适用于交易量柱型图的数据集
@interface CCVolumeChartDataSet : CCKLineChartDataSet

- (instancetype)initWithKLineChartDataSet:(CCKLineChartDataSet *)dataSet;

@end

NS_ASSUME_NONNULL_END
