//
//  CCDefaultXAxis.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefaultXAxis.h"
#import "CCXAxisDefaultFormatter.h"

@implementation CCDefaultXAxis

@synthesize axisColor = _axisColor;
@synthesize axisLineWidth = _axisLineWidth;
@synthesize font = _font;
@synthesize labelColor = _labelColor;
//@synthesize labelMaxLine = _labelMaxLine;
@synthesize xLabelOffset = _xLabelOffset;
@synthesize yLabelOffset = _yLabelOffset;

- (instancetype)init {
    self = [super init];
    if (self) {
        _axisColor = UIColor.blueColor;
        _axisLineWidth = 1.f;
        
        _font = [UIFont systemFontOfSize:10];
        _labelColor = UIColor.grayColor;
        
        _xLabelOffset = 0;
        _yLabelOffset = 5;
        
        // 设置默认的formatter对象
        _formatter = [[CCXAxisDefaultFormatter alloc] initWithAxis:self];
    }
    return self;
}

@end
