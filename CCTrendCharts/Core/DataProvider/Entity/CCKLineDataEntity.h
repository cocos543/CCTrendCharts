//
//  CCKLineDataEntity.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartDataEntity.h"

NS_ASSUME_NONNULL_BEGIN


// 用于表示当前实体是上升还是下降还是无状态(开盘等于收盘, 价格和前一天收盘价一样)
typedef NS_ENUM(NSUInteger, CCKLineDataEntityState) {
    CCKLineDataEntityStateRising,
    CCKLineDataEntityStateFalling,
    CCKLineDataEntityStateNone,
};

@interface CCKLineDataEntity : CCChartDataEntity


/// 实体状态(升降平)
///
/// 已经支持股票趋势和24小时开盘的趋势图(虚拟币)
@property (nonatomic, assign, readonly) CCKLineDataEntityState entityState;

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


/// 价格变化百分比
///
/// 这里需要注意, 股票和虚拟币不同, 股票不是24小时交易, 而且有盘前盘后竞价, 第2天的开盘价不一定等于第1天的收盘价.
/// 所以当天开盘价等于收盘价时, 需要配合changing属性来确定绘制的颜色.
/// 如果不提供该值, 默认为0.0
@property (nonatomic, assign) CGFloat changing;


@end

NS_ASSUME_NONNULL_END
