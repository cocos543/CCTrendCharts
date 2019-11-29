//
//  CCLineMADataSet.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/29.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCLineMADataSet.h"

@implementation CCLineMADataSet
@synthesize label = _label;

- (instancetype)initWithRawEntities:(NSArray<CCKLineDataEntity *> *)rawEntities N:(NSUInteger)N {
    id e = [CCLineMADataSet rawEntitiesToEntities:rawEntities];
    
    self = [super initWithVals:e withName:kCCNameLineDataSet];
    if (self) {
        _N = N;
    }
    return self;
}

#pragma mark - CCProtocolTAIDataSet
- (void)calcIndicatorUseAppending:(NSArray<id<CCProtocolChartDataEntityBase>> *)rawEntities {
    
}


+ (NSArray<id<CCProtocolChartDataEntityBase>> *)rawEntitiesToEntities:(NSArray<id<CCProtocolChartDataEntityBase>> *)rawEntities {
    return nil;
}

@end
