//
//  CCKLineChartView.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewBase.h"

#import "CCDefaultYAxisRenderer.h"
#import "CCDefaultXAxisRenderer.h"


#import "CCProtocolKLineChartDataProvider.h"
#import "CCKLineChartData.h"


NS_ASSUME_NONNULL_BEGIN


/**
 K线趋势图
 */
@interface CCKLineChartView : CCChartViewBase <CCProtocolKLineChartDataProvider>

@property (nonatomic, assign) UIEdgeInsets clipEdgeInsets;


@property (nonatomic, readonly) CCKLineChartData *klineChartData;

/**
 定义CCProtocolRectangularCoordinateChartDataProvider协议中的数据源, 这里可以换成其他合法子类
 */


@end

NS_ASSUME_NONNULL_END
