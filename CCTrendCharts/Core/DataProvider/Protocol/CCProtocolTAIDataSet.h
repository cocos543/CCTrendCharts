//
//  CCProtocolTAIDataSet.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/29.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCProtocolChartDataSet.h"

/// 技术指标数据集 technical analysis indicators
@protocol CCProtocolTAIDataSet <CCProtocolChartDataSet>

/// 计算指标数值
/// @param rawEntities 新追加的原生数据
- (void)calcIndicatorUseAppending:(NSArray<id<CCProtocolChartDataEntityBase>> *)rawEntities;

- (instancetype)initWithRawEntities:(NSArray<id<CCProtocolChartDataEntityBase>> *)rawEntities N:(NSUInteger)N;

/// 把原生数据转成对应的指标数据
///
/// 在这里实现了具体的指标算法
/// @param rawEntities 原生数据
+ (NSArray<id<CCProtocolChartDataEntityBase>> *)rawEntitiesToEntities:(NSArray<id<CCProtocolChartDataEntityBase>> *)rawEntities;

/// 指标用于展示的名字
@property (nonatomic, strong) NSString *label;

@end
