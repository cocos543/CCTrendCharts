//
//  CCDefaultXAxis.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCProtocolAxisBase.h"
#import "CCProtocolXAxisFormatterBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCDefaultXAxis : NSObject <CCProtocolAxisBase>

@property (nonatomic, strong) id<CCProtocolXAxisFormatterBase> formatter;

@property (nonatomic, assign) CCXAxisLabelPosition labelPosition;


/**
 用于显示在轴上的字符串, 也称原始字符串, 下标就是对应X轴索引
 */
@property (nonatomic, copy) NSArray<NSString *> *entities;


/// 起点实体轴, 和Y轴的距离.
///
/// 默认值0.5
@property (nonatomic, assign) CGFloat startMargin;

/// 终点实体轴, 和Y轴的距离.
///
/// 默认值0.5
@property (nonatomic, assign) CGFloat endMargin;

/// x方向实体的间距, 默认是8
@property (nonatomic, assign) CGFloat xSpace;

@end

NS_ASSUME_NONNULL_END
