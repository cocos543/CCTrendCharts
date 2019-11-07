//
//  CCDefaultMarkerRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/7.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolMarkerRenderer.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCDefaultMarkerRenderer : NSObject <CCProtocolMarkerRenderer>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithViewHandler:(CCChartViewPixelHandler *)viewPixelHandler transform:(CCChartTransformer *)transformer DataProvider:(id<CCProtocolChartDataProvider>)dataProvider NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
