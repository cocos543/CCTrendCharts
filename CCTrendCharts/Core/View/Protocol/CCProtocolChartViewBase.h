//
//  CCProtocolChartViewBase.h
//  CCTrendCharts
//
//  规定了所有ChartView必须实现的协议
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCProtocolTrendChartRenderer.h"
#import "CCProtocolAxisRenderer.h"

#import "CCDefaultYAxis.h"
#import "CCDefaultXAxis.h"

@protocol CCProtocolChartViewBase <CCProtocolBase>
@required
// 提供Y轴上文案的信息
@property (nonatomic, strong) CCDefaultYAxis *leftAxis;

@property (nonatomic, strong) CCDefaultYAxis *rightAxis;

// 提供X轴上文案信息
@property (nonatomic, strong) CCDefaultXAxis *xAxis;



// 渲染组件
@property (nonatomic, strong) id<CCProtocolTrendChartRenderer> renderer;

// 这里视图类只需要关注渲染对象是否实现基础协议即可, 具体的渲染过程由渲染对象内部处理
@property (nonatomic, strong) id<CCProtocolAxisRenderer> xAxisrenderer;

@property (nonatomic, strong) id<CCProtocolAxisRenderer> yAxisrenderer;

@end
