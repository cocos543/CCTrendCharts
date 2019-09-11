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

#import "CCDefualtYAxis.h"
#import "CCDefualtXAxis.h"

@protocol CCProtocolChartViewBase <CCProtocolBase>
@required

// 提供Y轴上文案的信息
@property (nonatomic, strong) CCDefualtYAxis *yAxis;


// 提供X轴上文案信息
@property (nonatomic, strong) CCDefualtXAxis *xAxis;

@end
