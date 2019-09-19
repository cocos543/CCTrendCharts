//
//  CCKLineChartView.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCKLineChartView.h"


@interface CCKLineChartView ()

@end

@implementation CCKLineChartView
@synthesize renderer = _renderer;
@synthesize yAxisrenderer = _yAxisrenderer;
@synthesize xAxisrenderer = _xAxisrenderer;
@synthesize data = _data;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 这里使用父类提供的方法初始化
        self.leftAxis = [[CCDefaultYAxis alloc] init];
        self.xAxis = [[CCDefaultXAxis alloc] init];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (NSString *)description {
    return [super description];
}

#pragma mark - Protocol: CCProtocolKLineChartDataProvider

- (CCKLineChartData *)klineChartData {
    return (CCKLineChartData *)_data;
}

- (CGFloat)chartMinX {
    return 0;
}

- (CGFloat)chartMaxX {
    return 0;
}

- (CGFloat)chartMinY {
    return 0;
}

- (CGFloat)chartMaxY {
    return 0;
}

- (NSInteger)lowestVisibleXIndex {
    return 0;
}

- (NSInteger)highestVisibleXIndex {
    return 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
