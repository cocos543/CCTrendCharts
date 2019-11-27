//
//  CCLineChartView.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/22.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCLineChartView.h"

@interface CCLineChartView()
/**
 数据图层
 */
@property (nonatomic, strong) CALayer *dataLayer;

@end

@implementation CCLineChartView
@synthesize dataRenderer = _dataRenderer;
@synthesize leftAxisRenderer = _leftAxisRenderer;
@synthesize rightAxisRenderer = _rightAxisRenderer;
@synthesize xAxisRenderer = _xAxisRenderer;
@synthesize cursorRenderer = _cursorRenderer;
@synthesize markerRenderer = _markerRenderer;

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
        
        _markerRenderer = [[CCDefaultMarkerRenderer alloc] initWithViewHandler:self.viewPixelHandler transform:self.transformer DataProvider:self];
        
        _dataRenderer = [[CCLineDataChartRenderer alloc] initWithViewHandler:self.viewPixelHandler transform:self.transformer DataProvider:self];
        
        
        [self addDefualtGesture];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.dataLayer.frame  = frame;
}

/// 数据渲染
- (void)dataRendering {
    [self.dataRenderer renderData:self.dataLayer];
}

#pragma mark - Getter & Setter
- (CALayer *)dataLayer {
    if (!_dataLayer) {
        _dataLayer = CALayer.layer;
        
        [self.layer addSublayer:_dataLayer];
    }

    return _dataLayer;
}

@end
