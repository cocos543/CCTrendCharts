//
//  CCChartDataSetBase.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/10/9.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartDataSetBase.h"

@implementation CCChartDataSetBase
@synthesize color = _color;
@synthesize maxY  = _maxY;
@synthesize minY  = _minY;
@synthesize yVals = _yVals;
@synthesize name  = _name;
@synthesize maxX  = _maxX;
@synthesize minX  = _minX;

- (instancetype)initWithVals:(NSArray<CCChartDataEntity *> *)yVals withName:(NSString *)name {
    self = [super init];
    if (self) {
        _yVals = yVals;
        _name  = name;
        _minY  = CGFLOAT_MAX;
        _maxY  = CGFLOAT_MIN;

        _minX  = NSIntegerMin;
        _maxX  = NSIntegerMax;

        [self calcMinMaxStart:-1 End:-1];
    }

    return self;
}

/**
 重新计算数据集中的最值
 */
- (void)calcMinMaxStart:(NSInteger)start End:(NSInteger)end {
    for (CCChartDataEntity *val in self.yVals) {
        if (val.xIndex < start && val.xIndex > end) {
            continue;
        }

        if (_minY > val.value) {
            _minY = val.value;
        }
        if (_maxY < val.value) {
            _maxY = val.value;
        }

        if (_minX > val.xIndex) {
            _minX = val.xIndex;
        }
        if (_maxX < val.xIndex) {
            _maxX = val.xIndex;
        }
    }
}

@end
