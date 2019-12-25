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

extern CCDataSetName const _Nonnull kCCNameKLineDataSet;

NS_ASSUME_NONNULL_BEGIN

@interface CCKLineChartDataSet : CCChartDataSetBase

- (instancetype)initWithEntities:(NSArray<CCKLineDataEntity *> *)entities withName:(nullable NSString *)name;

@property (nonatomic, strong) NSArray<CCKLineDataEntity *> *entities;

/// 上升颜色
@property (nonatomic, strong) UIColor *risingColor;

/// 下降颜色
@property (nonatomic, strong) UIColor *fallingColor;

/// 需要留意一下k线十字星的颜色是什么...这里默认是灰色
@property (nonatomic, strong) UIColor *flatColor;

/// 是否填充上升蜡烛图
@property (nonatomic, assign) BOOL isRisingFill;

/// 是否填充下降蜡烛图
@property (nonatomic, assign) BOOL isFallingFill;


/**
 高亮信息
 */
@property (nonatomic, strong) UIColor *highlightColor;

@property (nonatomic, assign) CGFloat lineWidth;

@end

NS_ASSUME_NONNULL_END
