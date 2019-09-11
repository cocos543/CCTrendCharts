//
//  CCTestViewBase.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewBase.h"
#import "CCDefualtYAxis.h"
#import "CCDefualtXAxis.h"
#import "CCProtocolRectangularCoordinateChartDataProvider.h"


NS_ASSUME_NONNULL_BEGIN

@interface CCTestViewBase : CCChartViewBase <CCProtocolRectangularCoordinateChartDataProvider>

@end

NS_ASSUME_NONNULL_END
