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
#import "CCGestureDefaultHandler.h"

NS_ASSUME_NONNULL_BEGIN

@class CCChartViewBase;

@protocol CCChartViewDataSource <NSObject>

/// 分页提供数据
/// @param page 页码
- (CCChartData *)chartDataForPage:(NSUInteger)page inView:(CCChartViewBase *)view;


/// 提供实时更新最后一个节点的数据, 一般用于实时k线这类需求
- (CCChartData *)chartDataForRealTimeInView:(CCChartViewBase *)view;


/// 切换数据数据类型时, 提供全部新数据
- (CCChartData *)chartDataForSwitchTypeInView:(CCChartViewBase *)view;

@end

@protocol CCChartViewDelegate <NSObject>

// 点击事件

// 双击事件


@end

/**
 请不要直接使用基类视图!
 */
@interface CCChartViewBase : UIView <CCProtocolChartViewBase, CCProtocolChartDataProvider>


/// 添加默认手势
- (void)addDefualtGesture;


/// 标记视图需要更新, 提供的最新数据将会直接覆盖到当前数据上, 新增的数组则会直接追加到整体数据的末尾
- (void)setNeedsPrepareChartForRealTime;

/**
 标记视图需要重新准备信息. 调用该方法并不会立即重新计算信息, 而是等到当前runloop周期结束之后(同setNeedsDisplay)
 */
- (void)setNeedsPrepareChart:(NSInteger)page;

/**
 子类需要实现该方法, 为整个视图做好数据准备.
 请勿直接调用该方法, 需要更新Chart信息请调用setNeedsPrepareChart
 */
- (void)prepareChart;


@property (nonatomic, weak) id<CCChartViewDataSource> dataSource;
@property (nonatomic, weak) id<CCChartViewDelegate> delegate;

/**
 基类声明了数据源属性以及读写方法
 */
@property (nonatomic, strong) CCChartData *data;


/// 用于确定xy轴距离整个视图边缘的大小. 两轴文案加上该属性的值即为最终距离
@property (nonatomic, assign) UIEdgeInsets clipEdgeInsets;


/// 最近优先显示, 默认为YES, 适合趋势交易图的显示习惯, 此时page(页码)向左递增
/// 如果是按照早期到当前的顺序显示, 则将该参数设置为NO, 此时page(页码)向右递增
@property (nonatomic, assign) BOOL recentFirst;

/// 处理手势操作的具体功能
@property (nonatomic, strong) id<CCGestureHandlerProtocol> gestureHandler;

@end

NS_ASSUME_NONNULL_END
