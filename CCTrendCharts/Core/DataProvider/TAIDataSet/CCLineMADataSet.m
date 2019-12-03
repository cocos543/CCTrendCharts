//
//  CCLineMADataSet.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/29.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCLineMADataSet.h"

@implementation CCLineMADataSet
@synthesize label         = _label;
@synthesize N             = _N;
@synthesize font          = _font;
@synthesize rightInterval = _rightInterval;
@synthesize formatter     = _formatter;

- (instancetype)initWithRawEntities:(NSArray<CCKLineDataEntity *> *)rawEntities N:(id)N {
    id e = [CCLineMADataSet rawEntitiesToEntities:rawEntities N:N];

    self = [super initWithVals:e withName:kCCNameLineDataSet];
    if (self) {
        _N    = N;
        _font = [UIFont systemFontOfSize:10];
        _rightInterval = 8;
        _formatter = [[NSNumberFormatter alloc] init];
        _formatter.minimumFractionDigits = 2;
        _formatter.maximumFractionDigits = 2;
    }
    return self;
}

#pragma mark - CCProtocolTAIDataSet

- (void)calcIndicatorUseAppending:(NSArray<CCKLineDataEntity *> *)rawEntities {
    // 该方法暂时无效, 一旦数据更新了, 指数都是重新计算的, 暂时没有发现性能问题, 所以改方法暂时为空
}

+ (NSArray<id<CCProtocolChartDataEntityBase> > *)rawEntitiesToEntities:(NSArray<CCKLineDataEntity *> *)rawEntities N:(id)N {
    // 根据当前的N值, 计算出均线信息
    NSInteger n         = [N intValue];
    if (n == 0) {
        return nil;
    }

    NSMutableArray *ret = @[].mutableCopy;
    // 当前计算的位置
    NSInteger loc       = 0;
    for (NSInteger i = loc; i <= rawEntities.count - n; i++) {
        CGFloat sum = 0;

        for (NSInteger j = i; j < i + n; j++) {
            sum += rawEntities[j].closing;
        }

        CCChartDataEntity *e = [[CCChartDataEntity alloc] initWithValue:sum / n xIndex:rawEntities[loc].xIndex data:nil];
        e.timeInt = rawEntities[loc].timeInt;
        [ret addObject:e];
        loc++;
    }

    return ret;
}

@end
