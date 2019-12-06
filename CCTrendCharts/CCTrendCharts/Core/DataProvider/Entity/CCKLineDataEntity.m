//
//  CCKLineDataEntity.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCKLineDataEntity.h"

@implementation CCKLineDataEntity
- (instancetype)init {
    self = [super init];
    if (self) {
        _changing = 0;
        _amount   = 0;
        _volume   = 0;
    }
    
    return self;
}

- (CCKLineDataEntityState)entityState {
    if (self.opening > self.closing) {
        return CCKLineDataEntityStateFalling;
    } else if (self.opening < self.closing) {
        return CCKLineDataEntityStateRising;
    } else {
        if (self.changing > 0) {
            return CCKLineDataEntityStateRising;
        } else if (self.changing < 0) {
            return CCKLineDataEntityStateFalling;
        } else {
            // 这里主要是考虑到股票交易有收盘, 所以开盘价等于收盘价并不代表changing就是0.
            return CCKLineDataEntityStateNone;
        }
    }
}

- (CGFloat)value {
    return self.closing;
}

- (NSString *)description {
    NSString *str = [super description];
    return [NSString stringWithFormat:@"%@\nhighest=%f\nlowest=%f\nopening=%f\nclosing=%f\nvolume=%f\namount=%f\nturnoverrate=%f\nchanging=%f", str, self.highest, self.lowest, self.opening, self.closing, self.volume, self.amount, self.turnoverrate, self.changing];
}

@end
