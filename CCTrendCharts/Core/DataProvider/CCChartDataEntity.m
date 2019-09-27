//
//  CCChartDataEntity.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartDataEntity.h"

@implementation CCChartDataEntity
@synthesize value = _value;
@synthesize xIndex = _xIndex;
@synthesize data = _data;

- (instancetype)init {
    return [self initWithValue:0 xIndex:0 data:nil];
}

- (instancetype)initWithValue:(CGFloat)value xIndex:(NSInteger)xIndex data:(id)data {
    self = [super init];
    if (self) {
        _value = value;
        _xIndex = xIndex;
        _data = data;
    }
    return self;
}





@end
