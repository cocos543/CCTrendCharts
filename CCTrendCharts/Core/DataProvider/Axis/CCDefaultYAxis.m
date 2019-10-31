//
//  CCDefaultYAxis.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefaultYAxis.h"

@implementation CCDefaultYAxis

@synthesize font = _font;
@synthesize labelColor = _labelColor;

@synthesize axisColor = _axisColor;
@synthesize axisLineWidth = _axisLineWidth;
//@synthesize labelMaxLine = _labelMaxLine;
@synthesize xLabelOffset = _xLabelOffset;
@synthesize yLabelOffset = _yLabelOffset;

@synthesize labelCount = _labelCount;


- (instancetype)init {
    self = [super init];
    if (self) {
        _formatter = [[NSNumberFormatter alloc] init];
        _formatter.minimumFractionDigits = 2;
        
        _axisColor = UIColor.redColor;
        _axisLineWidth = 1.f;
        _labelColor = UIColor.grayColor;
        _font = [UIFont systemFontOfSize:10];
        
        _xLabelOffset = 5;
        _yLabelOffset = 0;
    }
    return self;
}

- (NSString *)description {
    if (self.dependency == CCYAsixDependencyLeft) {
        return [NSString stringWithFormat:@"left axis, min: %@, max: %@", @(self.axisMinValue), @(self.axisMaxValue)];
    }else {
        return [NSString stringWithFormat:@"right axis, min: %@, max: %@", @(self.axisMinValue), @(self.axisMaxValue)];
    }
    
}

- (void)setAxisMinValue:(CGFloat)axisMinValue {
    self.customValue = YES;
    _axisMinValue = axisMinValue;
}


- (void)setAxisMaxValue:(CGFloat)axisMaxValue {
    self.customValue = YES;
    _axisMaxValue = axisMaxValue;
}

- (NSInteger)entityCount {
    return _entities.count;
}

- (CGSize)requireSize {
    NSString *maxLabel = [self.formatter stringFromNumber:@(self.axisMaxValue)];
    
    CGSize size = [maxLabel sizeWithAttributes:@{NSFontAttributeName: self.font}];
    //实际需要的尺寸应该是 字体宽度+移量
    size.width += self.xLabelOffset;
    size.height += self.yLabelOffset;
    
    return size;
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

#pragma mark - Func

- (void)calculateMinMax:(CCChartData *)charData {
    if (self.customValue) {
        return;
    }
    
    _axisMinValue = charData.minY;
    _axisMaxValue = charData.maxY;
    
    [self generateEntities];
}

- (void)generateEntities {
    
    CGFloat range = fabs(self.axisMaxValue - self.axisMinValue);
    if (range == 0) {
        self.entities = @[];
        return;
    }
    
    NSMutableArray *arr = @[@(self.axisMinValue)].mutableCopy;
    
    NSInteger count = self.labelCount - 2;
    // 将range平均拆分成 count+1 份, 这样就可以均匀地插入count个实体了
    CGFloat stepVal = range / (count + 1);
    
    for (int i = 1; i <= count; i++) {
        [arr addObject:@(self.axisMinValue + (stepVal) * i)];
    }
    
    [arr addObject:@(self.axisMaxValue)];
    
    self.entities = arr;
}


@end
