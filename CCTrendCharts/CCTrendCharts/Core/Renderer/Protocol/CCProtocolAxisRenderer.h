//
//  CCProtocolAxisRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "CCProtocolChartRendererBase.h"
#import "CCProtocolAxisBase.h"

@protocol CCProtocolAxisRenderer <CCProtocolChartRendererBase>


/**
 渲染层直接根据axis对象进行渲染
 */
@property (nonatomic, weak) id<CCProtocolAxisBase> axis;

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



/// 便捷渲染方法
/// @param contentLayer 目标层
- (void)beginRenderingInLayer:(CALayer *)contentLayer;

@end
