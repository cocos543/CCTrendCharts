//
//  CCRendererBase+LayerCache.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/12/3.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCRendererBase.h"

typedef __kindof CALayer *_Nonnull(^LayerMaker)(void);

NS_ASSUME_NONNULL_BEGIN


/// 提供Layer缓存池, 用于快速获取layer
@interface CCRendererBase (LayerCache)
/// 注册图层生成器
/// @param maker 图层生成器
/// @param key 标记, 用于获取图层生成器
- (void)cc_registerLayerMaker:(nonnull LayerMaker)maker forKey:(NSString *)key;

/// 请求获取缓冲池中的图层
/// @param key 指定
- (__kindof CALayer *)cc_requestLayersCacheWithMakerKey:(NSString *)key;

/// 释放所有图层, 将所有图层移出父图层, 但是不会从缓存池中删除
- (void)cc_releaseAllLayerBackToBufferPool;

@end

NS_ASSUME_NONNULL_END
