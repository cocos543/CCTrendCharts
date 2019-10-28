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
@synthesize axisInfo = _axisInfo;
@synthesize modulusStartIndex = _modulusStartIndex;
@synthesize minModulus = _minModulus;

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

/// 更新当前的modules, 防止x轴文案重叠
- (void)calcModulusWith:(CGFloat)contentWidth xSpace:(CGFloat)space labelSize:(CGSize)size {
    // 计算出可见区域一共可以绘制多少个文案
    NSInteger count = ceil(contentWidth / space);
    
    // 总宽度需要乘以放大系数
    self.modulus = MAX(ceil(count * size.width / contentWidth), self.minModulus);
    
}

@end
