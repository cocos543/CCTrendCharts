//
//  CCDefaultXAxisRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/12.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolAxisRenderer.h"
#import "CCDefaultXAxis.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCDefaultXAxisRenderer : NSObject <CCProtocolAxisRenderer>

@property (nonatomic, weak) CCDefaultXAxis *axis;


- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithAxis:(CCDefaultXAxis *)axis viewHandler:(CCChartViewPixelHandler *)viewPixelHandler transform:(CCChartTransformer *)transformer NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
