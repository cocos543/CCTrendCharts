//
//  KLineViewController.h
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/10.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "BaseViewController.h"
#import "NetworkHelper.h"



NS_ASSUME_NONNULL_BEGIN

@interface KLineViewController : BaseViewController <CCChartViewDataSource, CCChartViewDelegate>

// 下面几个函数是把部分变量值拆出来, 是为了方便子demo中的其他子类实现自己的对应类型的数据, 方便代码复用, 除此之外没有其他任何含义.
- (id<CCProtocolChartDataSet>)getDataSetFrom:(NSArray *)entities;

- (id<CCProtocolChartDataEntityBase>)getEntityWith:(NSInteger)xIndex;

- (NSString *)getXAxisLabelFormat;


@property (nonatomic, strong) CCKLineChartView *chartView;

@property (nonatomic, strong) CCSingleEventManager *eventManager;

@property (nonatomic, strong) NSArray<CCTAIConfigItem *> *taiItems;

// 简单记录股票数据已加载到的时间点
@property (nonatomic, assign) NSTimeInterval minTime;


@end

NS_ASSUME_NONNULL_END
