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

- (void)resetGestureMatrix;

- (BOOL)isInBounds:(CGPoint)point;

- (BOOL)isInBoundsLeft:(CGFloat)y;

- (BOOL)isInBoundsRight:(CGFloat)y;

- (BOOL)isInBoundsTop:(CGFloat)y;

- (BOOL)isInBoundsBottom:(CGFloat)y;

/// 是否正处于平移或者缩放状态
- (BOOL)isGestureProcessing;

- (void)updateContentRectOffsetLeft:(CGFloat)offsetLeft offsetRight:(CGFloat)offsetRight offsetTop:(CGFloat)offsetTop offsetBottom:(CGFloat)offsetBottom;

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
 手势矩阵, 主要用于存放缩放平移操作的信息
 */
@property (nonatomic, assign) CGAffineTransform gestureMatrix;


/// 初始矩阵, 用于确定当前整体缩放平移效果是否为原始效果
@property (nonatomic, assign) CGAffineTransform anInitMatrix;

/**
 视图的总大小(含两轴上的文字信息)
 */
@property (nonatomic, assign) CGRect viewFrame;

@property (nonatomic, assign, readonly) CGFloat viewWidth;

@property (nonatomic, assign, readonly) CGFloat viewHeight;

/**
 趋势图的可绘制部分, 也可以理解为画图的大小
 */
@property (nonatomic, assign) CGRect contentRect;

@property (nonatomic, assign, readonly) CGFloat contentWidth;

@property (nonatomic, assign, readonly) CGFloat contentHeight;


// 定义其他放大缩小的方法, 用于改变CGAffineTransform结构体信息


/**
 当前Y轴缩放比例, 默认为1, 暂时不支持y轴缩放
 */
@property (nonatomic, assign, readonly) CGFloat scaleY;


/**
 当前X轴缩放比例, 默认为1
 */
@property (nonatomic, assign, readonly) CGFloat scaleX;


/**
 当前x轴的平移, 默认是0
 */
@property (nonatomic, assign, readonly) CGFloat transX;


/**
 Y轴最大缩放比例, 默认为2
 */
@property (nonatomic, assign, readonly) CGFloat maxScaleY;


/**
 X轴最大缩放比例, 默认为2
 */
@property (nonatomic, assign, readonly) CGFloat maxScaleX;

/**
 Y轴最小缩放比例, 默认为0.3
 */
@property (nonatomic, assign, readonly) CGFloat minScaleY;


/**
 X轴最小缩放比例, 默认为0.3
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


/**
 左侧Y轴到视图左边的距离
 */
@property (nonatomic, assign, readonly) CGFloat offsetLeft;


/**
 右侧Y轴到视图右边的距离
 */
@property (nonatomic, assign, readonly) CGFloat offsetRight;


/**
 第一象限绘制区域顶部到视图顶部的距离
 */
@property (nonatomic, assign, readonly) CGFloat offsetTop;


/**
 第一象限绘制区域底部到视图底部的距离
 */
@property (nonatomic, assign, readonly) CGFloat offsetBottom;

@end

NS_ASSUME_NONNULL_END
