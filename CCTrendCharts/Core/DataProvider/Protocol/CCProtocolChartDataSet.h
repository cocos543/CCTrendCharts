//
//  CCProtocolChartDataSet.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCChartDataEntity.h"

typedef NSString * CCDataSetName;

@protocol CCProtocolChartDataSet <NSObject>
@required
- (instancetype)initWithVals:(NSArray<id<CCProtocolChartDataEntityBase>> *)entities withName:(CCDataSetName)name;


/// 计算数据集在指定范围内的最值
/// @param start 起点
/// @param end 终点
- (void)calcMinMaxStart:(NSInteger)start End:(NSInteger)end;


/// 获取指定index的实体, 这里index就是对应的x-index
/// @param index x轴上的索引
- (NSArray<id<CCProtocolChartDataEntityBase>> *)entityForIndex:(NSInteger)index;

/**
 具体的数据信息
 
 注意: 为了简化运算, 线形图等实体之间有前后关系的, 要求xIndex和实体在数组中的索引一一匹配.
 */
@property (nonatomic, strong) NSArray<id<CCProtocolChartDataEntityBase>> *entities;


/**
 数据集名字, 用户可以自定义, 方便通过名字获取集合, 名字必须唯一的.
 */
@property (nonatomic, copy) CCDataSetName name;


/**
 绘制的颜色信息, 默认白色
 */
@property (nonatomic, strong) UIColor *color;

/**
 数据集中最小的y值
 */
@property (nonatomic, readonly, assign) CGFloat minY;


/**
 数据集中最大的y值
 */
@property (nonatomic, readonly, assign) CGFloat maxY;


@property (nonatomic, readonly, assign) NSInteger minX;


@property (nonatomic, readonly, assign) NSInteger maxX;

@end
