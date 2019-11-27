//
//  CCLineChartView.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/22.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewBase.h"

#import "CCDefaultCursor.h"

#import "CCDefaultYAxisRenderer.h"
#import "CCDefaultXAxisRenderer.h"
#import "CCDefaultCursorRenderer.h"
#import "CCDefaultMarkerRenderer.h"
#import "CCLineDataChartRenderer.h"

NS_ASSUME_NONNULL_BEGIN


/// 线形图
///
/// 可以绘制多条折线, 如果需要在同个区域绘制多条折线+条状图的话, 请使用CCAssembleChartView.
@interface CCLineChartView : CCChartViewBase

@end

NS_ASSUME_NONNULL_END
