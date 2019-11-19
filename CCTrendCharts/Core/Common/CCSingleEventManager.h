//
//  CCSingleEventManager.h
//  CCTrendCharts
//
//  单事件管理器
//
//  Created by Cocos on 2019/11/19.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCSingleEventManager : NSObject


/// 标记事件已完成
- (void)done;


/// 新事件产生时, 调用该方法传入事件Block, 调用该方法之后必须调用done, 才能响应下一个事件
/// @param eventBlock void(^)(void)
- (void)newEventWithBlock:(nonnull dispatch_block_t)eventBlock;

@end

NS_ASSUME_NONNULL_END
