//
//  CCDefaultCursorRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/4.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCRendererBase.h"
#import "CCProtocolCursorRenderer.h"
#import "CCDefaultYAxis.h"
#import "CCDefaultXAxis.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCDefaultCursorRenderer : CCRendererBase <CCProtocolCursorRenderer>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithCursor:(id<CCProtocolCursorBase>)cursor viewHandler:(CCChartViewPixelHandler *)viewPixelHandler transform:(CCChartTransformer *)transformer DataProvider:(id<CCProtocolChartDataProvider>)dataProvider;


@property (nonatomic, weak) CCDefaultYAxis *leftAxis;

@property (nonatomic, weak) CCDefaultYAxis *rightAxis;

@property (nonatomic, weak) CCDefaultXAxis *xAxis;
@end

NS_ASSUME_NONNULL_END
