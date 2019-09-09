//
//  CCProtocolYAxis.h
//  CCTrendCharts
//
//  描述Y轴信息的内容, 比如Y轴文案的颜色, 字体, 数字精度, 最小y, 最大y
//
//  Created by Cocos on 2019/9/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCProtocolBase.h"

@protocol CCProtocolYAxis <CCProtocolBase>

// 确定y轴数据格式
@property (nonatomic, strong) NSNumberFormatter *formatter;

// 可以再设计子类, 描述网格信息

@end
