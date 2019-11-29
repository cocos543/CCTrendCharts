//
//  CCLineMADataSet.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/29.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCLineChartDataSet.h"
#import "CCProtocolTAIDataSet.h"

#import "CCKLineDataEntity.h"

NS_ASSUME_NONNULL_BEGIN

/// MA指标 (Moving average)
@interface CCLineMADataSet : CCLineChartDataSet <CCProtocolTAIDataSet>

- (instancetype)initWithRawEntities:(NSArray<CCKLineDataEntity *> *)rawEntities N:(NSUInteger)N NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithVals:(NSArray<id<CCProtocolChartDataEntityBase>> *)entities withName:(CCDataSetName)name NS_UNAVAILABLE;

/// N日平均值
@property (nonatomic, assign) NSUInteger N;

@end

NS_ASSUME_NONNULL_END
