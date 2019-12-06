//
//  CCProtocolDataChartRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCProtocolChartRendererBase.h"
#import "CCProtocolChartDataSet.h"
#import "CCProtocolChartDataProvider.h"

@protocol CCProtocolDataChartRenderer <CCProtocolChartRendererBase>
/**
 绘制趋势图数据
 
 @param contentLayer 将数据渲染到contentLayer上
 */
- (void)renderData:(CALayer *)contentLayer;

- (void)renderDataSet:(CALayer *)contentLayer dataSet:(id<CCProtocolChartDataSet>)dataSet;


/**
 绘制趋势图高亮部分信息

 @param contentLayer 将数据渲染到contentLayer上
 */
- (void)renderHighlighted:(CAShapeLayer *)contentLayer;


/**
 渲染的时候根据数据提供者(一般是视图本身而不是数据集, 这里其实是做了一个解偶)
 */
@property (nonatomic, weak) id<CCProtocolChartDataProvider> dataProvider;

@end
