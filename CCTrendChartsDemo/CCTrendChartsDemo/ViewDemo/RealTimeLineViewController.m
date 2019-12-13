//
//  RealTimeLineViewController.m
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "RealTimeLineViewController.h"

@interface RealTimeLineViewController () <CCChartViewDataSource, CCChartViewDelegate>

@property (nonatomic, strong) CCLineChartView *chartView;

@property (nonatomic, assign) NSTimeInterval lastTime;

@end

@implementation RealTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // 配置数据视图以及轴信息
    CCLineChartView *view = [[CCLineChartView alloc] initWithFrame:CGRectMake(5, 8, SCREEN_WIDTH - 10, 250)];
    [self.contentView addSubview:view];
    self.chartView                       = view;

    // 无需开启"最近优先", 数据将从左往右渲染
    view.recentFirst                     = NO;
    view.dataSource                      = self;
    view.delegate                        = self;
    view.sync_panGesutreEnable           = NO;
    view.sync_pinchGesutreEnable         = NO;
    view.backgroundColor                 = [UIColor stringToColor:@"#1a1a1a" opacity:1];

    // 设置趋势图的边缘大小, 趋势图的尺寸减去边缘大小, 就是渲染区域的大小
    view.clipEdgeInsets                  = UIEdgeInsetsMake(24, 24, 5, 24);

    // 下面是针对x, y轴信息的配置, 不懂得可以自己修改后运行一下看看效果就懂了.
    view.leftAxis.labelCount             = 5;
    view.leftAxis.labelPosition          = CCYAxisLabelPositionInside;
    view.leftAxis.yLabelOffset           = -5;
    view.leftAxis.labelColor             = [UIColor stringToColor:@"#585858" opacity:1];

    view.rightAxis.labelColor            = [UIColor stringToColor:@"#585858" opacity:1];
    view.rightAxis.labelCount            = 4;
    view.rightAxis.yLabelOffset          = -5;
    view.rightAxis.gridLineEnabled       = NO;
    // 演示一下如何手动设置Y轴文案 (其实后面手动设置最大最小值的时候, customValue也会被设置成YES)
    view.rightAxis.customValue           = YES;
    view.rightAxis.labelCount            = 8;
    view.rightAxis.formatter             = [[NSNumberFormatter alloc] init];
    view.rightAxis.formatter.numberStyle = NSNumberFormatterPercentStyle;
    view.rightAxis.formatter.maximumFractionDigits = 2;
    view.rightAxis.formatter.minimumFractionDigits = 2;

    // 下面代码可以自定义X轴的文案格式化器, 默认格式化器就是直接把数据源的数据展示出来
    // view.xAxis.formatter = [[CCXAxisFixedFormatter alloc] init];
    view.xAxis.formatter.modulusStartIndex         = 0;
    view.xAxis.yLabelOffset = 0;
    view.xAxis.axisColor    = [UIColor clearColor];
    view.xAxis.labelColor   = [UIColor stringToColor:@"#585858" opacity:1];
    // 这里的分时图在一个界面上完整显示, 可以实现设置总数量, A股目前交易时间每天是4个小时 (共242个点, 每分钟1个)
    view.xAxis.totalCount   = 242;
    view.xAxis.startMargin  = 0;
    view.xAxis.endMargin    = 0;

    view.cursor.labelColor  = [UIColor stringToColor:@"#c8c6c2" opacity:1];
    [view setNeedsPrepareChart];
}

- (void)loadDataWithStokeCode:(NSString *)code time:(NSInteger)time {
    NSString *url = [NSString stringWithFormat:@"https://stock.xueqiu.com/v5/stock/chart/minute.json?symbol=%@&period=1d", code];

    [[NetworkHelper.share.session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (!jsonDic) {
            return;
        }

        NSArray *items        = jsonDic[@"data"][@"items"];
        self.chartDataArr = items;

        dispatch_async(dispatch_get_main_queue(), ^{
                           [self.chartView setNeedsPrepareChart];
                       });

        // 这里延迟执行代码, 是为了避免当网络响应太快时, UI还在尝试调用newEventWithBlock, 这样token标记为yes的话, 会导致事件多次触发.(后续可能会优化一下)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           // 标记事件完成
                           [self.eventManager done];
                       });
    }] resume];
}

