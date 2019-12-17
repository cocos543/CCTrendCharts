//
//  AssembledViewController.m
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/13.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "AssembledViewController.h"

@interface AssembledViewController ()

@end

@implementation AssembledViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    // 这里演示如何配置多个不同的视图, 让他们能同步手势操作. (注意数据长度必须相同, 不然同步就没有意义了.)
    [self configKlineView];
    [self configVolumeView];
    [self configLineView];

    [self configAssmbleView];
}

- (void)viewDidAppear:(BOOL)animated {
    self.scrollView.frame = CGRectMake(0, 8, self.contentView.frame.size.width, self.contentView.frame.size.height - 8);
}

- (void)viewDidLayoutSubviews {
    self.scrollView.contentSize   = self.assembleView.bounds.size;
    self.scrollView.scrollEnabled = YES;
}

- (IBAction)segemntAction:(UISegmentedControl *)sender {
    NSMutableArray *arr   = @[self.klineView, self.volumeView, self.lineView].mutableCopy;

    NSMutableArray *views = @[arr[sender.selectedSegmentIndex]].mutableCopy;
    for (int i = 0; i < arr.count; i++) {
        if (i == sender.selectedSegmentIndex) {
            continue;
        }
        [views addObject:arr[i]];
    }

    [self.assembleView removeFromSuperview];
    self.assembleView = [[CCAssembledChartView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 10, 0)];
    [self.scrollView addSubview:self.assembleView];

    [self.assembleView configChartViews:views];

    [self.assembleView setNeedsPrepareChart];
}

- (void)configAssmbleView {
    // 利用组合视图实现多视图关联
    CCAssembledChartView *assView = [[CCAssembledChartView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 10, 0)];
    self.assembleView = assView;
    [assView configChartViews:@[self.klineView, self.volumeView, self.lineView]];

    self.scrollView   = [[UIScrollView alloc] init];
    [self.scrollView addSubview:self.assembleView];
    [self.contentView addSubview:self.scrollView];
}

- (void)configKlineView {
    // 配置K线图
    CCKLineChartView *view = [[CCKLineChartView alloc] initWithFrame:CGRectMake(0, 0, 0, 250)];
    self.klineView                         = view;

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
    tai2.label        = @"MA10";
    tai2.color        = [UIColor stringToColor:@"#5786d2" opacity:1];
    tai2.font         = [UIFont systemFontOfSize:10];
    tai2.N            = @(10);
    tai2.dataSetClass = CCLineMADataSet.class;

    CCTAIConfigItem *tai3 = [[CCTAIConfigItem alloc] init];
    tai3.label        = @"MA20";
    tai3.color        = [UIColor stringToColor:@"#cb2fa6" opacity:1];
    tai3.font         = [UIFont systemFontOfSize:10];
    tai3.N            = @(20);
    tai3.dataSetClass = CCLineMADataSet.class;

    self.taiItems     = @[tai, tai2, tai3];

    CCTAIConfig *conf = [[CCTAIConfig alloc] initWithConfig:self.taiItems];
    // 为视图配置技术指标
    [view setTAIConfig:conf];
}

- (void)configVolumeView {
    // 配置数据视图以及轴信息
    CCVolumeChartView *view = [[CCVolumeChartView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    self.volumeView                        = view;

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
    tai2.label        = @"MA10";
    tai2.color        = [UIColor stringToColor:@"#5786d2" opacity:1];
    tai2.font         = [UIFont systemFontOfSize:10];
    tai2.N            = @(10);
    tai2.dataSetClass = CCLineMADataSet.class;

    CCTAIConfigItem *tai3 = [[CCTAIConfigItem alloc] init];
    tai3.label        = @"MA20";
    tai3.color        = [UIColor stringToColor:@"#cb2fa6" opacity:1];
    tai3.font         = [UIFont systemFontOfSize:10];
    tai3.N            = @(20);
    tai3.dataSetClass = CCLineMADataSet.class;

    self.taiItems     = @[tai, tai2, tai3];

    CCTAIConfig *conf = [[CCTAIConfig alloc] initWithConfig:self.taiItems];
    // 为视图配置技术指标
    [view setTAIConfig:conf];
}

- (void)configLineView {
    // 配置折线图
    CCLineChartView *lineView = [[CCLineChartView alloc] initWithFrame:CGRectMake(0, 0, 0, 250)];
    self.lineView                   = lineView;
    lineView.clipEdgeInsets         = UIEdgeInsetsMake(24, 24, 5, 24);
    lineView.dataSource             = self;
    lineView.delegate               = self;
    lineView.backgroundColor        = [UIColor stringToColor:@"#1a1a1a" opacity:1];

    lineView.leftAxis               = [self.klineView.leftAxis copy];
    lineView.rightAxis              = [self.klineView.rightAxis copy];
    lineView.xAxis                  = [self.klineView.xAxis copy];

    [lineView setNeedsPrepareChart];
}

- (void)loadDataWithStokeCode:(NSString *)code time:(NSInteger)time {
    NSString *url = [NSString stringWithFormat:@"https://stock.xueqiu.com/v5/stock/chart/kline.json?symbol=%@&begin=%@&period=day&type=before&count=-120&indicator=kline,pe,pb", code, @(time)];

    [[NetworkHelper.share.session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (!jsonDic) {
            return;
        }

        NSArray *items        = jsonDic[@"data"][@"item"];

        items = [[items reverseObjectEnumerator] allObjects];
        if (!self.chartDataArr) {
            self.chartDataArr = items;
        } else {
            self.chartDataArr = [self.chartDataArr arrayByAddingObjectsFromArray:items];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
                           [self.assembleView setNeedsPrepareChart];
                       });

        // 这里延迟执行代码, 是为了避免当网络响应太快时, UI还在尝试调用newEventWithBlock, 这样token标记为yes的话, 会导致事件多次触发.(后续可能会优化一下)
        [self.eventManager doneDelay:1];
    }] resume];
}

