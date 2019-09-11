//
//  CCXAxisDefaultFormatter.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCXAxisDefaultFormatter.h"

@implementation CCXAxisDefaultFormatter


/**
 默认的实现, 简单返回原来的字符串
 */
- (NSString *)stringForIndex:(NSInteger)x origin:(NSString *)origin {
    return origin;
}

@end
