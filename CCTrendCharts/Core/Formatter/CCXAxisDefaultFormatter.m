//
//  CCXAxisDefaultFormatter.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCXAxisDefaultFormatter.h"

@interface CCXAxisDefaultFormatter ()

@property (nonatomic, assign) NSUInteger modulus;

@end

@implementation CCXAxisDefaultFormatter
@synthesize modulusStartIndex = _modulusStartIndex;
@synthesize minModulus = _minModulus;

- (instancetype)init {
    self = [super init];
    if (self) {
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

    if (index >= self.modulusStartIndex &&
        (index - self.modulusStartIndex) % self.modulus == 0) {
        return YES;
    }

    return NO;
}

/// 更新当前的modules, 防止x轴文案重叠
- (void)calcModulusWith:(CGFloat)contentWidth xSpace:(CGFloat)space labelSize:(CGSize)size {
    // 计算出可见区域一共可以绘制多少个文案
    NSInteger count = ceil(contentWidth / fabs(space));
    
    
    // 为了避免label太密集, 这里假设label的宽度更长一下
    CGSize hhh = [@"hhh" sizeWithAttributes:nil];
    size.width += hhh.width;
    
    // 总宽度需要乘以放大系数
    self.modulus = MAX(ceil(count * size.width / contentWidth), self.minModulus);
}

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    typeof(self) fat = [[self.class allocWithZone:zone] init];
    fat.modulus = self.modulus;
    fat.modulusStartIndex = self.modulusStartIndex;
    fat.minModulus = self.minModulus;
    
    return fat;
}
@end
