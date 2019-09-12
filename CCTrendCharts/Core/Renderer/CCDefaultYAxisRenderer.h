//
//  CCDefaultYAxisRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/12.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolAxisRenderer.h"
#import "CCDefaultYAxis.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCDefaultYAxisRenderer : NSObject <CCProtocolAxisRenderer>

@property (nonatomic, weak) CCDefaultYAxis *axis;

/**
 传入最小, 最大值, 渲染层根据axis对象计算出y轴上的全部label

 @param min min
 @param max max
 */
- (void)processAxisEntities:(CGFloat)min :(CGFloat)max;

@end

NS_ASSUME_NONNULL_END
