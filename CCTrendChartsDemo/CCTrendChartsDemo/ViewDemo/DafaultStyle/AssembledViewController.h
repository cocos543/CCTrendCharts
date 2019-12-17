//
//  AssembledViewController.h
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/13.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "BaseViewController.h"
#import "NetworkHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssembledViewController : BaseViewController <CCChartViewDataSource, CCChartViewDelegate>

- (NSString *)getXAxisLabelFormat;

@property (nonatomic, strong) CCSingleEventManager *eventManager;

@property (nonatomic, strong) NSArray<CCTAIConfigItem *> *taiItems;

// 简单记录股票数据已加载到的时间点
@property (nonatomic, assign) NSTimeInterval minTime;

@property (nonatomic, strong) CCKLineChartView *klineView;

@property (nonatomic, strong) CCVolumeChartView *volumeView;

@property (nonatomic, strong) CCLineChartView *lineView;

@property (nonatomic, strong) CCAssembledChartView *assembleView;

@property (nonatomic, strong) UIScrollView *scrollView;


@end

NS_ASSUME_NONNULL_END
