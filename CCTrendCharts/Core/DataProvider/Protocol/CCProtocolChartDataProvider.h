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
#import "CCChartData.h"

@protocol CCProtocolChartDataProvider <NSObject>
@required
//  getTransformer

// 数据源
@property (nonatomic, readonly) CCChartData *data;

// Y轴最大值
@property (nonatomic, assign, readonly) CGFloat chartMaxY;

// Y轴最小值
@property (nonatomic, assign, readonly) CGFloat chartMinY;

// X轴最大值
@property (nonatomic, assign, readonly) CGFloat chartMaxX;

// X轴最小值
@property (nonatomic, assign, readonly) CGFloat chartMinX;

/// 最近优先, 趋势图默认为YES, 适合趋势交易图的显示习惯
@property (nonatomic, readonly) BOOL recentFirst;



/**
 经过2D变换之后可见的最小索引
 */
@property (nonatomic, assign, readonly) NSInteger lowestVisibleXIndex;


/**
 经过2D变换之后可见的最大索引
 */
@property (nonatomic, assign, readonly) NSInteger highestVisibleXIndex;

@end
