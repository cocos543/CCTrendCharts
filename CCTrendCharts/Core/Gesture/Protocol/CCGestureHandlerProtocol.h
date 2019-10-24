//
//  CCGestureHandlerProtocol.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/10/24.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCChartViewPixelHandler.h"

@protocol CCGestureHandlerProtocol <NSObject>


/// 平移手势触发
- (void)panGestureChange:(UIPanGestureRecognizer *)gr;

/// 长按手势触发
- (void)longPressGestureStateChanging:(UILongPressGestureRecognizer *)gr;

/// 双击手势触发
- (void)doubleTapGestureStateChanging:(UITapGestureRecognizer *)gr;

/// 单击手势触发
- (void)tapGestureStateChanging:(UITapGestureRecognizer *)gr;

/// 滚动事件
- (void)didScroll:(CGPoint)offset;

@property (nonatomic, weak) CCChartViewPixelHandler *viewPixelHandler;

@end
