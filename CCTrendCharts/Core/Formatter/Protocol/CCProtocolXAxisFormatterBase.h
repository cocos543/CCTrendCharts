//
//  CCProtocolFormatterBase.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolAxisBase.h"

// X轴上的文案信息不像Y轴, 应该理解成是用户是否自行定义文案样式, 而不一定是数值
@protocol CCProtocolXAxisFormatterBase <NSObject>


/**
 根据传入的x轴信息和原始字符串, 返回对应格式化后的字符串
 
 @param index x轴索引
 @param origin 原始字符串
 @return 格式化后的字符串
 */
- (NSString *)stringForIndex:(NSInteger)index origin:(NSString *)origin;


/**
 是否需要绘制指定index的文案

 @param index 数据实体的索引
 @return 是否需要绘制文案
 */
- (BOOL)needToDrawLabelAt:(NSInteger)index;


/// 更新当前的modulus
- (void)calcModulusWith:(CGFloat)contentWidth xSpace:(CGFloat)space labelSize:(CGSize)size;


/**
 modulus参数生效的起始位置
 */
@property (nonatomic, assign) NSInteger modulusStartIndex;


/**
 模, 自动计算
 
 索引 % modulus == 0 时, 对应的文案才会被绘制
 */
@property (nonatomic, assign, readonly) NSUInteger modulus;


/// 用户可以设置最小间隔, 防止缩小时太过密集
@property (nonatomic, assign) NSUInteger minModulus;

@end

