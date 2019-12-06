//
//  CCRendererBase.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/13.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolChartRendererBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCRendererBase : NSObject <CCProtocolChartRendererBase>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithViewHandler:(CCChartViewPixelHandler *)viewPixelHandler transform:(CCChartTransformer *)transformer DataProvider:(nullable id<CCProtocolChartDataProvider>)dataProvider NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
