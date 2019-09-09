//
//  CCProtocolChartDataProvider.h
//  CCTrendCharts
//
//  数据提供者, 提供必备数据, 例如当前数据集的最大值最小值,
//  这里具体实现的类, 要提供图表可视范围内的最值, 还是全部数据的最值, 取决于具体的类, 视图渲染的时候,
//  采集的数据来自DataProvider, 所以实现这个协议的类最终会影响绘制结果.
//
//  Created by Cocos on 2019/9/9.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCProtocolChartDataProvider <NSObject>

// 数据集数组


// Y轴最大值

// Y轴最小值

// X轴最大值

// X轴最小值

// 还可以设置其它子协议, 比如最小可见x index, 最大可见x index, 这样就可以提供给渲染层, 渲染层才知道要渲染哪些数据

@end
