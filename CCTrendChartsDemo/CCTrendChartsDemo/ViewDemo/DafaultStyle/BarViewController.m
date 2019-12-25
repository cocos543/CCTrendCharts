//
//  BarViewController.m
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/24.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "BarViewController.h"

@interface BarViewController ()

@property (nonatomic, strong) CCBarChartView *chartView;

@end

@implementation BarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    CCBarChartView *view = [[CCBarChartView alloc] initWithFrame:CGRectMake(24, 0, SCREEN_WIDTH - 48, 250)];
    view.delegate                                 = self;
    view.dataSource                               = self;
    self.chartView                                = view;
    [self.contentView addSubview:self.chartView];

    view.backgroundColor                          = [UIColor stringToColor:@"#F6F6F7" opacity:1];
    view.layer.cornerRadius                       = 4.f;
    view.clipEdgeInsets                           = UIEdgeInsetsMake(24, 8, 12, 24);

    view.rightAxis.axisLineDisabled               = YES;

    view.leftAxis.axisColor                       = [UIColor stringToColor:@"#D8D8D8" opacity:1];
    view.leftAxis.labelColor                      = [UIColor stringToColor:@"#99999A" opacity:1];
    view.leftAxis.labelCount                      = 7;
    view.leftAxis.formatter                       = [[NSNumberFormatter alloc] init];
    view.leftAxis.formatter.minimumFractionDigits = 2;
    view.leftAxis.formatter.maximumFractionDigits = 2;
    view.leftAxis.gridLineEnabled                 = NO;
    view.leftAxis.labelPosition                   = CCYAxisLabelPositionOutside;

    // 不需要右轴
    view.rightAxis                                = nil;

    view.xAxis.axisColor                          = [UIColor stringToColor:@"#D8D8D8" opacity:1];
    view.xAxis.labelColor                         = [UIColor stringToColor:@"#99999A" opacity:1];
    view.xAxis.totalCount                         = 30;
    view.xAxis.formatter.modulusStartIndex        = 0;
    view.xAxis.yLabelOffset                       = 5;
    view.xAxis.gridLineEnabled                    = NO;
    // 设置一下左右边缘距离
    view.xAxis.startMargin = 1;
    view.xAxis.endMargin = 1;

    view.cursor.labelColor                        = [UIColor stringToColor:@"#5543D7" opacity:1];
    view.cursor.lineColor                         = [UIColor stringToColor:@"#5543D7" opacity:0.5];
    view.cursor.xAxisYLabelOffset                 = 5;

    [view setNeedsPrepareChart];
}

#pragma mark - CCChartViewDataSource

- (CCChartData *)chartDataInView:(CCChartViewBase *)chartView {
    //固定30个实体
    NSMutableArray *entities   = @[].mutableCopy;
    NSMutableArray *xVals      = @[].mutableCopy;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    formatter.dateFormat = @"MM/dd";

    CGFloat max = 0;
    for (NSInteger i = 0; i < 30; i++) {
        CCChartDataEntity *entity = [[CCChartDataEntity alloc] initWithValue:[CCBaseUtility floatRandomBetween:0 and:10] xIndex:i data:nil];
        [entities addObject:entity];
        [xVals addObject:[NSString stringWithFormat:@"%@", [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:1577203200 - i * 3600 * 24]]]];
        if (max < entity.value) {
            max = entity.value;
        }
    }

    CCBarChartDataSet *dataSet = [[CCBarChartDataSet alloc] initWithEntities:entities withName:nil];
    dataSet.color = [UIColor stringToColor:@"#5543D7" opacity:1];
    dataSet.entityDistancePercent = 0.65;

    CCChartData *data = [[CCChartData alloc] initWithXVals:xVals dataSets:@[dataSet]];

    // 得到最大最小值之后, 手动设置给Y轴
    self.chartView.leftAxis.axisMinValue = 0;
    self.chartView.leftAxis.axisMaxValue = max * 1.2;

    return data;
}

@end
