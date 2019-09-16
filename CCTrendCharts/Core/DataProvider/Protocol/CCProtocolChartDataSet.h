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

- (instancetype)initWithVals:(NSArray<CCChartDataEntity *> *)yVals withName:(NSString *)name;

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

@end
