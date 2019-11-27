//
//  CCLineSegment.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/25.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCLineSegment.h"

@implementation CCLineSegment

- (instancetype)initWithStart:(CGPoint)start end:(CGPoint)end {
    self = [super init];
    if (self) {
        _start = start;
        _end   = end;
    }
    return self;
}

@end
