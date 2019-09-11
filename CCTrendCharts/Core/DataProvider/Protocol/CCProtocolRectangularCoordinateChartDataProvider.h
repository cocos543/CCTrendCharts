//
//  CCProtocolRectangularCoordinateChartDataProvider.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCProtocolChartDataProvider.h"

@protocol CCProtocolRectangularCoordinateChartDataProvider <CCProtocolChartDataProvider>


//  getTransformer



/**
 经过2D变换之后可见的最小索引
 */
@property (nonatomic, assign) NSInteger lowestVisibleXIndex;


/**
 经过2D变换之后可见的最大索引
 */
@property (nonatomic, assign) NSInteger highestVisibleXIndex;

@end
