//
//  CCKLineChartView.h
//  CCTrendCharts
//
//  用于绘制Candlestick, 交易趋势图, 以下名字统一称为K线图(K Line Diagram).
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewBase.h"

#import "CCDefaultCursor.h"

#import "CCDefaultYAxisRenderer.h"
#import "CCDefaultXAxisRenderer.h"
#import "CCDefaultCursorRenderer.h"
#import "CCDefaultMarkerRenderer.h"
#import "CCKLineDataChartRenderer.h"
#import "CCTAILegendRenderer.h"


#import "CCProtocolKLineChartDataProvider.h"


NS_ASSUME_NONNULL_BEGIN

/// K线趋势图
///
/// 根据数据集中的类型, 提供蜡烛图(candlestick), 折线图(line)
@interface CCKLineChartView : CCChartViewBase <CCProtocolKLineChartDataProvider>


/// 技术指标配置
@property (nonatomic, strong) CCTAIConfig *TAIConfig;
/**
 定义CCProtocolRectangularCoordinateChartDataProvider协议中的数据源, 这里可以换成其他合法子类
 */


@end

NS_ASSUME_NONNULL_END
