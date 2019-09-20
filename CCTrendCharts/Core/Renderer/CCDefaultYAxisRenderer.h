//
//  CCDefaultYAxisRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/12.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolAxisRenderer.h"
#import "CCDefaultYAxis.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCDefaultYAxisRenderer : NSObject <CCProtocolAxisRenderer>

@property (nonatomic, weak) CCDefaultYAxis *axis;

/**
 传入最小, 最大值, 渲染层根据axis对象计算出y轴上的全部label

 @param min min
 @param max max
 */
- (void)processAxisEntities:(CGFloat)min :(CGFloat)max;


- (instancetype)init NS_UNAVAILABLE;

/**
 指定初始化方法, 用于创建Axis渲染实例

 @param axis y轴数据提供者
 @param viewPixelHandler 视图像素处理对象
 @param transformer 反射对象
 @return instancetype
 */
- (instancetype)initWithAxis:(CCDefaultYAxis *)axis viewHandler:(CCChartViewPixelHandler *)viewPixelHandler transform:(CCChartTransformer *)transformer NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
