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

- (void)layoutSubviews {
    [self adjustViewsProperty];
}

- (void)adjustViewsProperty {
    if (self.views.count == 0) {
        return;
    }
    // 首先是调整所有视图的位置, 都参考第一个视图的位置, 按照顺序向下摆放
    CGRect frame = self.views[0].frame;
    CCDefaultXAxis *xAxis = self.views[0].xAxis;
    for (CCChartViewBase *view in self.views) {
        if (view == self.views[0]) {
            view.frame = CGRectMake(0, 0, frame.size.width, view.frame.size.height);
        }else {
            view.frame = CGRectMake(0, CGRectGetMaxY(frame), frame.size.width, view.frame.size.height);
        }
        
        frame = view.frame;
        
        // 调整视图Y轴信息
        view.leftAxis.labelPosition = view.rightAxis.labelPosition = CCYAxisLabelPositionInside;
        view.xAxis.xSpace = xAxis.xSpace;
        view.xAxis.startMargin = xAxis.startMargin;
        view.xAxis.endMargin = xAxis.endMargin;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frame.size.width, CGRectGetMaxY(frame));
}

- (void)setNeedsPrepareChart {
    
    for (CCChartViewBase *view in self.views) {
        [view setNeedsPrepareChart];
    }
}

- (void)configChartViews:(NSArray<CCChartViewBase *> *)views {
    self.views = views;
    
    [self adjustViewsProperty];

    for (CCChartViewBase *view in views) {
        // 把视图添加为子视图

        [self addSubview:view];
        
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
