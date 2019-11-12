//
//  CCChartDataEntity.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCProtocolChartDataEntityBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCChartDataEntity : NSObject <CCProtocolChartDataEntityBase>

- (instancetype)initWithValue:(CGFloat)value xIndex:(NSInteger)xIndex data:(nullable id)data;

@end

NS_ASSUME_NONNULL_END
