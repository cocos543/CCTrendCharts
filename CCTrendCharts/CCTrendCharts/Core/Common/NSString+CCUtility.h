//
//  NSString+CCUtility.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/10/8.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CCUtility)


/**
 绘制字符串

 @param ctx 上下文对象
 @param x x方向位置
 @param y y方向位置
 @param anchor 文本锚点, 取值范围:0~1 (锚点总是和提供的x,y重合. 如果提供的x,y是文本的中心, 则锚点传入(0.5,0.5) )
 @param attr 字符串属性
 */
- (void)drawTextIn:(CGContextRef)ctx x:(CGFloat)x y:(CGFloat)y anchor:(CGPoint)anchor attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attr;



/// 将字符设置到指定的CATextLayer上, 并这是Layer的位置到指定位置
/// @param layer 目标图层
/// @param point 位置
/// @param anchor 文本锚点, 取值范围:0~1 (锚点总是和提供的x,y重合. 如果提供的x,y是文本的中心, 则锚点传入(0.5,0.5) )
/// @param attr 字符串属性
- (void)drawTextInLayer:(CATextLayer *)layer point:(CGPoint)point anchor:(CGPoint)anchor attributes:(NSDictionary<NSAttributedStringKey,id> *)attr;

@end

NS_ASSUME_NONNULL_END
