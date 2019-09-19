//
//  CCChartTransformer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/19.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartTransformer.h"

@interface CCChartTransformer ()

/**
 视图放大缩小的所有信息都存放在CCChartViewHandler对象中, 结合matrixValueToPx可以计算出元素最终位置
 */
@property (nonatomic, strong) CCChartViewPixelHandler *viewPixelHandler;

/**
 矩阵, 用于转换原始坐标 到 变换后的坐标, 这里将会用于做偏移量转换
 */
@property (nonatomic, assign) CGAffineTransform matrixValueToPx;

@end


@implementation CCChartTransformer

- (instancetype)init {
    self = [super init];
    if (self) {
        _matrixValueToPx = CGAffineTransformIdentity;
    }
    
    return self;
}

@end
