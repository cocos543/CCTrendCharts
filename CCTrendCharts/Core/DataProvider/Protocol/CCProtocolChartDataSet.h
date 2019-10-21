//
//  CCProtocolChartDataSet.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCChartDataEntity.h"

@protocol CCProtocolChartDataSet <NSObject>
@required
- (instancetype)initWithVals:(NSArray<CCChartDataEntity *> *)yVals withName:(NSString *)name;


/// 计算数据集在指定范围内的最值
/// @param start 起点
/// @param end 终点
- (void)calcMinMaxStart:(NSInteger)start End:(NSInteger)end;

/**
 具体的数据信息
 */
@property (nonatomic, strong) NSArray<CCChartDataEntity *> *yVals;


/**
 数据集名字, 用户可以自定义, 方便调试
 */
@property (nonatomic, copy) NSString *name;


/**
 绘制的颜色信息
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
