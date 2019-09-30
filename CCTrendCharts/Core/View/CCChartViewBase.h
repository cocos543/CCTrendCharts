//
//  CCChartViewBase.h
//  CCTrendCharts
//
//  基类视图, 所有不同的趋势图都将继承该类
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCProtocolChartViewBase.h"

NS_ASSUME_NONNULL_BEGIN



/**
 请不要直接使用基类视图!
 */
@interface CCChartViewBase : UIView <CCProtocolChartViewBase, CCProtocolChartDataProvider>


/**
 标记视图需要重新准备信息
 */
- (void)setNeedsPrepareChart;

/**
 子类需要实现该方法, 为整个视图做好数据准备.
 请勿直接调用该方法, 需要更新Chart信息请调用setNeedsPrepareChart
 */
- (void)prepareChart;

/**
 基类声明了数据源属性以及读写方法
 */
@property (nonatomic, strong) CCChartData *data;

@property (nonatomic, assign) UIEdgeInsets clipEdgeInsets;

@end

NS_ASSUME_NONNULL_END
