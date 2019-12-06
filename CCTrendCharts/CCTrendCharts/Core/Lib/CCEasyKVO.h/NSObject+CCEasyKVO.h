//
//  CCEasyKVO.h
//  OCSimpleView
//
//  https://github.com/cocos543/CCEasyKVO
//
//  Created by Cocos on 2019/7/3.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 @abstract 回调函数
 @param object 状态发生变化的对象(被观察者)
 @param change 发生变化的信息
 */

typedef void (^CC_EasyBlock)(id object, NSDictionary<NSKeyValueChangeKey, id> *change);

@interface NSObject (CCEasyKVO)


/**
 简易KVO

 @param observe 被观察者
 @param keyPath key
 @param options options
 @param block 回调函数
 */
- (void)cc_easyObserve:(id)observe forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(CC_EasyBlock) block;

- (void)cc_easyRemoveAllKVO;

@end

NS_ASSUME_NONNULL_END
