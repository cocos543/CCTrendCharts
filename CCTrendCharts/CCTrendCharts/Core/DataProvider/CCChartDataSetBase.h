//
//  CCChartDataSetBase.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/10/9.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolChartDataSet.h"

extern CCDataSetName const _Nonnull kCCNameBaseDataSet;

NS_ASSUME_NONNULL_BEGIN

@interface CCChartDataSetBase : NSObject <CCProtocolChartDataSet>

- (instancetype)initWithEntities:(NSArray<id<CCProtocolChartDataEntityBase>> *)entities withName:(nullable CCDataSetName)name NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)resetValue;

@end

NS_ASSUME_NONNULL_END
