//
//  CCRendererBase.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/13.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCRendererBase.h"

@implementation CCRendererBase
@synthesize viewPixelHandler = _viewPixelHandler;
@synthesize transformer      = _transformer;
@synthesize dataProvider     = _dataProvider;

- (instancetype)initWithViewHandler:(CCChartViewPixelHandler *)viewPixelHandler transform:(CCChartTransformer *)transformer DataProvider:(id<CCProtocolChartDataProvider>)dataProvider {
    self = [super init];
    if (self) {
        _viewPixelHandler = viewPixelHandler;
        _transformer      = transformer;
        _dataProvider     = dataProvider;
    }
    
    return self;
}

@end
