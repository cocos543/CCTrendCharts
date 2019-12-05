//
//  CCAssembledChartView.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/22.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCAssembledChartView.h"
#import "NSObject+CCEasyKVO.h"

@interface CCAssembledChartView ()

@property (nonatomic, strong) NSArray<CCChartViewBase *> *views;

@end

@implementation CCAssembledChartView

- (void)setNeedsPrepareChart {
    for (CCChartViewBase *view in self.views) {
        [view setNeedsPrepareChart];
    }
}

- (void)configChartViews:(NSArray<CCChartViewBase *> *)views {
    self.views = views;

    for (CCChartViewBase *view in views) {
        // 关联滚动手势
        [self cc_easyObserve:view forKeyPath:@"sync_panObservable" options:NSKeyValueObservingOptionNew block:^(id _Nonnull object, NSDictionary<NSKeyValueChangeKey, id> *_Nonnull change) {
            for (CCChartViewBase *view in views) {
                // 把事件传递给其他视图
                if (object != view) {
                    if (![change[NSKeyValueChangeNewKey] isEqual:NSNull.null]) {
                        [view chartViewSyncForPan:change[NSKeyValueChangeNewKey]];
                    } else {
                        [view chartViewSyncEndForPan];
                    }
                }
            }
        }];

        // 关联缩放手势
        [self cc_easyObserve:view forKeyPath:@"sync_pinchObservable" options:NSKeyValueObservingOptionNew block:^(id _Nonnull object, NSDictionary<NSKeyValueChangeKey, id> *_Nonnull change) {
            for (CCChartViewBase *view in views) {
                // 把事件传递给其他视图
                if (object != view) {
                    if (![change[NSKeyValueChangeNewKey] isEqual:NSNull.null]) {
                        [view chartViewSyncForPinch:change[NSKeyValueChangeNewKey]];
                    } else {
                        [view chartViewSyncEndForPinch];
                    }
                }
            }
        }];

        // 关联长按手势
        [self cc_easyObserve:view forKeyPath:@"sync_longPressObservable" options:NSKeyValueObservingOptionNew block:^(id _Nonnull object, NSDictionary<NSKeyValueChangeKey, id> *_Nonnull change) {
            for (CCChartViewBase *view in views) {
                // 把事件传递给其他视图
                if (object != view) {
                    if (![change[NSKeyValueChangeNewKey] isEqual:NSNull.null]) {
                        [view chartViewSyncForLongPress:change[NSKeyValueChangeNewKey]];
                    } else {
                        [view chartViewSyncEndForLongPress];
                    }
                }
            }
        }];
    }
}

@end
