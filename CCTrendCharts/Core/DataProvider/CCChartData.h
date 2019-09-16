//
//  CCChartData.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCProtocolChartDataSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCChartData : NSObject

/**
 根据当前数据集重新计算最大最小值
 */
- (void)calcMinMax;


/**
 集合数组
 */
@property (nonatomic, strong) NSArray<CCProtocolChartDataSet> *dataSets;

/**
 X轴对应的数据(x轴上的文案)
 */
@property (nonatomic, strong) NSArray<NSString *> *xVals;

@property (nonatomic, readonly, assign) CGFloat maxY;

@property (nonatomic, readonly, assign) CGFloat minY;

@property (nonatomic, readonly, assign) CGFloat minX;

@property (nonatomic, readonly, assign) CGFloat maxX;




@end

NS_ASSUME_NONNULL_END
