//
//  CCChartDataEntity.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCChartDataEntity : NSObject

- (instancetype)initWithValue:(CGFloat)value xIndex:(NSInteger)xIndex data:(nullable id)data;

/**
 实体附加信息
 */
@property (nonatomic, strong) id data;


/**
 实体的值, 一般就是对应到y轴上的值
 */
@property (nonatomic, assign) CGFloat value;


/**
 实体对应的x坐标
 */
@property (nonatomic, assign) NSInteger xIndex;

@end

NS_ASSUME_NONNULL_END
