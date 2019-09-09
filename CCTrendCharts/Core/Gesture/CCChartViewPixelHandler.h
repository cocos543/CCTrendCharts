//
//  CCChartViewPixelHandler.h
//  CCTrendCharts
//
//  所有放大缩小操作都会做用到Handler对象上
//
//  Created by Cocos on 2019/9/9.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCChartViewPixelHandler : NSObject

// 定义一个CGAffineTransform结构体, 可以被渲染层调用, 用于把数据图表转换成屏幕上的真实位置.

// 定义其他放大缩小的方法, 用于改变CGAffineTransform结构体信息


@end

NS_ASSUME_NONNULL_END
