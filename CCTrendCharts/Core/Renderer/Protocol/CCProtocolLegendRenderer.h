//
//  CCProtocolLegendRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/12/2.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCProtocolChartRendererBase.h"


/// 图例渲染器
@protocol CCProtocolLegendRenderer <CCProtocolChartRendererBase>

- (void)beginRenderingInLayer:(CALayer *)contentLayer atIndex:(NSInteger)index;

@end
