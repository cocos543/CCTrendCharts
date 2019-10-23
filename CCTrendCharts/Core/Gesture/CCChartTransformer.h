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
 更新标准矩阵, 用于确定数据实体和实体之间的规则;
 实体的序号就是实体在x轴上的初始值, 例如最一个实体a序号是0, a应用标准矩阵之后x轴的位置还是0, 0*matrix.a = 0
 第二个实体b,序号是1, 应用标准矩阵之后在x轴的位置就是1*matrix.a;
 第三个实体c, 序号是2, 应用标准矩阵之后在x轴的位置就是2*matrix.a;
 从这里可以看出来标准矩阵matrix中a位置的数值其实就是两个相邻实体的距离.
 
 标准矩阵一般有如下用法:
 
 1. 绘制x轴的label
 
 绘制x轴文本信息时, 主要关心的是两个数据实体中心轴之间的距离.每一个数据实体的中心轴, 也是这个实体在x轴上的label的中心点,
 也称为label的锚点.
 只有提供中心轴距离信息, 才能确定绘制第n个实体时对应的label锚点在哪儿.
 
 2. 绘制数据实体
 
 这个是显而易见的, 绘制实体肯定是需要知道实体的中心轴.
 如果实体的形状是点(如折线图), 那么这个点就坐落在中心轴上.
 如果实体的形状是矩形(如K线图), 那么这个矩形的中心坐落在中心轴上.
 
 @param matrix 新矩阵
 */
- (void)refreshMatrix:(CGAffineTransform)matrix;


/**
 更新偏差矩阵
 
 偏差矩阵一般有如下用法:
 1. 纠正数据实体的位置
 
 比如x轴上的第一个数据实体序号0, 初始点就是(x=0, y=0), 这个点其实是在视图的左上角. 为了让这个点
 落到曲线图坐标系的原点(中学数学的笛卡尔坐标系, 不是iOS系统视图坐标系), 所以初始点应用上偏差矩阵之后就会坐落在笛卡尔坐标系原点了.
 
 假设没有缩放操作. 则每一个点的真实位置就是应用 "标准矩阵*偏差矩阵" 的矩阵之后得到得值, 就是真实位置.

 
 @param offsetMatrix 新矩阵
 */
- (void)refreshOffsetMatrix:(CGAffineTransform)offsetMatrix;



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


/// 作用和pointToPixel:forAnimationPhaseY:相反
- (CGPoint)pixelToPoint:(CGPoint)pixel forAnimationPhaseY:(CGFloat)phaseY;

/// 作用和rectToPixel:forAnimationPhaseY:相反
- (CGRect)pixelToRect:(CGRect)pixel forAnimationPhaseY:(CGFloat)phaseY;



/// 传入y方向最大最小值, 计算标准矩阵x,y两个方向的信息
/// @param minY 最小Y
/// @param maxY 最大Y
- (CGAffineTransform)calcMatrixWithMinValue:(CGFloat)minY maxValue:(CGFloat)maxY xSpace:(CGFloat)xSpace;


/// 单独计算x方向矩阵信息
- (CGAffineTransform)calcMatrixOrientationX;


/// 单独计算y方向矩阵信息
/// @param minY 最小y
/// @param maxY 最大y
- (CGAffineTransform)calcMatrixOrientationYWithMinValue:(CGFloat)minY maxValue:(CGFloat)maxY;



/**
 输出最终的变换矩阵, 可以直接作用转换元素的像素位置, 如有需要请直接使用该变量
 */
@property (nonatomic, readonly) CGAffineTransform valueToPixelMatrix;


/// 用于从指定的像素中取得实际对应的数据实体索引, 如有需要请直接使用该变量
@property (nonatomic, readonly) CGAffineTransform pixelToValueMatrix;

@end

NS_ASSUME_NONNULL_END
