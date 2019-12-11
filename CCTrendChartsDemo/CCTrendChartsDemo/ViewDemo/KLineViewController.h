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

// 这里把数据集和实体的创建拆出来是为了方便子demo中的其他子类实现自己的对应类型的数据
- (id<CCProtocolChartDataSet>)getDataSetFrom:(NSArray *)entities;

- (id<CCProtocolChartDataEntityBase>)getEntityWith:(NSInteger)xIndex;

@property (nonatomic, strong) CCKLineChartView *chartView;

@property (nonatomic, strong) CCSingleEventManager *eventManager;

@property (nonatomic, strong) NSArray<CCTAIConfigItem *> *taiItems;


@end

NS_ASSUME_NONNULL_END
