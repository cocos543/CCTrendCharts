//
//  CCChartViewBase.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewBase.h"

@implementation CCChartViewBase
@synthesize xAxis = _xAxis;
@synthesize leftAxis = _leftAxis;
@synthesize rightAxis = _rightAxis;


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _leftAxis = nil;
        _rightAxis = nil;
        _xAxis = nil;
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (NSString *)description {
    NSString *desc = [super description];
    return [NSString stringWithFormat:@"%@ --- %@", desc, [NSString stringWithFormat:@"%p", &_leftAxis]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
