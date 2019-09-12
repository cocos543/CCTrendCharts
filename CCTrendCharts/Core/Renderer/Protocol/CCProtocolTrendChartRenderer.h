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
 
 @param contentLayer 将数据渲染到contentLayer上
 */
- (void)renderValues:(CALayer *)contentLayer;


/**
 绘制趋势图高亮部分信息

 @param contentLayer 将数据渲染到contentLayer上
 */
- (void)renderHighlighted:(CALayer *)contentLayer;

@end
