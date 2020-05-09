//
//  CCAssembledChartView.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/22.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewBase.h"

NS_ASSUME_NONNULL_BEGIN


/// 组合图
///
/// 可以按照一定顺序组合传入的各类ChartView, 并提供事件同步功能, 这样所有ChartView就可以响应相同的事件了
///
@interface CCAssembledChartView : UIView

- (void)setNeedsPrepareChart;

- (void)resetViewGesture;


/// 配置需要组合的视图
/// @param views 视图组
///
/// 该方法会执行下面几个动作
///
/// 1. 把数组中的视图都关联在一起, 可以共同响应手势
///
/// 2. 自动按照顺序向下调整视图, 视图的高度则等于视图本身的高度, 宽度等于父视图
///
/// 3. 所有视图的y轴labelPosition都被设置为CCYAxisLabelPositionInside, 这是因为外侧的label会导致渲染区间大小不一致,从而无法很好地同步视图.
///
/// 4. 所有视图xAxis的xSpace,startMargin,endMargin三个属性都被设置为第一个视图的值
- (void)configChartViews:(NSArray<CCChartViewBase *> *)views;

@end

NS_ASSUME_NONNULL_END
