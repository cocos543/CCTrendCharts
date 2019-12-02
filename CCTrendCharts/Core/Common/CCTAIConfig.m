//
//  CCTAIConfig.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/29.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCTAIConfig.h"

@implementation CCTAIConfigItem
@end


@implementation CCTAIConfig

- (instancetype)initWithConfig:(NSArray<CCTAIConfigItem *> *)config {
    self = [super init];
    if (self) {
        _conf = config;
    }
    
    return self;
}

@end
