//
//  CCDefaultYAxis.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolAxisBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCDefaultYAxis : NSObject <CCProtocolAxisBase>

// 确定y轴数据格式
@property (nonatomic, strong) NSNumberFormatter *formatter;


/**
 如果用户自行设置过minValue或者maxValue, customValue会被设置为true, 否则为false;
 当customValue为false时, 库会自动结合具体的数值确定大小值
 */
@property (nonatomic, assign) BOOL customValue;

@property (nonatomic, assign) CGFloat axisMinValue;

@property (nonatomic, assign) CGFloat axisMaxValue;

@property (nonatomic, assign) YAxisLabelPosition labelPosition;


/**
 Y轴上需要绘制label的实体数量, 默认是6个, 最少2个, 由渲染层根据实际情况计算实体的具体数值
 */
@property (nonatomic, strong) NSArray<NSNumber *> *entities;


/**
 return entities.count
 */
@property (nonatomic, assign, readonly) NSInteger entityCount;


/**
 用户可以通过设置labelCount来控制Y轴上的文案数量
 */
@property (nonatomic, assign) NSInteger labelCount;


// 可以再设计子类, 描述网格信息
@end

NS_ASSUME_NONNULL_END
