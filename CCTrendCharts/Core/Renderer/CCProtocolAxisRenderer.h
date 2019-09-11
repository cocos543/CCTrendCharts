//
//  CCProtocolAxisRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//
#import <UIKit/UIKit>

#import "CCProtocolChartRendererBase.h"

@protocol CCProtocolAxisRenderer <CCProtocolChartRendererBase>


/**
 绘制轴上的Label

 @param parentLayer 绘制出的layer将会作为parentLayer的子layer
 */
- (void)renderLabels:(CALayer *)parentLayer;


/**
 绘制网格

 @param parentLayer 绘制出的layer将会作为parentLayer的子layer
 */
- (void)renderGridLines:(CALayer *)parentLayer;

@end
