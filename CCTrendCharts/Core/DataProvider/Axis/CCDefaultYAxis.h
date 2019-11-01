//
//  CCDefaultYAxis.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCProtocolAxisBase.h"
#import "CCChartData.h"


NS_ASSUME_NONNULL_BEGIN

@interface CCDefaultYAxis : NSObject <CCProtocolAxisBase>


/// 根据当前
/// @param charData 数据源
- (void)calculateMinMax:(CCChartData *)charData;


/// 根据轴最值, labelCount等参数, 生成y轴实体数据, 有需要可以重写
- (void)generateEntities;

- (instancetype)initWithDependency:(CCYAsixDependency)dependency NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

// 确定y轴数据格式
@property (nonatomic, strong) NSNumberFormatter *formatter;


/**
 如果用户自行设置过minValue或者maxValue, customValue会被设置为true, 否则为false;
 当customValue为false时, 库会自动结合具体的数值确定大小值
 */
@property (nonatomic, assign) BOOL customValue;


/// 最少2个
@property (nonatomic, assign) NSInteger labelCount;

@property (nonatomic, assign) CGFloat axisMinValue;

@property (nonatomic, assign) CGFloat axisMaxValue;

@property (nonatomic, assign) CCYAxisLabelPosition labelPosition;

@property (nonatomic, assign) CCYAsixDependency dependency;


/**
 绘制到y轴上的信息
 
 
 通常是有多少个元素就在y轴上绘制多少个文本
 */
@property (nonatomic, strong) NSArray<NSNumber *> *entities;


/**
 return entities.count
 */
@property (nonatomic, assign, readonly) NSInteger entityCount;



// 可以再设计子类, 描述网格信息
@end

NS_ASSUME_NONNULL_END
