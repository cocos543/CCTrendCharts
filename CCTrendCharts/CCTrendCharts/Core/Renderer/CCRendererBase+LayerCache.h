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



/// 请求获取指定索引下的图层
/// @param index 索引
/// @param maker 创建实例的block, 需要时才会被调用
- (__kindof CALayer *)requestLayersCacheByIndex:(NSInteger)index layerClass:(LayerMaker)maker;

- (void)removeAllLayersFromSuperLayer;

/// 图层池, 可以动态添加新的图层
@property (nonatomic, readonly) NSMutableArray<__kindof CALayer *> *layersCache;

@end

NS_ASSUME_NONNULL_END
