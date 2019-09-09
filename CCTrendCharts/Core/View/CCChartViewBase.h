//
//  CCChartViewBase.h
//  CCTrendCharts
//
//  基类视图, 所有不同的趋势图都将继承该类
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCProtocolChartViewBase.h"


NS_ASSUME_NONNULL_BEGIN

@interface CCChartViewBase : UIView <CCProtocolChartViewBase>

// 提供Y轴上文案的信息
@property (nonatomic, strong) id<CCProtocolYAxis> yAxis;

// 提供X轴上文案信息
@property (nonatomic, strong) id<CCProtocolXAxis> xAxis;

@end

NS_ASSUME_NONNULL_END
