//
//  CCDefualtYAxis.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefualtYAxis.h"

@implementation CCDefualtYAxis

@synthesize font = _font;
@synthesize labelColor = _labelColor;
@synthesize labelCount = _labelCount;
@synthesize axisColor = _axisColor;
@synthesize axisLineWidth = _axisLineWidth;
@synthesize labelMaxLine = _labelMaxLine;

- (void)setAxisMinValue:(CGFloat)axisMinValue {
    self.customValue = YES;
    _axisMinValue = axisMinValue;
}


- (void)setAxisMaxValue:(CGFloat)axisMaxValue {
    self.customValue = YES;
    _axisMaxValue = axisMaxValue;
}



@end
