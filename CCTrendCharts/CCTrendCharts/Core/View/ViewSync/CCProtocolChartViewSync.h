//
//  CCProtocolChartViewSync.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/12/4.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 描述视图同步需要的信息
@protocol CCProtocolChartViewSync

- (void)chartViewSyncForPan:(id)panEvent;

- (void)chartViewSyncForPinch:(id)pinchEvent;

- (void)chartViewSyncForLongPress:(id)longPressEvent;

- (void)chartViewSyncEndForPan;

- (void)chartViewSyncEndForPinch;

- (void)chartViewSyncEndForLongPress;


/// 拖动事件, 可以被观察
@property (nonatomic, strong) id sync_panObservable;

/// 缩放事件, 可以被观察
@property (nonatomic, strong) id sync_pinchObservable;

/// 长按事件, 可以被观察
@property (nonatomic, strong) id sync_longPressObservable;

/// 缩放手势, 默认YES
@property (nonatomic, assign) BOOL sync_pinchGesutreEnable;

/// 拖动手势, 默认YES
///
/// 禁用时, 可以避免滚动事件重复传递给其他人
@property (nonatomic, assign) BOOL sync_panGesutreEnable;

/// 长按手势, 默认YES
@property (nonatomic, assign) BOOL sync_longPressGesutreEnable;

@end
