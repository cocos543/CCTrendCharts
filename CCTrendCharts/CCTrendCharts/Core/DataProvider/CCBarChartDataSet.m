//
//  CCBarChartDataSet.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/12/24.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCBarChartDataSet.h"

CCDataSetName const kCCNameBarDataSet = @"kCCNameBarDataSet";

@implementation CCBarChartDataSet

- (instancetype)initWithEntities:(NSArray<id<CCProtocolChartDataEntityBase>> *)entities withName:(CCDataSetName)name {
    if (name == nil) {
        name = kCCNameBarDataSet;
    }
    
    self = [super initWithEntities:entities withName:name];
    if (self) {
        _entityDistancePercent = 0.7;
    }
    return self;
}

@end
