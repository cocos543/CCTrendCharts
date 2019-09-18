//
//  CCProtocolTrendChartRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCProtocolChartRendererBase.h"
#import "CCProtocolChartDataSet.h"


@protocol CCProtocolTrendChartRenderer <CCProtocolChartRendererBase>
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
- (void)renderHighlighted:(CALayer *)contentLayer;

@end
