//
//  CCBaseUtility.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/27.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCBaseUtility : NSObject

+ (CGFloat)floatRandomBetween:(CGFloat)a and:(CGFloat)b;

+ (NSInteger)intRandomBetween:(NSInteger)a and:(NSInteger)b;

+ (CGFloat)currentScale;

@end

NS_ASSUME_NONNULL_END
