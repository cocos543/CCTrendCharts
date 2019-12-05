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
@interface CCAssembledChartView : UIView

- (void)setNeedsPrepareChart;

- (void)configChartViews:(NSArray<CCChartViewBase *> *)views;

@end

NS_ASSUME_NONNULL_END
