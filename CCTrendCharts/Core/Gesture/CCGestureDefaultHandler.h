//
//  CCGestureDefaultHandler.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/10/24.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCGestureHandlerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCGestureDefaultHandler : NSObject <CCGestureHandlerProtocol>

/// 初始化方法
- (instancetype)initWithTransformer:(CCChartViewPixelHandler *)viewPixelHandler;

@end

NS_ASSUME_NONNULL_END
