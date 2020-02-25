# 文档更新说明
* 最后更新 2019年08月27日
* 首次更新 2019年07月03日

# 前言
　　OC为用户提供了一套观察者模式(KVO), 当对象的某些属性发生变化之后, 就会向所有观察者(observer)广播消息, 具体的KVO基本用法这里就不说了. 下面主要说一下为系统的KVO功能添加block的思路, 先看一下最终的API:

```objectivec
UIView *v = [[UIView alloc] init];
NSObject *obj = [[NSObject alloc] init];

[obj cc_easyObserve:v forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew block:^(id object, NSDictionary<NSKeyValueChangeKey,id> *change) {
	NSLog(@"hello");
}];

```

# 安装方法
通过 CocoaPods

```
pod 'CCEasyKVO'
```

# 在KVO中传送block的方法
　　要添加block功能到系统的KVO中, 首先要做的事情是传这个block指针能传入KVO中, 在消息广播的时候又能把这个block带回来.先看一下系统的API:
　　
```objectivec
// NSObject类
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

// 观察者(observer)必须实现下面方法才能接收到广播
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context;
```

其中有一个参数是content, 允许传入`void *`类型的指针, 所以我们可以直接把用户传入的block转成`void *`类型, 传入KVO中, 这样当消息进行广播的时候, 就可以从这个context中得到block的地址, 再调用block即可.

# 利用内部观察者创建便捷API
　　经过上面分析可知, 要为系统的KVO功能添加block特性理论上是可行的, 下面就开始代码的实现部分. 
　　添加block属性就是为了方便使用系统的KVO功能, 所以我们首选分类(Category)来实现, 直接扩展NSObject, 这样所有的对象都有便捷的操作了.

```objectivec
// NSObject+CCEasyKVO.h

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
```

上面就是我们的头文件部分, 比较简单, 主要就是提供了一套便捷KVO的api, 其中`CC_EasyBlock`就是用户需要传入的block.

### 遇到的第一个问题
　　接下来要解决一个重要的问题. 我们能否直接使用当前被分类的对象作为观者者直接观察`observe`呢? 答案是否定的, 这个你可以自己尝试一下. 原因就是当用户在被分类的类里也实现了系统KVO接受广播的方法`observeValueForKeyPath...`时, 分类代码里就无法再收到系统的广播了.
为了解决这个问题, 我们可以在分类里使用自定义的类(CCInternalObserver)来作为观察者, 这样就算用户给自己的类实现了接受广播的方法, 也不影响我们的代码. 我们在CCInternalObserver里实现`observeValueForKeyPath...`, 当广播到来时, 调用context指向的block.

### 遇到的第二个问题
　　如何避免用户传入的block内存被释放? 简单说就是如何管理block内存? oc的block一共有三种, 分别是全局块`NSGlobalBlock`, 堆块`NSMallocBlock`, 栈块`NSStackBlock`. 这里顺便简单介绍一下他们的区别:

	(1) block类型区别
	没有引用外部任何变量(static变量除外), 创建的就是NSGlobalBlock;
	除了NSGlobalBlock, 其他创建的时候就是NSStackBlock, 赋值给strong类型的变量之后就是NSMallocBlock, 这里也称之为copy操作;
	在符合NSStatckBlock的条件下, 可以通过两种方法获取NSStatckBlock:
	1. 在调用方法时创建匿名block, 在方法内部得到的block变量是NSStatckBlock
	2. 创建的block赋值给__weak变量.

	(2) 内存管理
	NSStackBlock类型的块, 会随栈内存释放而释放, 使用的时候需要先用strong变量存储起来, 否则将crash;
	NSGlobalBlock类型的块, 不会被释放; NSMallocBlock类型和其他引用类型一样, 没人引用就会被释放;
	除了NSStackBlock类型, 其他类型赋值给变量的时候都不会重复copy.

用户传入的block可能是三种类型之一, 为了避免内存出问题, 在转成void *的时候就需要做一点额外的处理, 才能传给系统的KVO:

```objectivec
// 用户传入的block可能是NSStackBlock, 所以在转为泛型指针的时候必须转为NSMallocBlock并被持有
// 对block进行内存管理, 把block copy到堆中, 然后用block在堆中的地址作为key, 存入哈希表中
CC_EasyBlock b = [block copy];

self.observer.observerBlockDic[[NSString stringWithFormat:@"%p", b]] = b;
[observe addObserver:self.observer forKeyPath:keyPath options:options context:(void *)b];

```
顺便说一句, `self.observer`就是上面说的`CCInternalObserver` : )

### 遇到的第三个问题
　　第三个问题就是如何注销观察者. 系统的KVO功能还有一个麻烦的地方就是每次用完都需要手动注销, 否则被观察的对象一会向那些已经注册过的观察者广播消息时, 如果观察者被内存被释放了就会引发`EXC_BAD_ACCESS ` , 所以当观察者被释放时, 要及时把观察者(observer)从被观察者(observe)身上移除.
为了解决这个问题, 可以在`CCInternalObserver`创建一个哈希表, 存放所有被观察者(observe), 并重写`CCInternalObserver`的`dealoc`方法, 移除所有观察.

# 完整的代码
　　上面已经把核心的代码细节都说完了. 完整的代码我已经做成一个Category `NSObject+CCEasyKVO.h`, 直接引入项目就可以使用了. [CCEasyKVO源码](https://github.com/cocos543/CCEasyKVO)
　　
# 推荐阅读
[更复杂的KVO解决方案](https://github.com/facebook/KVOController)
