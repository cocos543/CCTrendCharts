//
//  CCXAxisDefaultFormatter.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCXAxisDefaultFormatter.h"

@implementation CCXAxisDefaultFormatter
@synthesize axisInfo = _axisInfo;
@synthesize modulus  = _modulus;
@synthesize modulusStartIndex = _modulusStartIndex;

- (instancetype)initWithAxis:(id<CCProtocolAxisBase>)axisInfo {
    self = [super init];
    if (self) {
        _axisInfo = axisInfo;
        _modulusStartIndex = 0;
        _modulus  = 6;
    }
    return self;
}

/**
 默认的实现, 简单返回原来的字符串
 */
- (NSString *)stringForIndex:(NSInteger)index origin:(NSString *)origin {
    return origin;
}

- (BOOL)needToDrawLabelAt:(NSInteger)index {
    if (_axisInfo == nil) {
        return YES;
    }

    if (index >= self.modulusStartIndex &&
        (index - self.modulusStartIndex) % self.modulus == 0) {
        return YES;
    }

    return NO;
}

@end
