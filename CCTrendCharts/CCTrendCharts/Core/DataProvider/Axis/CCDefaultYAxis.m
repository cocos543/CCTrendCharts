//
//  CCDefaultYAxis.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefaultYAxis.h"

@interface CCDefaultYAxis () {
    BOOL _customRequireSize;
}

@end

@implementation CCDefaultYAxis

@synthesize font            = _font;
@synthesize labelColor      = _labelColor;

@synthesize axisColor       = _axisColor;
@synthesize axisLineWidth   = _axisLineWidth;
//@synthesize labelMaxLine = _labelMaxLine;
@synthesize xLabelOffset    = _xLabelOffset;
@synthesize yLabelOffset    = _yLabelOffset;

@synthesize labelCount      = _labelCount;
@synthesize requireSize     = _requireSize;

@synthesize gridColor       = _gridColor;
@synthesize gridLineWidth   = _gridLineWidth;
@synthesize gridLineEnabled = _gridLineEnabled;

- (instancetype)initWithDependency:(CCYAsixDependency)dependency {
    self = [super init];
    if (self) {
        _formatter                       = [[NSNumberFormatter alloc] init];
        _formatter.minimumFractionDigits = 2;

        _axisColor                       = UIColor.redColor;
        _axisLineWidth                   = 1.f;
        _labelColor                      = UIColor.grayColor;
        _font = [UIFont systemFontOfSize:10];

        _gridLineWidth                   = 1.f;
        _gridColor                       = [UIColor.lightGrayColor colorWithAlphaComponent:0.2];
        _gridLineEnabled                 = YES;

        _xLabelOffset                    = 5;
        _yLabelOffset                    = 0;

        _minMaxRangeExtraPrecent         = 0.05;

        _dependency                      = dependency;
    }
    return self;
}

- (NSString *)description {
    if (self.dependency == CCYAsixDependencyLeft) {
        return [NSString stringWithFormat:@"left axis, min: %@, max: %@", @(self.axisMinValue), @(self.axisMaxValue)];
    } else {
        return [NSString stringWithFormat:@"right axis, min: %@, max: %@", @(self.axisMinValue), @(self.axisMaxValue)];
    }
}

- (void)setAxisMinValue:(CGFloat)axisMinValue {
    self.customValue = YES;
    _axisMinValue    = axisMinValue;
}

- (void)setAxisMaxValue:(CGFloat)axisMaxValue {
    self.customValue = YES;
    _axisMaxValue    = axisMaxValue;
}

- (NSInteger)entityCount {
    return _entities.count;
}

- (CGSize)requireSize {
    if (_customRequireSize) {
        return _requireSize;
    }

    NSString *maxLabel = [self.formatter stringFromNumber:@(self.axisMaxValue)];

    CGSize size        = [maxLabel sizeWithAttributes:@{ NSFontAttributeName: self.font }];
    //实际需要的尺寸应该是 字体宽度+移量
    size.width  += self.xLabelOffset;
    size.height += self.yLabelOffset;

    return size;
}

- (void)setRequireSize:(CGSize)requireSize {
    _customRequireSize = YES;
    _requireSize       = requireSize;
}

- (NSInteger)labelCount {
    if (_labelCount == 0) {
        return 2;
    }
    return _labelCount;
}

- (void)setLabelCount:(NSInteger)labelCount {
    if (labelCount < 2) {
        return;
    }
    _labelCount = labelCount;
    [self generateEntities];
}

- (CGFloat)rangeValue {
    return _axisMaxValue = _axisMinValue;
}

#pragma mark - Func

- (void)calculateMinMax:(CCChartData *)charData {
    if (!self.customValue) {
        CGFloat range = charData.maxY - charData.minY;
        _axisMinValue = charData.minY - _minMaxRangeExtraPrecent * range;
        _axisMaxValue = charData.maxY + _minMaxRangeExtraPrecent * range;
    }

    [self generateEntities];
}

- (void)generateEntities {
    CGFloat range = fabs(self.axisMaxValue - self.axisMinValue);
    if (range == 0) {
        self.entities = @[];
        return;
    }

    NSMutableArray *arr = @[@(self.axisMinValue)].mutableCopy;

    NSInteger count     = self.labelCount - 2;
    // 将range平均拆分成 count+1 份, 这样就可以均匀地插入count个实体了
    CGFloat stepVal     = range / (count + 1);

    for (int i = 1; i <= count; i++) {
        [arr addObject:@(self.axisMinValue + (stepVal) * i)];
    }

    [arr addObject:@(self.axisMaxValue)];

    self.entities = arr;
}

#pragma mark - NSCopying
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) axis            = [[self.class allocWithZone:zone] init];

    axis.axisColor               = [self.axisColor copy];
    axis.axisLineWidth           = self.axisLineWidth;
    axis.font = [self.font copy];
    axis.labelColor              = [self.labelColor copy];
    axis.xLabelOffset            = self.xLabelOffset;
    axis.yLabelOffset            = self.yLabelOffset;
    axis.requireSize             = self.requireSize;
    axis.gridColor               = [self.gridColor copy];
    axis.gridLineWidth           = self.gridLineWidth;
    axis.gridLineEnabled         = self.gridLineEnabled;

    // Y轴自带
    axis.formatter               = [self.formatter copy];
    axis.customValue             = self.customValue;
    axis.labelCount              = self.labelCount;
    axis.minMaxRangeExtraPrecent = self.minMaxRangeExtraPrecent;
    axis.labelPosition           = self.labelPosition;
    axis.dependency              = self.dependency;
    
    // 最大最小值实时计算的, 无需copy;
    return axis;
}

@end
