//
//  CALayer+CCUtility.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/12.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CALayer+CCUtility.h"

@implementation CALayer (CCUtility)

+ (void)quickUpdateLayer:(nonnull dispatch_block_t)block {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    block();
    [CATransaction commit];
}

@end
