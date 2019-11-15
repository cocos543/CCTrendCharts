//
//  CCChartDataSetBase.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/10/9.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartDataSetBase.h"

@implementation CCChartDataSetBase
@synthesize entities = _entities;

@synthesize color = _color;
@synthesize maxY  = _maxY;
@synthesize minY  = _minY;
@synthesize name  = _name;
@synthesize maxX  = _maxX;
@synthesize minX  = _minX;

- (instancetype)initWithVals:(NSArray<id<CCProtocolChartDataEntityBase>> *)entities withName:(CCDataSetName)name {
    self = [super init];
    if (self) {
        _entities = entities;
        _name  = name;
        
        [self resetValue];

        [self calcMinMaxStart:NSIntegerMin End:NSIntegerMax];
    }

    return self;
}

- (void)resetValue {
    _maxY = CGFLOAT_MIN;
    _minY = CGFLOAT_MAX;
    
    _maxX = NSIntegerMin;
    _minX = NSIntegerMax;
}

/**
 重新计算数据集中的最值
 */
- (void)calcMinMaxStart:(NSInteger)start End:(NSInteger)end {
    [self resetValue];
    
    for (id<CCProtocolChartDataEntityBase> val in self.entities) {
        if (val.xIndex < start || val.xIndex > end) {
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

- (NSArray<id<CCProtocolChartDataEntityBase>> *)entityForIndex:(NSInteger)index {
    NSMutableArray *arr;
    for (id<CCProtocolChartDataEntityBase> val in self.entities) {
        if (val.xIndex == index) {
            if (!arr) {
                arr = @[].mutableCopy;
            }
            [arr addObject:val];
        }
    }
    return arr;
}

#pragma mark - Setter & Getter
- (void)setEntities:(NSArray<id<CCProtocolChartDataEntityBase>> *)entities {
    _entities = entities;

    [self calcMinMaxStart:NSIntegerMin End:NSIntegerMax];
}

@end
