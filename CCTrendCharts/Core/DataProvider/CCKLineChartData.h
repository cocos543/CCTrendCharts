//
//  CCKLineChartData.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartData.h"

//运行时的是数据集类应该是CCKLineChartDataSet或者CCVolumeChartDataSet
#import "CCKLineChartDataSet.h"
#import "CCVolumeChartDataSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCKLineChartData : CCChartData

- (NSArray<CCKLineChartDataSet *> *)dataSets;

- (NSArray<CCKLineChartDataSet *> *)dataSetWithName:(CCDataSetName)name;

@end

NS_ASSUME_NONNULL_END
