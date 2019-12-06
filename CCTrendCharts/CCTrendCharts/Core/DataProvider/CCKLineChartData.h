//
//  CCKLineChartData.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartData.h"
#import "CCTAIConfig.h"

//运行时的是数据集类应该是CCKLineChartDataSet或者CCVolumeChartDataSet
#import "CCKLineChartDataSet.h"
#import "CCVolumeChartDataSet.h"

#import "CCLineMADataSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCKLineChartData : CCChartData


/// 调用该方法之后, ChartData会根据config计算并生成数据集
/// @param config 配置
- (void)notifyTAIConfigChange:(CCTAIConfig *)config;

@end

NS_ASSUME_NONNULL_END
