//
//  CCKLineDataChartRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/13.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDataChartRenderer.h"
#import "CCProtocolKLineDataChartRenderer.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCKLineDataChartRenderer : CCDataChartRenderer <CCProtocolKLineDataChartRenderer>

@end

NS_ASSUME_NONNULL_END
