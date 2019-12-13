//
//  CCLineChartDataSet.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/22.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCLineChartDataSet.h"

CCDataSetName const kCCNameLineDataSet = @"LineDataSet";

@implementation CCLineChartDataSet

- (instancetype)initWithVals:(NSArray<id<CCProtocolChartDataEntityBase>> *)entities withName:(CCDataSetName)name {
    if (name == nil) {
        name = kCCNameLineDataSet;
    }
    
    self = [super initWithVals:entities withName:name];
    if (self) {
        _lineJoin = kCALineJoinRound;
        _lineWidth = 1.f;
        _fillColor = UIColor.clearColor;
    }
    return self;
}

@end
