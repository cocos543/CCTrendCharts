//
//  CCKLineChartDataSet.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCKLineChartDataSet.h"

CCDataSetName const kCCNameKLineDataSet = @"KLineDataSet";

@implementation CCKLineChartDataSet
// 由父类合成
@dynamic entities;

// 子类重新合成变量, 因为这个变量本身是不对外界开放修改的, 只能这么做了
@synthesize maxY = _maxY;
@synthesize minY = _minY;
@synthesize maxX = _maxX;
@synthesize minX = _minX;

/// 指定的初始化方法
/// @param entities 实体
/// @param name 数据集名字, 默认是kCCNameKLineDataSet
- (instancetype)initWithEntities:(NSArray<CCKLineDataEntity *> *)entities withName:(CCDataSetName)name {
    if (name == nil) {
        name = kCCNameKLineDataSet;
    }

    self = [super initWithEntities:entities withName:name];
    if (self) {
        _risingColor   = [UIColor stringToColor:@"#de4e43" opacity:1];
        _fallingColor  = [UIColor stringToColor:@"#4ba74a" opacity:1];
        _flatColor     = UIColor.lightGrayColor;
        _isRisingFill  = YES;
        _isFallingFill = YES;
        _lineWidth     = 1.f;
    }
    [self resetValue];

    [self calcMinMaxStart:NSIntegerMin End:NSIntegerMax];

    return self;
}

// 这里需要重写, 因为父类修改的是父类的私有变量
- (void)resetValue {
    _maxY = -CGFLOAT_MAX;
    _minY = CGFLOAT_MAX;

    _maxX = NSIntegerMin;
    _minX = NSIntegerMax;
}

/// K线数据集的最值计算方法, 是通过数据实体中的最高最低值字段计算出的, 所以需要重写父类方法
/// @param start 起点
/// @param end 终点
- (void)calcMinMaxStart:(NSInteger)start End:(NSInteger)end {
    [self resetValue];

    for (CCKLineDataEntity *val in self.entities) {
        if (val.xIndex < start || val.xIndex > end) {
            continue;
        }
        
        if (_minY > val.lowest) {
            _minY = val.lowest;
        }

        if (_maxY < val.highest) {
            _maxY = val.highest;
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
