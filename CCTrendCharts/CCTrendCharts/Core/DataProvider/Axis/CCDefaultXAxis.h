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
/// 默认值 0.5
@property (nonatomic, assign) CGFloat startMargin;

/// 终点实体轴, 和Y轴的距离.
///
/// 默认值 0.5
@property (nonatomic, assign) CGFloat endMargin;

/// x方向实体的间距
///
/// 当autoXSapce为YES时, 该参数无效
///
/// 默认值 8个点
@property (nonatomic, assign) CGFloat xSpace;

/// 自动计算xSpace的值
///
/// 如果totalCount不为0时, 则按照totalCount指定的数量计算xSpace的值.
///
/// 如果totalCount为0, 则自动根据绘制区域宽度设置xSpace, 以满足数据全屏显示
///
/// 默认值 NO
@property (nonatomic, assign) BOOL autoXSapce;

/// 设置总数据个数
///
/// 正常情况下不需要设置, 如果设置了数据个数, 则autoXSapce会被设置为YES
///
/// 默认值 0
@property (nonatomic, assign) NSInteger totalCount;

@end

NS_ASSUME_NONNULL_END
