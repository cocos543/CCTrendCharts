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
#import "CCProtocolChartDataProvider.h"

#import "CCGestureDefaultHandler.h"

#import "CCSingleEventManager.h"

#import "CCProtocolChartViewSync.h"

NS_ASSUME_NONNULL_BEGIN

@class CCChartViewBase;

@protocol CCChartViewDataSource <NSObject>

/// 分页提供数据
- (CCChartData *)chartDataInView:(CCChartViewBase *)chartView;

/// 提供实时更新最后一个节点的数据
- (CCChartData *)chartDataForRealTimeInView:(CCChartViewBase *)chartView;

/// 切换数据数据类型时, 提供全部新数据
- (CCChartData *)chartDataForSwitchTypeInView:(CCChartViewBase *)chartView;

@end

@protocol CCChartViewDelegate <NSObject>

/// 图库希望得到下一页的数据, 用于渲染
///
/// 目前有两种情况触发这个方法
///
/// 1. 普通趋势图(非recentFirst), 视图向左滚动到出现右边界之后会触发.
///
/// 2. recentFirst趋势图, 视图向右滚动到出现左边界之后会触发.
///
/// 注意, 该方法只是通知用户"期待获取下一页数据", 但实际有没有新数据要提供, 由用户自行决定.
/// 如果有新数据提供, 请调用[charview setNeedsPrepareChart]通知图库, 之后提供相应数据源即可.
- (void)chartViewExpectLoadNextPage:(CCChartViewBase *)view eventManager:(CCSingleEventManager *)eventManager;

// 长按事件
- (void)charViewDidLongPressAtIndex:(NSInteger)index;

// 点击事件

// 双击事件

@end

/**
 请不要直接使用基类视图!
 */
@interface CCChartViewBase : UIView <CCGestureHandlerDelegate, CCProtocolChartViewBase, CCProtocolChartDataProvider, CCProtocolChartViewSync>


/// 重置视图状态, 该方法只是让手势矩阵重置为初始值, 并没有重新渲染视图.
- (void)resetViewGesture;

/// 添加默认手势
- (void)addDefualtGesture;

/**
 标记视图需要重新准备信息. 调用该方法并不会立即重新计算信息, 而是等到当前runloop周期结束之后(同setNeedsDisplay)
 */
- (void)setNeedsPrepareChart;

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


/// 指示器风格
///
/// 这是个可能会被删除的属性, 因为后期横向滚动可能从ScrollView实现改为PanGesture实现.
@property (nonatomic, assign) UIScrollViewIndicatorStyle indicatorStyle;


/// 显示横向滚动条
///
/// 默认 YES
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;

@end

NS_ASSUME_NONNULL_END
