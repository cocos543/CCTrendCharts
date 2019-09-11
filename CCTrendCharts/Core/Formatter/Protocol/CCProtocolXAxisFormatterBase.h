//
//  CCProtocolFormatterBase.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>


// X轴上的文案信息不像Y轴, 应该理解成是用户是否自行定义文案样式, 而不一定是数值
@protocol CCProtocolXAxisFormatterBase <NSObject>


/**
 根据传入的x轴信息和原始字符串, 返回对应格式化后的字符串
 
 @param x x轴索引
 @param origin 原始字符串
 @return 格式化后的字符串
 */
- (NSString *)stringForIndex:(NSInteger)x origin:(NSString *)origin;

@end

