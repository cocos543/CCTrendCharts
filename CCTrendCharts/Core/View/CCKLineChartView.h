//
//  CCKLineChartView.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewBase.h"
#import "CCDefaultYAxis.h"
#import "CCDefaultXAxis.h"
#import "CCDefaultYAxisRenderer.h"
#import "CCDefaultXAxisRenderer.h"
#import "CCProtocolRectangularCoordinateChartDataProvider.h"


NS_ASSUME_NONNULL_BEGIN

@interface CCKLineChartView : CCChartViewBase <CCProtocolRectangularCoordinateChartDataProvider>

// 这里视图类只需要关注渲染对象是否实现基础协议即可, 具体的渲染过程由渲染对象内部处理
@property (nonatomic, strong) id<CCProtocolAxisRenderer> xAxisrenderer;

@property (nonatomic, strong) id<CCProtocolAxisRenderer> yAxisrenderer;

@end

NS_ASSUME_NONNULL_END
