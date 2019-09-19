//
//  CCProtocolKLineChartDataProvider.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/19.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolChartDataProvider.h"
#import "CCKLineChartData.h"

@protocol CCProtocolKLineChartDataProvider <CCProtocolChartDataProvider>
@required

@property (nonatomic, strong, readonly) CCKLineChartData *klineChartData;

@end
