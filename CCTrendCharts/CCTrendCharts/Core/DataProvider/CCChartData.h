//
//  CCChartData.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCProtocolChartDataSet.h"

NS_ASSUME_NONNULL_BEGIN


/**
 数据整体:
 
 为视图提供数据, 一个数据整体包含了一个或多个数据集, 以及一个x轴文案信息(多个数据集应该共用同样的x轴)
 至于y轴的文案信息, 实际上是由数据集得到的, 所以这里数据整体不需要囊括y轴文案信息
 */
@interface CCChartData : NSObject


- (instancetype)init NS_UNAVAILABLE;

/**
 默认初始化方法

 @param xVals X轴全部数据对应文案信息
 @param dataSets 数据集数组, 每个数据集都支持单独绘制, 包括不同颜色样式
 @return 数据整体
 */
- (instancetype)initWithXVals:(NSArray<NSString *> *)xVals dataSets:(NSArray<id<CCProtocolChartDataSet>> *)dataSets NS_DESIGNATED_INITIALIZER;


/**
 根据当前数据集重新计算最大最小值
 */
- (void)calcMinMaxStart:(NSInteger)start End:(NSInteger)end;


/// 获取数据源中的全部匹配的index实体
/// @param index 索引
- (NSArray<id<CCProtocolChartDataEntityBase>> *)entitiesForIndex:(NSInteger)index;


/// 从名为dataSetName的数据集中, 获取指定索引的实体.
/// @param index 索引
/// @param dataSetName 数据集名字
- (NSArray<id<CCProtocolChartDataEntityBase>> *)entityForIndex:(NSInteger)index inDataSet:(CCDataSetName)dataSetName;


/// 获取指定名字的dataSet, 这里可能有多个同名dataSet, 所以返回数组 (后期将可能支持数据组绘制)
/// @param name dataSet名字
- (NSMutableArray<id<CCProtocolChartDataSet>> *)dataSetWithName:(CCDataSetName)name;

/**
 集合数组
 */
@property (nonatomic, strong) NSMutableArray<id<CCProtocolChartDataSet>> *dataSets;


/**
 X轴对应的数据(x轴上的文案)
 */
@property (nonatomic, strong) NSArray<NSString *> *xVals;

@property (nonatomic, readonly, assign) CGFloat maxY;

@property (nonatomic, readonly, assign) CGFloat minY;

@property (nonatomic, readonly, assign) CGFloat minX;

@property (nonatomic, readonly, assign) CGFloat maxX;


@end

NS_ASSUME_NONNULL_END
