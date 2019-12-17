//
//  CCDefaultXAxis.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefaultXAxis.h"
#import "CCXAxisDefaultFormatter.h"

@interface CCDefaultXAxis () {
    BOOL _customRequireSize;
}
@end

@implementation CCDefaultXAxis
@synthesize labelDisable     = _labelDisable;

@synthesize axisColor        = _axisColor;
@synthesize axisLineWidth    = _axisLineWidth;
@synthesize axisLineDisabled = _axisLineDisabled;
@synthesize font = _font;
@synthesize labelColor       = _labelColor;

@synthesize xLabelOffset     = _xLabelOffset;
@synthesize yLabelOffset     = _yLabelOffset;
@synthesize requireSize      = _requireSize;

@synthesize gridColor        = _gridColor;
@synthesize gridLineWidth    = _gridLineWidth;
@synthesize gridLineEnabled  = _gridLineEnabled;

- (instancetype)init {
    self = [super init];
    if (self) {
        _axisColor       = UIColor.grayColor;
        _axisLineWidth   = 1.f;

        _gridLineWidth   = 1.f;
        _gridColor       = [UIColor.lightGrayColor colorWithAlphaComponent:0.2];
        _gridLineEnabled = YES;

        _font = [UIFont systemFontOfSize:10];
        _labelColor      = UIColor.grayColor;

        _xLabelOffset    = 0;
        _yLabelOffset    = 5;

        _startMargin     = 0.5;
        _endMargin       = 0.5;
        _xSpace = 8.f;
        _autoXSapce      = NO;
        _totalCount      = 0;

        // 设置默认的formatter对象
        _formatter       = [[CCXAxisDefaultFormatter alloc] init];
    }
    return self;
}

/// 这里取第一个元素的文案信息
- (CGSize)requireSize {
    if (_customRequireSize) {
        return _requireSize;
    }

    if (self.entities.count <= 0) {
        return CGSizeZero;
    }

    NSString *maxLabel = [self.formatter stringForIndex:0 origin:self.entities[0]];

    CGSize size        = [maxLabel sizeWithAttributes:@{ NSFontAttributeName: self.font }];
    size.width  += self.xLabelOffset;
    size.height += self.yLabelOffset;

    return size;
}

- (void)setRequireSize:(CGSize)requireSize {
    _customRequireSize = YES;
    _requireSize       = requireSize;
}

- (void)setTotalCount:(NSInteger)totalCount {
    self.autoXSapce = YES;
    _totalCount     = totalCount;
}

#pragma mark - NSCopying
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    typeof(self) axis     = [[self.class allocWithZone:zone] init];

    axis.axisLineDisabled = self.axisLineDisabled;
    axis.axisColor        = [self.axisColor copy];
    axis.axisLineWidth    = self.axisLineWidth;
    axis.font = [self.font copy];
    axis.labelColor       = [self.labelColor copy];
    axis.labelDisable     = self.labelDisable;
    axis.xLabelOffset     = self.xLabelOffset;
    axis.yLabelOffset     = self.yLabelOffset;

    if (_customRequireSize) {
        axis.requireSize = self.requireSize;
    }

    axis.gridColor       = [self.gridColor copy];
    axis.gridLineWidth   = self.gridLineWidth;
    axis.gridLineEnabled = self.gridLineEnabled;

    axis.formatter       = [(NSObject *)self.formatter copy];
    axis.labelPosition   = self.labelPosition;

    axis.startMargin     = self.startMargin;
    axis.endMargin       = self.endMargin;

    return axis;
}

@end
