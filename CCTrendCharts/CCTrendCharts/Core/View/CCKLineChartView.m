//
//  CCKLineChartView.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCKLineChartView.h"
#import "CCLineDataChartRenderer.h"

@interface CCKLineChartView ()
/**
 高亮图层
 */
@property (nonatomic, strong) CAShapeLayer *highlightLayer;

/**
 数据图层
 */
@property (nonatomic, strong) CALayer *dataLayer;

// 折线图渲染器, 用于渲染K线图中的指标信息
@property (nonatomic, strong) CCLineDataChartRenderer *lineRenderer;

@end

@implementation CCKLineChartView
@synthesize dataRenderer      = _dataRenderer;
@synthesize leftAxisRenderer  = _leftAxisRenderer;
@synthesize rightAxisRenderer = _rightAxisRenderer;
@synthesize xAxisRenderer     = _xAxisRenderer;
@synthesize cursorRenderer    = _cursorRenderer;
@synthesize markerRenderer    = _markerRenderer;
@synthesize legendRenderer    = _legendRenderer;

@synthesize TAIConfig         = _TAIConfig;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.leftAxis             = [[CCDefaultYAxis alloc] initWithDependency:CCYAsixDependencyLeft];
        self.rightAxis            = [[CCDefaultYAxis alloc] initWithDependency:CCYAsixDependencyRight];

        self.xAxis                = [[CCDefaultXAxis alloc] init];
        self.cursor               = [[CCDefaultCursor alloc] init];

        _leftAxisRenderer         = [[CCDefaultYAxisRenderer alloc] initWithAxis:self.leftAxis viewHandler:self.viewPixelHandler transform:self.transformer];

        _rightAxisRenderer        = [[CCDefaultYAxisRenderer alloc] initWithAxis:self.rightAxis viewHandler:self.viewPixelHandler transform:self.rightTransformer];

        _xAxisRenderer            = [[CCDefaultXAxisRenderer alloc] initWithAxis:self.xAxis viewHandler:self.viewPixelHandler transform:self.transformer];

        _cursorRenderer           = [[CCDefaultCursorRenderer alloc] initWithCursor:self.cursor viewHandler:self.viewPixelHandler transform:self.transformer DataProvider:self];
        _cursorRenderer.leftAxis  = self.leftAxis;
        _cursorRenderer.rightAxis = self.rightAxis;
        _cursorRenderer.xAxis     = self.xAxis;

        _markerRenderer           = [[CCDefaultMarkerRenderer alloc] initWithViewHandler:self.viewPixelHandler transform:self.transformer DataProvider:self];

        _legendRenderer           = [[CCTAILegendRenderer alloc] initWithViewHandler:self.viewPixelHandler transform:self.transformer DataProvider:self];

        _dataRenderer             = [[CCKLineDataChartRenderer alloc] initWithViewHandler:self.viewPixelHandler transform:self.transformer DataProvider:self];

        _lineRenderer             = [[CCLineDataChartRenderer alloc] initWithViewHandler:self.viewPixelHandler transform:self.transformer DataProvider:self];

        [self addDefualtGesture];
    }
    return self;
}

- (NSString *)description {
    return [super description];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.dataLayer.frame = frame;
}

- (void)prepareChart {
    [super prepareChart];

    // 生成指标数据集
    [self.klineChartData notifyTAIConfigChange:self.TAIConfig];
}

/// 数据渲染
- (void)dataRendering {
    // 首先渲染蜡烛图部分, 这部分全部是形状和颜色填充, 所以可以直接用CAShapeLayers类分开绘制红色和绿色
    // 蜡烛图可以是填充类型的, 也可以是描边类型, 这个具体需要在蜡烛图的数据层提供绘制样式
    [self.dataRenderer renderData:self.dataLayer];

    // 渲染指标折线图
    [self.lineRenderer renderData:self.dataLayer];
    
}

#pragma mark - Getter & Setter
- (CALayer *)dataLayer {
    if (!_dataLayer) {
        _dataLayer = CALayer.layer;

        [self.layer addSublayer:_dataLayer];
    }

    return _dataLayer;
}


#pragma mark - Protocol: CCProtocolKLineChartDataProvider
- (void)setTAIConfig:(CCTAIConfig *)TAIConfig {
    _TAIConfig = TAIConfig;
}

- (CCTAIConfig *)TAIConfig {
    return _TAIConfig;
}

- (void)setData:(CCChartData *)data {
    [super setData:data];
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
    return [super chartMinY];
}

- (CGFloat)chartMaxY {
    return [super chartMaxY];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
