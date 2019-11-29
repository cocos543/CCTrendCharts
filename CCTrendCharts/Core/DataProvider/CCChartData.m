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
        _dataSets = dataSets.mutableCopy;
        _xSpace = 8;
        
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

- (void)calcMinMaxStart:(NSInteger)start End:(NSInteger)end {
    // 重置最大最小值
    [self resetValue];
    
    for (id<CCProtocolChartDataSet> dataSet in self.dataSets) {
        
        [dataSet calcMinMaxStart:start End:end];
        // 计算 y
        if (_minY > dataSet.minY) {
            _minY = dataSet.minY;
        }
        if (_maxY < dataSet.maxY) {
            _maxY = dataSet.maxY;
        }
        
        // 计算 x
        if (_minX > dataSet.minX) {
            _minX = dataSet.minX;
        }
        if (_maxX < dataSet.maxX) {
            _maxX = dataSet.maxX;
        }
    }
}

- (NSArray<id<CCProtocolChartDataEntityBase>> *)entitiesForIndex:(NSInteger)index {
    for (id<CCProtocolChartDataSet> dataSet in self.dataSets) {
        return [dataSet entityForIndex:index];

    }
    return nil;
}

- (NSArray<id<CCProtocolChartDataEntityBase>> *)entityForIndex:(NSInteger)index inDataSet:(NSString *)dataSetName {

    NSArray<id<CCProtocolChartDataSet>> *dataSets = [self dataSetWithName:dataSetName];
    NSMutableArray *arr;
    for (id<CCProtocolChartDataSet> dataSet in dataSets) {
        if ([dataSet entityForIndex:index]) {
            if (!arr) {
                arr = @[].mutableCopy;
            }
            [arr addObject:[dataSet entityForIndex:index]];
        }
    }
    return arr;
}

- (NSMutableArray<id<CCProtocolChartDataSet>> *)dataSetWithName:(CCDataSetName)name {
    NSMutableArray *arr;
    for (id<CCProtocolChartDataSet> set in self.dataSets) {
        if ([set.name isEqualToString:name]) {
            if (!arr) {
                arr = @[].mutableCopy;
            }
            [arr addObject:set];
        }
    }
    return arr.mutableCopy;
}

#pragma mark - Getter & Setter
- (void)setDataSets:(NSArray<id<CCProtocolChartDataSet>> *)dataSets {
    _dataSets = dataSets.mutableCopy;
    
    [self calcMinMaxStart:NSIntegerMin End:NSIntegerMax];
}

@end
