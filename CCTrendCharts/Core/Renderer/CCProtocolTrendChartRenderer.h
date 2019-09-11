//
//  CCProtocolTrendChartRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit>
#import "CCProtocolChartRendererBase.h"

@protocol CCProtocolTrendChartRenderer <NSObject>
/**
 绘制趋势图数据
 
 @param parentLayer 绘制出的layer将会作为parentLayer的子layer
 */
- (void)renderValues:(CALayer *)parentLayer;


/**
 绘制趋势图高亮部分信息

 @param parentLayer 绘制出的layer将会作为parentLayer的子layer
 */
- (void)renderHighlighted:(CALayer *)parentLayer;

@end
