//
//  CCProtocolMarkerRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/4.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCProtocolChartRendererBase.h"

@protocol CCProtocolMarkerRenderer <CCProtocolChartRendererBase>

- (void)beginRenderingInLayer:(CALayer *)contentLayer atIndex:(NSInteger)index;

@end

