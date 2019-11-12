//
//  CALayer+CCUtility.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/12.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (CCUtility)

+ (void)quickUpdateLayer:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
