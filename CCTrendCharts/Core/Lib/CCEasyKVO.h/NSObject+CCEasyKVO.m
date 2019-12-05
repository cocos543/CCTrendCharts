//
//  CCEasyKVO.m
//  OCSimpleView
//
//  Created by Cocos on 2019/7/3.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "NSObject+CCEasyKVO.h"
#import <objc/message.h>

#ifndef CCHashMapKey
#define CCHashMapKey(id, path) [NSString stringWithFormat:@"%@_%@", id, path]

#endif

static void *_ccObserverKey = &_ccObserverKey;
static void *_ccObserveMapKey = &_ccObserveMapKey;

static void *_ccObserverBlockMapKey = &_ccObserverBlockMapKey;

/**
 内部观察者
 */
@interface CCInternalObserver : NSObject

- (NSMapTable *)observeMap;

- (void)removeAll;

@end

@implementation CCInternalObserver

- (void)dealloc {
    [self removeAll];
}



/**
 持有观察者加入的block, 对block进行内存管理

 @return NSDictionary *
 */
- (NSMutableDictionary *)observerBlockDic {
    NSMutableDictionary *dic;
    dic = objc_getAssociatedObject(self, _ccObserverBlockMapKey);
    
    if (dic) {
        return dic;
    }
    
    dic = @{}.mutableCopy;
    objc_setAssociatedObject(self, _ccObserverBlockMapKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return dic;
}

/**
 哈希表, 存放被观察对象, 用于实现自动释放
 
 @return map
 */
- (NSMapTable *)observeMap {
    NSMapTable *map;
    map = objc_getAssociatedObject(self, _ccObserveMapKey);
    
    if (map) {
        return map;
    }
    
    // 默认强引用被观察者, 使用指针数据内容作为key标识符
    map = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPersonality  valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality capacity:1];
    
    objc_setAssociatedObject(self, _ccObserveMapKey, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return map;
}

/**
 移除所有观者对象
 */
- (void)removeAll {
    for(NSObject *obj in self.observeMap) {
        NSArray *arr = [self.observeMap objectForKey:obj];
        [arr[0] removeObserver:self forKeyPath:arr[1]];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // 其实就是strong
    __strong CC_EasyBlock b = (__bridge CC_EasyBlock)context;
    b(object, change);
}

@end
////////// END

@implementation NSObject (CCEasyKVO)

/**
 使用自定义的对象作为观者者
 
 @return observer
 */
- (CCInternalObserver *)observer {
    
    CCInternalObserver *obj;
    obj = objc_getAssociatedObject(self, _ccObserverKey);
    
    if (obj) {
        return obj;
    }
    
    obj = [[CCInternalObserver alloc] init];
    objc_setAssociatedObject(self, _ccObserverKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return obj;
}



# pragma mark - API
- (void)cc_easyObserve:(NSObject *)observe forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(CC_EasyBlock)block {
    
    [self.observer.observeMap setObject:@[observe, keyPath] forKey:@(observe.hash).stringValue];
    
    // 用户传入的block可能是NSStackBlock, 所以在转为泛型指针的时候必须将所有权转移给CoreFoundatin层, 这样一来block类型会转为NSMallocBlock并被持有

    // 对block进行内存管理, 把block copy到堆中, 然后用block在堆中的地址作为key, 存入哈希表中
    CC_EasyBlock b = [block copy];
    
    self.observer.observerBlockDic[[NSString stringWithFormat:@"%p", b]] = b;
    
    [observe addObserver:self.observer forKeyPath:keyPath options:options context:(void *)b];
}

- (void)cc_easyRemoveAllKVO {
    [self.observer removeAll];
}

@end
