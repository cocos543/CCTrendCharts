//
//  CCKLineChartDataSet.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCKLineChartDataSet.h"

@implementation CCKLineChartDataSet

- (instancetype)initWithVals:(NSArray<CCChartDataEntity *> *)yVals withName:(NSString *)name {
    return [super initWithVals:yVals withName:name];
}


/// K线数据集的最值计算方法, 是通过数据实体中的data字段计算出的, 所以需要重写父类方法
/// @param start 起点
/// @param end 终点
- (void)calcMinMaxStart:(NSInteger)start End:(NSInteger)end {
    [super calcMinMaxStart:start End:end];
}

@end