- (NSString *)getXAxisLabelFormat {
    return @"yyyy-MM-dd";
}

#pragma mark - CCChartViewDataSource
// 下面代码演示如何构建数据
- (CCChartData *)chartDataInView:(CCChartViewBase *)chartView {
    NSArray *items             = self.chartDataArr;

    // 根据数据信息构建x轴, x轴文案间距支持自动调整
    NSMutableArray *xVals      = @[].mutableCopy;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    formatter.dateFormat = [self getXAxisLabelFormat];

    NSMutableArray *entities   = @[].mutableCopy;

    self.minTime         = NSIntegerMax;
    for (int i = 0; i < items.count; i++) {
        //"timestamp","volume","open","high","low","close","chg","percent","turnoverrate","amount"
        CCChartDataEntity *e;
        if (chartView == self.lineView) {
            e = [[CCChartDataEntity alloc] initWithValue:[items[i][5] doubleValue] xIndex:i data:nil];
        } else {
            CCKLineDataEntity *entity = [[CCKLineDataEntity alloc] initWithValue:0 xIndex:i data:nil];
            if (chartView == self.volumeView) {
                entity = [[CCVolumeDataEntity alloc] initWithValue:0 xIndex:i data:nil];
            }
            entity.timeInt      = [items[i][0] integerValue] / 1000;
            entity.volume       = [items[i][1] integerValue];
            entity.opening      = [items[i][2] doubleValue];
            entity.highest      = [items[i][3] doubleValue];
            entity.lowest       = [items[i][4] doubleValue];
            entity.closing      = [items[i][5] doubleValue];
            entity.changing     = [items[i][6] doubleValue];
            entity.percent      = [items[i][7] doubleValue];
            entity.turnoverrate = [items[i][8] doubleValue];
            entity.amount       = [items[i][9] doubleValue];
            e = entity;
        }

        [entities addObject:e];
        [xVals addObject:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:e.timeInt]]];

        if (self.minTime > e.timeInt) {
            self.minTime = e.timeInt;
        }
    }

    CCChartData *chartData;
    if (chartView == self.klineView) {
        CCKLineChartDataSet *dataSet = [[CCKLineChartDataSet alloc] initWithVals:entities withName:nil];
        chartData = [[CCKLineChartData alloc] initWithXVals:xVals dataSets:@[dataSet]];
    } else if (chartView == self.volumeView) {
        CCVolumeChartDataSet *dataSet = [[CCVolumeChartDataSet alloc] initWithVals:entities withName:nil];
        // 交易量数据集可以直接关联到CCKLineChartData中.
        chartData = [[CCKLineChartData alloc] initWithXVals:xVals dataSets:@[dataSet]];
    } else if (chartView == self.lineView) {
        CCLineChartDataSet *dataSet = [[CCLineChartDataSet alloc] initWithVals:entities withName:nil];
        chartData = [[CCChartData alloc] initWithXVals:xVals dataSets:@[dataSet]];
    }

    // 创建数据整体: x轴信息 + 包含y信息的数据集数组

    return chartData;
}

#pragma CCChartViewDelegate
// 下面代码演示如何响应框架请求, 加载下一页数据
- (void)chartViewExpectLoadNextPage:(CCChartViewBase *)view eventManager:(CCSingleEventManager *)eventManager {
    NSLog(@"%@", view);
    // 记录好本次事件的管理器
    self.eventManager = eventManager;
    // 加载下一个时间点的数据, 当前演示的是日K线, 所以时间为下一日
    NSInteger time = self.minTime - (60 * 60 * 24);
    [self loadDataWithStokeCode:self.codeTextField.text time:time * 1000];
}

@end
