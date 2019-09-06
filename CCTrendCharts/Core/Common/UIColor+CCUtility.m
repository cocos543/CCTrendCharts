//
//  UIColor+CCUtility.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/5.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "UIColor+CCUtility.h"

@implementation UIColor (CCUtility)

+ (UIColor *)stringToColor:(NSString *)str opacity:(CGFloat)opacity {
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    
    if (![str hasPrefix:@"#"]) {
        NSLog(@"%@ is not beging with #",str);
    }
    
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:opacity];
    return color;
}



@end
