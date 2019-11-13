//
//  CCKLineChartDataSet.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCChartDataSetBase.h"
#import "CCKLineDataEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCKLineChartDataSet : CCChartDataSetBase

- (instancetype)initWithVals:(NSArray<CCKLineDataEntity *> *)entities withName:(NSString *)name;

@property (nonatomic, strong) NSArray<CCKLineDataEntity *> *entities;

@end

NS_ASSUME_NONNULL_END
