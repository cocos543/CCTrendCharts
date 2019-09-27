//
//  CCChartViewPixelHandler.h
//  CCTrendCharts
//
//  所有放大缩小操作都会作用到Handler对象上
//
//  Created by Cocos on 2019/9/9.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCChartViewPixelHandler : NSObject


/**
 直接缩放当前矩阵

 @param scaleX x轴
 @param scaleY y轴
 */
- (CGAffineTransform)zoomScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY;


/**
 返回围绕指定中心点放大缩小的矩阵 (不影响原来矩阵)

 @param scaleX x轴
 @param scaleY y轴
 @param center 中心点
 */
- (CGAffineTransform)zoomScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY aroundCenter:(CGPoint)center;


/**
 返回围绕center放大固定比例的矩阵 (不影响原来矩阵)

 @param center 中心点
 */
- (CGAffineTransform)zoomInAroundCenter:(CGPoint)center;

/**
 返回围绕center放大固定比例的矩阵 (不影响原来矩阵)
 
 @param center 中心点
 */
- (CGAffineTransform)zoomOutAroundCenter:(CGPoint)center;


/**
 更新标准矩阵, 用于确定数据实体和实体之间的规则
 
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
 更新偏差矩阵, 用于调整标准矩阵的偏移量
 
 偏差矩阵一般有如下用法:
 
 1. 绘制数据实体时确定实体的具体位置
 
 比如绘制第一个实体, 默认中心轴是在左侧y轴上, 加上向右的偏移量, 这样第一个实体的中心轴就在y轴左边了.
 同理, 非第一实体配合偏移量, 和第一个实体同步偏移.
 
 
 @param offsetMatrix 新矩阵
 */
- (void)refreshOffsetMatrix:(CGAffineTransform)offsetMatrix;


// 定义一个CGAffineTransform结构体, 可以被CCChartTransformer调用, 用于把数据图表转换成屏幕上的真实位置.
@property (nonatomic, assign) CGAffineTransform gestureMatrix;



/**
 视图的总大小(含两轴上的文字信息)
 */
@property (nonatomic, assign) CGRect viewFrame;

/**
 趋势图的可绘制部分, 也可以理解为画图的大小
 */
@property (nonatomic, assign) CGRect contentRect;

@property (nonatomic, assign, readonly) CGFloat contentWidth;

@property (nonatomic, assign, readonly) CGFloat contentHeight;


// 定义其他放大缩小的方法, 用于改变CGAffineTransform结构体信息


/**
 当前Y轴缩放比例, 默认为1
 */
@property (nonatomic, assign, readonly) CGFloat scaleY;


/**
 当前X轴缩放比例, 默认为1
 */
@property (nonatomic, assign, readonly) CGFloat scaleX;



/**
 Y轴最大缩放比例, 默认为2
 */
@property (nonatomic, assign, readonly) CGFloat maxScaleY;


/**
 X轴最大缩放比例, 默认为2
 */
@property (nonatomic, assign, readonly) CGFloat maxScaleX;

/**
 Y轴最小缩放比例, 默认为1
 */
@property (nonatomic, assign, readonly) CGFloat minScaleY;


/**
 X轴最小缩放比例, 默认为1
 */
@property (nonatomic, assign, readonly) CGFloat minScaleX;



/**
 第一象限区域左侧
 */
@property (nonatomic, assign, readonly) CGFloat contentLeft;

/**
 第一象限区域右侧
 */
@property (nonatomic, assign, readonly) CGFloat contentRight;

/**
 第一象限区域上侧
 */
@property (nonatomic, assign, readonly) CGFloat contentTop;

/**
 第一象限区域下侧
 */
@property (nonatomic, assign, readonly) CGFloat contentBottom;

@end

NS_ASSUME_NONNULL_END
