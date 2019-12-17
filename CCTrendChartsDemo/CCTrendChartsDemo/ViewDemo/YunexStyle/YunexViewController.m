//
//  YunexViewController.m
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "YunexViewController.h"
#import "YunexCursorRenderer.h"

@interface YunexViewController ()

@end

@implementation YunexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self configKlineView];
    [self configVolumeView];

    [self configAssmbleView];
}

- (NSString *)getXAxisLabelFormat {
    return @"MM-dd HH:mm";
}

- (void)configAssmbleView {
    // 利用组合视图实现多视图关联
    CCAssembledChartView *assView = [[CCAssembledChartView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 10, 0)];
    self.assembleView = assView;
    [assView configChartViews:@[self.klineView, self.volumeView]];

    self.scrollView   = [[UIScrollView alloc] init];
    [self.scrollView addSubview:self.assembleView];
    [self.contentView addSubview:self.scrollView];
}

- (void)configKlineView {
    // 配置K线图
    CCKLineChartView *view = [[CCKLineChartView alloc] initWithFrame:CGRectMake(0, 0, 0, 250)];
    view.backgroundColor                   = UIColor.whiteColor;
    view.showsHorizontalScrollIndicator    = NO;
    self.klineView                         = view;

    // 开启"最近优先", 数据将从右往左渲染
    view.recentFirst                       = YES;
    view.dataSource                        = self;
    view.delegate                          = self;
    view.backgroundColor                   = [UIColor stringToColor:@"#131D24" opacity:1];

    // 把标记渲染器直接移除掉
    view.markerRenderer                    = nil;
    
    // 把指示器渲染器换成自定义的
    view.cursorRenderer = [[YunexCursorRenderer alloc] initWithDefaultCursorRenderer:view.cursorRenderer];

    // 设置趋势图的边缘大小, 趋势图的尺寸减去边缘大小, 就是渲染区域的大小
    view.clipEdgeInsets                    = UIEdgeInsetsMake(24, 0, 5, 0);

    // 下面是针对x, y轴信息的配置, 不懂得可以自己修改后运行一下看看效果就懂了.
    view.leftAxis.axisLineDisabled         = YES;
    view.leftAxis.labelDisable             = YES;
    view.leftAxis.labelCount               = 0;
    view.leftAxis.labelPosition            = CCYAxisLabelPositionInside;
    view.leftAxis.yLabelOffset             = -5;
    view.leftAxis.labelColor               = [UIColor stringToColor:@"#585858" opacity:1];
    view.leftAxis.gridLineEnabled          = NO;

    view.rightAxis.axisLineDisabled        = YES;
    view.rightAxis.labelDisable            = YES;
    view.rightAxis.labelColor              = [UIColor stringToColor:@"#585858" opacity:1];
    view.rightAxis.labelCount              = 0;
    view.rightAxis.yLabelOffset            = -5;
    view.rightAxis.gridLineEnabled         = NO;

    // 下面代码可以自定义X轴的文案格式化器, 默认格式化器就是直接把数据源的数据展示出来
    view.xAxis.axisLineDisabled            = YES;
    view.xAxis.formatter.modulusStartIndex = 0;
    view.xAxis.yLabelOffset                = 0;
    view.xAxis.axisColor                   = [UIColor clearColor];
    view.xAxis.labelColor                  = [UIColor stringToColor:@"#ADB3BC" opacity:1];
    view.xAxis.gridLineEnabled             = NO;

    view.cursor.labelColor                 = UIColor.whiteColor;

    // 如果需要为趋势图配置指标的话, 按照下面代码配置即可, 需要多个就配置多个.
    CCTAIConfigItem *tai = [[CCTAIConfigItem alloc] init];
    tai.label         = @"MA7";
    tai.color         = [UIColor stringToColor:@"#FAF2A9" opacity:1];
    tai.font          = [UIFont systemFontOfSize:10];
    tai.N             = @(5);
    tai.dataSetClass  = CCLineMADataSet.class;

    CCTAIConfigItem *tai2 = [[CCTAIConfigItem alloc] init];
    tai2.label        = @"MA25";
    tai2.color        = [UIColor stringToColor:@"#86C8E9" opacity:1];
    tai2.font         = [UIFont systemFontOfSize:10];
    tai2.N            = @(10);
    tai2.dataSetClass = CCLineMADataSet.class;

    self.taiItems     = @[tai, tai2];

    CCTAIConfig *conf = [[CCTAIConfig alloc] initWithConfig:self.taiItems];
    // 为视图配置技术指标
    [view setTAIConfig:conf];
}

- (void)configVolumeView {
    // 配置数据视图以及轴信息
    CCVolumeChartView *view = [[CCVolumeChartView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    view.showsHorizontalScrollIndicator = NO;
    self.volumeView         = view;
    
    view.cursorRenderer = [[YunexCursorRenderer alloc] initWithDefaultCursorRenderer:view.cursorRenderer];

    // 开启"最近优先", 数据将从右往左渲染
    view.recentFirst        = YES;
    view.dataSource         = self;
    view.delegate           = self;
    view.backgroundColor    = [UIColor stringToColor:@"#131D24" opacity:1];

    // 设置趋势图的边缘大小, 趋势图的尺寸减去边缘大小, 就是渲染区域的大小
    view.clipEdgeInsets     = UIEdgeInsetsMake(24, 0, 5, 0);

    // 下面是针对x, y轴信息的配置, 不懂得可以自己修改后运行一下看看效果就懂了.
    view.leftAxis           = [self.klineView.leftAxis copy];
    view.rightAxis          = [self.klineView.rightAxis copy];
    view.xAxis = [self.klineView.xAxis copy];
    view.xAxis.labelDisable = YES;

    view.cursor.labelColor  = UIColor.whiteColor;
    // 这里交易量图不需要x轴游标文案
    view.cursorRenderer.xAxis = nil;
}

@end
