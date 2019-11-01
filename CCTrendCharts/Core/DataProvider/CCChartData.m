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

#pragma mark - Getter & Setter
- (void)setDataSets:(NSArray<id<CCProtocolChartDataSet>> *)dataSets {
    _dataSets = dataSets;
    
    [self calcMinMaxStart:NSIntegerMin End:NSIntegerMax];
}

@end
