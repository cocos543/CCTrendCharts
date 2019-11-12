//
//  CCKLineDataEntity.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartDataEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCKLineDataEntity : CCChartDataEntity


/// 最高价的
@property (nonatomic, assign) CGFloat highest;

/// 最低价的
@property (nonatomic, assign) CGFloat lowest;

/// 开盘价
@property (nonatomic, assign) CGFloat opening;

/// 收盘价
@property (nonatomic, assign) CGFloat closing;

/// 成交量(股)
@property (nonatomic, assign) CGFloat volume;

/// 成交额
@property (nonatomic, assign) CGFloat amount;

/// 换手率
@property (nonatomic, assign) CGFloat turnoverrate;

@end

NS_ASSUME_NONNULL_END
