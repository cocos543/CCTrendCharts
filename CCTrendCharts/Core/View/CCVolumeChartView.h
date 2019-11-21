//
//  CCVolumeChartView.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/20.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCBarChartView.h"
#import "CCVolumeDataChartRenderer.h"
#import "CCProtocolKLineChartDataProvider.h"

NS_ASSUME_NONNULL_BEGIN

// 交易量图
@interface CCVolumeChartView : CCBarChartView <CCProtocolKLineChartDataProvider>


@end

NS_ASSUME_NONNULL_END
