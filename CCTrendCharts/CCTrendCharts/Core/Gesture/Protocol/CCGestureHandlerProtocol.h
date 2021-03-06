//
//  CCGestureDefaultHandlerProtocol.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/10/24.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCProtocolBase.h"
#import "CCChartViewPixelHandler.h"

@protocol CCGestureHandlerDelegate <NSObject>


/// 进行缩放操作
/// @param point 缩放的中心点
/// @param matrix 缩放的内容
- (void)gestureDidPinchInLocation:(CGPoint)point matrix:(CGAffineTransform)matrix;


/// 缩放操作结束
/// @param point 缩放的中心点
/// @param matrix 缩放的内容
- (void)gestureDidEndPinchInLocation:(CGPoint)point matrix:(CGAffineTransform)matrix;


/// 进行滚动操作
- (void)gestureDidPanIncrementOffset:(CGPoint)point matrix:(CGAffineTransform)matrix;


/// 正在进行长按+滚动操作
/// @param point 长按中心
- (void)gestureDidLongPressInLocation:(CGPoint)point;

/// 结束长按操作
- (void)gestureDidEndLongPressInLocation:(CGPoint)point;

@end


@protocol CCGestureHandlerProtocol <CCProtocolBase>


/// 平移手势触发
- (void)panGestureChange:(UIPanGestureRecognizer *)gr;

/// 长按手势触发
- (void)longPressGestureStateChanging:(UILongPressGestureRecognizer *)gr;

/// 双击手势触发
- (void)doubleTapGestureStateChanging:(UITapGestureRecognizer *)gr;

/// 单击手势触发
- (void)tapGestureStateChanging:(UITapGestureRecognizer *)gr;

/// 双指缩放触发
- (void)pinchGestureStateChanging:(UIPinchGestureRecognizer *)gr;

/// 滚动事件
- (void)didScrollIncrementOffsetX:(CGFloat)incrementOffsetX;



@property (nonatomic, weak) CCChartViewPixelHandler *viewPixelHandler;

@property (nonatomic, weak) UIView *baseView;

/// 提供一个用于缩放的手势
@property (nonatomic, readonly) UIPinchGestureRecognizer *pinchGesture;

/// 提供一个长按的手势
@property (nonatomic, readonly) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, weak) id<CCGestureHandlerDelegate>delegate;

@end
