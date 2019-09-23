//
//  CCDefaultXAxis.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefaultXAxis.h"

@implementation CCDefaultXAxis

@synthesize axisColor = _axisColor;
@synthesize axisLineWidth = _axisLineWidth;
@synthesize font = _font;
@synthesize labelColor = _labelColor;
@synthesize labelCount = _labelCount;
@synthesize labelMaxLine = _labelMaxLine;


- (instancetype)init {
    self = [super init];
    if (self) {
        _axisColor = UIColor.blueColor;
        _axisLineWidth = 1.f;
    }
    return self;
}


- (NSInteger)startIndexForDrawLabel {
    return 0;
}

@end
