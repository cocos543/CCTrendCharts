//
//  CCKLineChartDataSet.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCKLineChartDataSet.h"

@implementation CCKLineChartDataSet
@synthesize yVals = _yVals;
@synthesize name = _name;


- (instancetype)initWithVals:(NSArray<CCChartDataEntity *> *)yVals withName:(NSString *)name {
    self = [super init];
    if (self) {
        _yVals = yVals;
        _name = name;
    }
    
    return self;
}

@end
