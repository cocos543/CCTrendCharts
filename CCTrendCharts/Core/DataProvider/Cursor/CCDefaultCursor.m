//
//  CCDefaultCursor.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/5.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefaultCursor.h"

@implementation CCDefaultCursor
@synthesize lineWidth = _lineWidth;
@synthesize lineDashPhase = _lineDashPhase;
@synthesize lineDashLengths = _lineDashLengths;
@synthesize lineColor = _lineColor;
@synthesize lineCap = _lineCap;
@synthesize font = _font;
@synthesize labelColor = _labelColor;

- (instancetype)init {
    self = [super init];
    if (self) {
        _lineWidth = 1.f;
        _lineColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
        _font = [UIFont systemFontOfSize:10];
        _lineCap = kCGLineCapRound;
        _labelColor = UIColor.whiteColor;
        _lineDashPhase = 0.f;
        
    }
    return self;
}



@end
