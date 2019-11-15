//
//  CCDefaultXAxisRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/12.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCRendererBase.h"
#import "CCProtocolAxisRenderer.h"
#import "CCDefaultXAxis.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCDefaultXAxisRenderer : CCRendererBase <CCProtocolAxisRenderer>

@property (nonatomic, weak) CCDefaultXAxis *axis;

- (instancetype)initWithAxis:(CCDefaultXAxis *)axis viewHandler:(CCChartViewPixelHandler *)viewPixelHandler transform:(CCChartTransformer *)transformer;

@end

NS_ASSUME_NONNULL_END
