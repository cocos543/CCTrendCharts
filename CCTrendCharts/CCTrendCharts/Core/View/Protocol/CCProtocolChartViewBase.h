//
//  CCProtocolChartViewBase.h
//  CCTrendCharts
//
//  规定了所有ChartView必须实现的协议
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCProtocolBase.h"

#import "CCProtocolDataChartRenderer.h"
#import "CCProtocolAxisRenderer.h"
#import "CCProtocolCursorRenderer.h"
#import "CCProtocolMarkerRenderer.h"

#import "CCDefaultYAxis.h"
#import "CCDefaultXAxis.h"
#import "CCProtocolCursorBase.h"
#import "CCProtocolMarkerRenderer.h"
#import "CCProtocolLegendRenderer.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CCProtocolChartViewBase <CCProtocolBase>
@required


/// 用于支持数据渲染, 基类方法默认不做任何事情, 子类可自行实现.
- (void)dataRendering;

/**
 所有2D变换信息都存储在viewHandler里, 以及视图当前画布信息, 可直接由用户手势改变其信息.
 */
@property (nonatomic, readonly) CCChartViewPixelHandler *viewPixelHandler;

/**
 记录和反射相关的信息, 结合CCChartViewPixelHandler对象可以运算出数据的真实坐标
 */
@property (nonatomic, readonly) CCChartTransformer *transformer;


/// 专供右轴使用的变形器
@property (nonatomic, readonly, nullable) CCChartTransformer *rightTransformer;

/**
 提供Y轴上文案的信息, 左轴不能为nil
 */
@property (nonatomic, strong) CCDefaultYAxis *leftAxis;


/// 右轴功能同左轴, 右轴可以为nil
@property (nonatomic, strong, nullable) CCDefaultYAxis *rightAxis;

/**
 提供X轴上文案信息
 */
@property (nonatomic, strong) CCDefaultXAxis *xAxis;

@property (nonatomic, strong, nullable) id<CCProtocolCursorBase> cursor;

/**
 渲染组件
 */
@property (nonatomic, strong) id<CCProtocolDataChartRenderer> dataRenderer;

/**
 这里视图类只需要关注渲染对象是否实现基础协议即可, 具体的渲染过程由渲染对象内部处理
 */
@property (nonatomic, strong) id<CCProtocolAxisRenderer> xAxisRenderer;

@property (nonatomic, strong) id<CCProtocolAxisRenderer> leftAxisRenderer;

@property (nonatomic, strong, nullable) id<CCProtocolAxisRenderer> rightAxisRenderer;

@property (nonatomic, strong, nullable) id<CCProtocolMarkerRenderer> markerRenderer;

@property (nonatomic, strong, nullable) id<CCProtocolCursorRenderer> cursorRenderer;

@property (nonatomic, strong, nullable) id<CCProtocolLegendRenderer> legendRenderer;

@end

NS_ASSUME_NONNULL_END
