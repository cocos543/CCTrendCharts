//
//  CCLineSegment.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/25.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 线段类, 用于简化线段的表示
@interface CCLineSegment : NSObject

- (instancetype)initWithStart:(CGPoint)start end:(CGPoint)end;


/// 起点
@property (nonatomic, assign) CGPoint start;


/// 终点
@property (nonatomic, assign) CGPoint end;

@end

NS_ASSUME_NONNULL_END
