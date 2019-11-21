//
//  CCMacro.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/20.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CGContextIndependent(ctx, code) \
CGContextSaveGState(ctx); \
code \
CGContextRestoreGState(ctx); \

#ifdef DEBUG
#define NSLog(format, ...) printf("\n[%s] %s [%d] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif

#define CC_X_INIT_TRANSLATION 1

// K线图实体绘制部分 占 轴距离的百分比
#define CC_KLINE_ENTITY_DISTANCE_PERCENT 0.7
