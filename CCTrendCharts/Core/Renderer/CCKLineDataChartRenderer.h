//
//  CCKLineDataChartRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/13.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDataChartRenderer.h"
#import "CCProtocolKLineDataChartRenderer.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCKLineDataChartRenderer : CCDataChartRenderer <CCProtocolKLineDataChartRenderer>


/// 根据传入的路径渲染图层
/// @param risingPath 上升路径
/// @param fallingPath 下降路径
/// @param flatPath 平价路径
/// @param usingDataSetName 数据集名字
/// @param contentLayer 内容图层
- (void)renderDataWithRising:(UIBezierPath *)risingPath fallingPath:(UIBezierPath *)fallingPath flatPath:(UIBezierPath *)flatPath usingDataSetName:(CCDataSetName)name inContentLayer:(CALayer *)contentLayer;


// 这里的访问权限本应该是"模块内"可见(internal), 不过OC并没有这种特性.
@property (nonatomic, strong) CAShapeLayer *risingLayer;

@property (nonatomic, strong) CAShapeLayer *fallingLayer;

@property (nonatomic, strong) CAShapeLayer *flatLayer;

@end

NS_ASSUME_NONNULL_END
