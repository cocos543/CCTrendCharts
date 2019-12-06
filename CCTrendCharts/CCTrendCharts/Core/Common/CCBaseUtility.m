//
//  CCBaseUtility.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/27.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCBaseUtility.h"

@implementation CCBaseUtility

+ (CGFloat)floatRandomBetween:(CGFloat)a and:(CGFloat)b {
    // 精度默认8位数
    const CGFloat precision = 100000000.0;
    
    int startVal = a * precision;
    // 确保随机数包含b
    int endVal = b * precision + 1;
    
    int randomValue = startVal + (arc4random() % (endVal - startVal));
    
    return (randomValue / precision);
}

+ (NSInteger)intRandomBetween:(NSInteger)a and:(NSInteger)b {
    // 确保随机数包含b
    b++;
    return a + (arc4random() % (b - a));
}

+ (CGFloat)currentScale {
    return UIScreen.mainScreen.scale;
}

@end
