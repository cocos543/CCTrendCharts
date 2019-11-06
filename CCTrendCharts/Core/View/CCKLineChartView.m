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
@synthesize leftAxisRenderer = _leftAxisRenderer;
@synthesize rightAxisRenderer = _rightAxisRenderer;
@synthesize xAxisRenderer = _xAxisRenderer;
@synthesize cursorRenderer = _cursorRenderer;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.leftAxis = [[CCDefaultYAxis alloc] initWithDependency:CCYAsixDependencyLeft];
        self.rightAxis = [[CCDefaultYAxis alloc] initWithDependency:CCYAsixDependencyRight];
        
        self.xAxis = [[CCDefaultXAxis alloc] init];
        self.cursor = [[CCDefaultCursor alloc] init];
        
        
        
        _leftAxisRenderer = [[CCDefaultYAxisRenderer alloc] initWithAxis:self.leftAxis viewHandler:self.viewPixelHandler transform:self.transformer];
        
        _rightAxisRenderer = [[CCDefaultYAxisRenderer alloc] initWithAxis:self.rightAxis viewHandler:self.viewPixelHandler transform:self.transformer];
        
        _xAxisRenderer = [[CCDefaultXAxisRenderer alloc] initWithAxis:self.xAxis viewHandler:self.viewPixelHandler transform:self.transformer];
        
        _cursorRenderer = [[CCDefaultCursorRenderer alloc] initWithCursor:self.cursor viewHandler:self.viewPixelHandler transform:self.transformer DataProvider:self];
        _cursorRenderer.leftAxis = self.leftAxis;
        _cursorRenderer.rightAxis = self.rightAxis;
        _cursorRenderer.xAxis = self.xAxis;
        
        
        [self addDefualtGesture];
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

- (void)setData:(CCChartData *)data {
    [super setData:data];
    
    // 变更数据集需要重置viewHandle里的初始矩阵
    if (self.recentFirst) {
        
    }
}

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
