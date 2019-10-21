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
@synthesize leftAxisrenderer = _leftAxisrenderer;
@synthesize rightAxisrenderer = _rightAxisrenderer;
@synthesize xAxisrenderer = _xAxisrenderer;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.leftAxis = [[CCDefaultYAxis alloc] init];
        self.xAxis = [[CCDefaultXAxis alloc] init];
        
        _leftAxisrenderer = [[CCDefaultYAxisRenderer alloc] initWithAxis:self.leftAxis viewHandler:self.viewPixelHandler transform:self.transformer];
        
        _xAxisrenderer = [[CCDefaultXAxisRenderer alloc] initWithAxis:self.xAxis viewHandler:self.viewPixelHandler transform:self.transformer];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (NSString *)description {
    return [super description];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)prepareChart {
    [super prepareChart];    
}

#pragma mark - Getter & Setter


#pragma mark - Param update


#pragma mark - Protocol: CCProtocolKLineChartDataProvider

- (CCKLineChartData *)klineChartData {
    return (CCKLineChartData *)self.data;
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