- (id<CCProtocolChartDataSet>)getDataSetFrom:(NSArray *)entities {
    return [[CCLineChartDataSet alloc] initWithVals:entities withName:kCCNameLineDataSet];
}

- (id<CCProtocolChartDataEntityBase>)getEntityWith:(NSInteger)xIndex {
    // 分时图可以采用K线实体, 毕竟数据信息比较多方便绘制
    return [[CCKLineDataEntity alloc] initWithValue:0 xIndex:xIndex data:nil];
}

#pragma mark - CCChartViewDataSource
// 下面代码演示如何构建数据
- (CCChartData *)chartDataInView:(CCChartViewBase *)chartView {
    // 这里数据按照时间从小到达排序好了.
    NSArray *items             = self.chartDataArr;

    // 根据数据信息构建x轴, x轴文案间距支持自动调整
    NSMutableArray *xVals      = @[].mutableCopy;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    formatter.dateFormat = @"HH:mm";

    NSMutableArray<CCKLineDataEntity *> *entities = @[].mutableCopy;

    for (int i = 0; i < items.count; i++) {
        CCKLineDataEntity *entity = [self getEntityWith:i];

        entity.timeInt  = [items[i][@"timestamp"] integerValue] / 1000;
        entity.volume   = [items[i][@"volume"] integerValue];
        // 雪球没提供开盘价, 这里也用不上, 所以把当前价设置上去就可以了
        entity.opening  = [items[i][@"current"] doubleValue];
        entity.closing  = [items[i][@"current"] doubleValue];
        entity.changing = [items[i][@"chg"] doubleValue];
        entity.percent  = [items[i][@"percent"] doubleValue] / 100;
        entity.amount   = [items[i][@"amount"] doubleValue];
        // 最后3分钟是集合竞价, 没有最高最低价
        if (i <= items.count - 4 && i == items.count - 1) {
            entity.highest = [items[i][@"high"] doubleValue];
            entity.lowest  = [items[i][@"low"] doubleValue];
        } else {
            entity.highest = entities.lastObject.highest;
            entity.lowest  = entities.lastObject.lowest;
        }

        [entities addObject:entity];
        [xVals addObject:[formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:entity.timeInt]]];
    }

    self.lastTime     =  entities.lastObject.timeInt;

    CCLineChartDataSet *dataSet = [self getDataSetFrom:entities];
    dataSet.color     = [UIColor stringToColor:@"#5592ef" opacity:1];
    dataSet.fillColor = [UIColor stringToColor:@"#1e2633" opacity:0.6];
    dataSet.lineWidth = 1;
    dataSet.lineCap   = kCALineCapRound;

    // 创建数据整体: x轴信息 + 包含y信息的数据集数组
    CCKLineChartData *chartData = [[CCKLineChartData alloc] initWithXVals:xVals dataSets:@[dataSet]];

    // 这里需要手动计算出右轴涨跌幅的最大最小值, 计算原理就是先得到左y轴的最大最小值, 然后查看数据实体里面对应价格和涨跌幅, 再推算出
    
    // 先得到左轴信息
    [self.chartView.leftAxis calculateMinMax:chartData];
    CGFloat leftMin = self.chartView.leftAxis.axisMinValue;
    CGFloat leftMax = self.chartView.leftAxis.axisMaxValue;
    
    if (entities.count) {
        // 再随便找一个数据实体, 计算出前平价价格多少, 然后就可以轻松算出涨跌幅了
        CGFloat originalVal = entities[0].opening - entities[0].changing;
        
        // 然后就可以计算出leftMin, leftMax对应的涨跌幅是多少了.
        self.chartView.rightAxis.axisMinValue = (leftMin - originalVal) / originalVal;
        self.chartView.rightAxis.axisMaxValue = (leftMax - originalVal) / originalVal;
    }

    return chartData;
}

#pragma CCChartViewDelegate
// 这里演示的分时图只有一页, 所以下面也不需要加载新数据了
- (void)chartViewExpectLoadNextPage:(CCChartViewBase *)view eventManager:(CCSingleEventManager *)eventManager {
}

@end
