//
//  KLineViewController.m
//  CCTrendChartsDemo
//
//  该Demo演示的是日K线图, 而且只有单独的蜡烛图, 不包括交易量柱型图.
//
//  Created by Cocos on 2019/12/10.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "KLineViewController.h"

@interface KLineViewController ()

@end

@implementation KLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 配置数据视图以及轴信息
    CCKLineChartView *view = [[CCKLineChartView alloc] initWithFrame:CGRectMake(5, 8, SCREEN_WIDTH - 10, 250)];
    view.indicatorStyle                    = UIScrollViewIndicatorStyleWhite;
    [self.contentView addSubview:view];
    self.chartView                         = view;

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

- (void)clickBtnAction:(id)sender {
    // 重置一下视图手势状态
    [self.chartView resetViewGesture];

    [super clickBtnAction:sender];
}

- (IBAction)segemntAction:(UISegmentedControl *)sender {
    NSString *text        = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    CCTAIConfigItem *item = self.taiItems[sender.tag];
    item.label = text;
    item.N     = @([text substringFromIndex:2].integerValue);
    [self.chartView setNeedsPrepareChart];
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
                           [self.chartView setNeedsPrepareChart];
                       });

        // 这里延迟执行代码, 是为了避免当网络响应太快时, UI还在尝试调用newEventWithBlock, 这样token标记为yes的话, 会导致事件多次触发.(后续可能会优化一下)
        [self.eventManager doneDelay:1];
    }] resume];
}

- (id<CCProtocolChartDataSet>)getDataSetFrom:(NSArray *)entities {
    return [[CCKLineChartDataSet alloc] initWithVals:entities withName:kCCNameKLineDataSet];
}

- (id<CCProtocolChartDataEntityBase>)getEntityWith:(NSInteger)xIndex {
    return [[CCKLineDataEntity alloc] initWithValue:0 xIndex:xIndex data:nil];
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
        CCKLineDataEntity *entity = [self getEntityWith:i];
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

        [entities addObject:entity];
        [xVals addObject:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:entity.timeInt]]];

        if (self.minTime > entity.timeInt) {
            self.minTime = entity.timeInt;
        }
    }

    CCKLineChartDataSet *dataSet = [self getDataSetFrom:entities];

    // 创建数据整体: x轴信息 + 包含y信息的数据集数组
    CCKLineChartData *chartData  = [[CCKLineChartData alloc] initWithXVals:xVals dataSets:@[dataSet]];

    return chartData;
}

#pragma CCChartViewDelegate
// 下面代码演示如何响应框架请求, 加载下一页数据
- (void)chartViewExpectLoadNextPage:(CCChartViewBase *)view eventManager:(CCSingleEventManager *)eventManager {
    // 记录好本次事件的管理器
    self.eventManager = eventManager;
    // 加载下一个时间点的数据, 当前演示的是日K线, 所以时间为下一日
    NSInteger time = self.minTime - (60 * 60 * 24);
    [self loadDataWithStokeCode:self.codeTextField.text time:time * 1000];
}

@end
