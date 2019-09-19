//
//  CCProtocolKLineChartDataSet.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCProtocolChartDataSet.h"

typedef NS_ENUM(NSUInteger, KLineChartDataSetType) {
    KLineChartDataSetTypeRise, //价格趋势上升
    KLineChartDataSetTypeEase //价格趋势上升
};

@protocol CCProtocolKLineChartDataSet <CCProtocolChartDataSet>
@required
/**
 高亮信息
 */
@property (nonatomic, strong) UIColor *highlightColor;

@property (nonatomic, assign) KLineChartDataSetType type;

@end
