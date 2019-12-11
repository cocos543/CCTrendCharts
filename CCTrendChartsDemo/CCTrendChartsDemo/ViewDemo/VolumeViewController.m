//
//  VolumeViewController.m
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "VolumeViewController.h"

@import CCTrendCharts;

@interface VolumeViewController ()

@end

@implementation VolumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 配置数据视图以及轴信息
    CCVolumeChartView *view = [[CCVolumeChartView alloc] initWithFrame:CGRectMake(5, 8, SCREEN_WIDTH - 10, 250)];
    [self.contentView addSubview:view];
    self.chartView                    = view;

    // 开启"最近优先", 数据将从右往左渲染
    view.recentFirst                       = YES;
    view.dataSource                        = self;
    view.delegate                          = self;
    view.backgroundColor                   = [UIColor stringToColor:@"#1a1a1a" opacity:1];

    // 设置趋势图的边缘大小, 趋势图的尺寸减去边缘大小, 就是渲染区域的大小
    view.clipEdgeInsets                    = UIEdgeInsetsMake(24, 24, 5, 24);

    // 下面是针对x, y轴信息的配置, 不懂得可以自己修改后运行一下看看效果就懂了.
    view.leftAxis.labelCount               = 5;
    view.leftAxis.labelPosition            = CCYAxisLabelPositionInside;
    view.leftAxis.yLabelOffset             = -5;
    view.leftAxis.labelColor               = [UIColor stringToColor:@"#585858" opacity:1];

    view.rightAxis.labelColor              = [UIColor stringToColor:@"#585858" opacity:1];
    view.rightAxis.labelCount              = 4;
    view.rightAxis.yLabelOffset            = -5;
    view.rightAxis.gridLineEnabled         = NO;

    // 下面代码可以自定义X轴的文案格式化器, 默认格式化器就是直接把数据源的数据展示出来
    //view.xAxis.formatter = [[CCXAxisFixedFormatter alloc] init];
    view.xAxis.formatter.modulusStartIndex = 0;
    view.xAxis.yLabelOffset                = 0;
    view.xAxis.axisColor                   = [UIColor clearColor];
    view.xAxis.labelColor                  = [UIColor stringToColor:@"#585858" opacity:1];

    view.cursor.labelColor                 = [UIColor stringToColor:@"#c8c6c2" opacity:1];
    [view setNeedsPrepareChart];

    // 如果需要为趋势图配置指标的话, 按照下面代码配置即可, 需要多个就配置多个.
    CCTAIConfigItem *tai = [[CCTAIConfigItem alloc] init];
    tai.label         = @"MA05";
    tai.color         = [UIColor stringToColor:@"#f1983a" opacity:1];
    tai.font          = [UIFont systemFontOfSize:10];
    tai.N             = @(5);
    tai.dataSetClass  = CCLineMADataSet.class;

    CCTAIConfigItem *tai2 = [[CCTAIConfigItem alloc] init];
    tai2.label        = @"MA30";
    tai2.color        = [UIColor stringToColor:@"#5786d2" opacity:1];
    tai2.font         = [UIFont systemFontOfSize:10];
    tai2.N            = @(30);
    tai2.dataSetClass = CCLineMADataSet.class;

    CCTAIConfigItem *tai3 = [[CCTAIConfigItem alloc] init];
    tai3.label        = @"MA55";
    tai3.color        = [UIColor stringToColor:@"#cb2fa6" opacity:1];
    tai3.font         = [UIFont systemFontOfSize:10];
    tai3.N            = @(55);
    tai3.dataSetClass = CCLineMADataSet.class;

    self.taiItems     = @[tai, tai2, tai3];
    
    CCTAIConfig *conf = [[CCTAIConfig alloc] initWithConfig:self.taiItems];
    // 为视图配置技术指标
    [view setTAIConfig:conf];
}

- (id<CCProtocolChartDataSet>)getDataSetFrom:(NSArray *)entities {
    return [[CCVolumeChartDataSet alloc] initWithVals:entities withName:kCCVolumeChartDataSet];
}

- (id<CCProtocolChartDataEntityBase>)getEntityWith:(NSInteger)xIndex {
    return [[CCVolumeDataEntity alloc] initWithValue:0 xIndex:xIndex data:nil];
}

@end
