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
 更新对象的矩阵变量为新值

 @param matrix 新矩阵
 */
- (void)refreshWithMatrix:(CGAffineTransform)matrix;


// 定义一个CGAffineTransform结构体, 可以被CCChartTransformer调用, 用于把数据图表转换成屏幕上的真实位置.
@property (nonatomic, assign) CGAffineTransform gestureMatrix;


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

@end

NS_ASSUME_NONNULL_END
