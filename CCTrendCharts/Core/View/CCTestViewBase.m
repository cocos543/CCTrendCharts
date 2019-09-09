//
//  CCTestViewBase.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCTestViewBase.h"
#import "CCDefualtYAxis.h"
#import "CCDefualtXAxis.h"

@interface CCTestViewBase ()

@end

@implementation CCTestViewBase

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 这里使用父类提供的方法初始化
        self.yAxis = [[CCDefualtYAxis alloc] init];
        self.xAxis = [[CCDefualtXAxis alloc] init];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (NSString *)description {
    return [super description];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
