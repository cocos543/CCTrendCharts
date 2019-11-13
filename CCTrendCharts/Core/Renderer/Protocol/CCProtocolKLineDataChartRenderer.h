//
//  CCProtocolKLineDataRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/19.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolDataChartRenderer.h"
#import "CCProtocolKLineChartDataProvider.h"

@protocol CCProtocolKLineDataChartRenderer <CCProtocolDataChartRenderer>

@property (nonatomic, weak) id<CCProtocolKLineChartDataProvider> dataProvider;


@end
