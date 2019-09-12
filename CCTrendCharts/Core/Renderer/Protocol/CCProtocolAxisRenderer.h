//
//  CCProtocolAxisRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "CCProtocolChartRendererBase.h"

@protocol CCProtocolAxisRenderer <CCProtocolChartRendererBase>


/**
 绘制轴上的Label

 @param contentLayer 将数据渲染到contentLayer上
 */
- (void)renderLabels:(CALayer *)contentLayer;


/**
 绘制网格

 @param contentLayer 将数据渲染到contentLayer上
 */
- (void)renderGridLines:(CALayer *)contentLayer;


/**
 绘制轴线

 @param contentLayer 将数据渲染到contentLayer上
 */
- (void)renderAxisLine:(CALayer *)contentLayer;

@end
