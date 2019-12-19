//
//  CCRendererBase+LayerCache.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/12/3.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCRendererBase+LayerCache.h"
#import <objc/runtime.h>

static void *kLayersCache = &kLayersCache;

#define kMaker      @"maker"
#define kLayers     @"layers"
#define kUsingCount @"usingCount"

@implementation CCRendererBase (LayerCache)

- (NSMutableDictionary *)layersCacheDic {
    id obj = objc_getAssociatedObject(self, kLayersCache);
    if (!obj) {
        obj = @{}.mutableCopy;
        objc_setAssociatedObject(self, kLayersCache, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return obj;
}

- (CALayer *)cc_requestLayersCacheWithMakerKey:(NSString *)key {
    NSMutableDictionary *val = self.layersCacheDic[key];
    CALayer *l        = nil;

    if (val) {
        NSMutableArray<CALayer *> *layers = val[kLayers];
        NSInteger count = [val[kUsingCount] integerValue];
        if (count >= layers.count) {
            [layers addObject:((LayerMaker)val[kMaker])()];
        }
        l = layers[count];
        val[kUsingCount] = @(count + 1);
    }

    return l;
}

- (void)cc_registerLayerMaker:(LayerMaker)maker forKey:(NSString *)key {
    if (!self.layersCacheDic[key]) {
        // 保存了生成器, 缓存池, 计数变量
        NSMutableDictionary *val = @{ kMaker: maker, kLayers: @[].mutableCopy, kUsingCount: @(0) }.mutableCopy;
        self.layersCacheDic[key] = val;
    } else {
        // 如果key已经存在, 则重置计数为0即可
        NSMutableDictionary *val = self.layersCacheDic[key];
        val[kUsingCount] = @(0);
    }
}

- (void)cc_releaseAllLayerBackToBufferPool {
    NSEnumerator *enumerator = [self.layersCacheDic objectEnumerator];
    NSMutableDictionary *val;
     
    while ((val = [enumerator nextObject])) {
        for (CALayer *l in val[kLayers]) {
            [l removeFromSuperlayer];
        }
        val[kUsingCount] = @(0);
    }
}

@end
