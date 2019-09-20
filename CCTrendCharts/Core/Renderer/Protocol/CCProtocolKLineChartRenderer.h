//
//  CCProtocolKLineChartRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/19.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolTrendChartRenderer.h"
#import "CCProtocolKLineChartDataProvider.h"

@protocol CCProtocolKLineChartRenderer <CCProtocolTrendChartRenderer>

@property (nonatomic, strong) CCProtocolKLineChartDataProvider *dataProvider;



@end
