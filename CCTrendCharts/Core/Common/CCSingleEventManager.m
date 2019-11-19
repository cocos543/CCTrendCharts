//
//  CCSingleEventManager.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/19.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCSingleEventManager.h"

@interface CCSingleEventManager() {
    BOOL _token;
    
    // 顺序队列, 保证_token变量的修改是线程安全的.
    dispatch_queue_t _serialQ;
}

@end

@implementation CCSingleEventManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _token = YES;
        _serialQ = dispatch_queue_create("com.cctrandcharts.serail", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)done {
    dispatch_async(_serialQ, ^{
        self->_token = YES;
    });
}

- (void)newEventWithBlock:(dispatch_block_t)eventBlock {
    // 确保所有事件都是顺序执行的
    dispatch_async(_serialQ, ^{
        if (self->_token) {
            dispatch_async(dispatch_get_main_queue(), ^{
                eventBlock();
            });
            self->_token = NO;
        }
    });
}

@end
