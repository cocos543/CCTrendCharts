//
//  CCChartData.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartData.h"

@implementation CCChartData

- (instancetype)initWithXVals:(NSArray<NSString *> *)xVals dataSets:(NSArray<id<CCProtocolChartDataSet>> *)dataSets {
    self = [super init];
    if (self) {
        _xVals = xVals;
        _dataSets = dataSets;
    }
    return self;
}

- (void)calcMinMax {
    
}


@end
