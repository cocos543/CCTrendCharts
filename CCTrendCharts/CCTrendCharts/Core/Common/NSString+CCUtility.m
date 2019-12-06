//
//  NSString+CCUtility.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/10/8.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "NSString+CCUtility.h"

@implementation NSString (CCUtility)

- (void)drawTextIn:(CGContextRef)ctx x:(CGFloat)x y:(CGFloat)y anchor:(CGPoint)anchor attributes:(NSDictionary<NSAttributedStringKey,id> *)attr {
    
    UIGraphicsPushContext(ctx);
    
    CGPoint drawPoint = CGPointMake(x, y);
    // 获取文本尺寸
    CGSize labelSize = [self sizeWithAttributes:attr];
    
    drawPoint.x = x - labelSize.width * anchor.x;
    drawPoint.y = y - labelSize.height * anchor.y;
    
    CGContextIndependent(ctx, {
        [self drawAtPoint:drawPoint withAttributes:attr];
    })
    
    UIGraphicsPopContext();
}

@end
