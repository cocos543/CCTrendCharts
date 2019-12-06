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

@implementation CCRendererBase (LayerCache)

- (NSMutableArray<CALayer *> *)layersCache {
    id cache = objc_getAssociatedObject(self, kLayersCache);
    if (!cache) {
        cache = @[].mutableCopy;
        objc_setAssociatedObject(self, kLayersCache, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

- (CALayer *)requestLayersCacheByIndex:(NSInteger)index layerClass:(nonnull LayerMaker)maker {
    if (index >= self.layersCache.count) {
        [self.layersCache addObject:maker()];
    }
    return self.layersCache[index];
}

- (void)removeAllLayersFromSuperLayer {
    for (CALayer *layer in self.layersCache) {
        [layer removeFromSuperlayer];
    }
}

@end
