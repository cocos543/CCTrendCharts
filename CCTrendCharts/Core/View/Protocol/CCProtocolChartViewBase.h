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

#import "CCDefaultYAxis.h"
#import "CCDefaultXAxis.h"

@protocol CCProtocolChartViewBase <CCProtocolBase>
@required

// 提供Y轴上文案的信息
@property (nonatomic, strong) CCDefaultYAxis *yAxis;


// 提供X轴上文案信息
@property (nonatomic, strong) CCDefaultXAxis *xAxis;

@end
