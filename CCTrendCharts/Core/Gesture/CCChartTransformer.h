//
//  CCChartTransformer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/19.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCChartViewPixelHandler.h"


NS_ASSUME_NONNULL_BEGIN

/**
 该类用于实现元素坐标变换
 */
@interface CCChartTransformer : NSObject

- (instancetype)initWithViewPixelHandler:(CCChartViewPixelHandler *)viewPixelHandler;

/**
 传入一个点, 返回映射后的真实坐标位置

 @param point 原始的点
 @param phaseY 动画阶段, 取值范围 0 ~ 1 (当前版本暂不支持动画, 该参数无效)
 @return 映射之后的点
 */
- (CGPoint)pointToPixel:(CGPoint)point forAnimationPhaseY:(CGFloat)phaseY;


/**
 传入一个矩形, 返回映射后的真实坐标位置
 
 @param rect 原始的矩形
 @param phaseY 动画阶段, 取值范围 0 ~ 1 (当前版本暂不支持动画, 该参数无效)
 @return 映射之后的矩形
 */
- (CGRect)rectToPixel:(CGRect)rect forAnimationPhaseY:(CGFloat)phaseY;



/**
 输出最终的变换矩阵, 可以直接作用转换元素的像素位置, 如有需要请直接使用该变量
 */
@property (nonatomic, readonly) CGAffineTransform valueToPixelMatrix;

@end

NS_ASSUME_NONNULL_END
