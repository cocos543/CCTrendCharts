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



/**
 请不要直接使用基类视图!
 */
@interface CCChartViewBase : UIView <CCProtocolChartViewBase>


@end

NS_ASSUME_NONNULL_END
