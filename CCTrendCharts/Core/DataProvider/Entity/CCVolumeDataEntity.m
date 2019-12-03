//
//  CCVolumeDataEntity.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/12/3.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCVolumeDataEntity.h"

@implementation CCVolumeDataEntity

- (instancetype)initWithKLineDataEntity:(CCKLineDataEntity *)entity {
    self = [super init];
    if (self) {
        self.highest      = entity.highest;
        self.lowest       = entity.lowest;
        self.opening      = entity.opening;
        self.closing      = entity.closing;
        self.volume       = entity.volume;
        self.amount       = entity.amount;
        self.turnoverrate = entity.turnoverrate;
        self.changing     = entity.changing;
        
        // value用不到
        self.xIndex       = entity.xIndex;
        self.timeInt      = entity.timeInt;
        self.data         = entity.data;
    }
    return self;
}

- (CGFloat)value {
    return self.volume;
}

@end
