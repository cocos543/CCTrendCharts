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

/**
 开始绘制label的位置, 结合labelCount, 可以确定要绘制的全部label, 框架会自动计算
 
 @return 从第几个原始开始绘制label
 */
- (NSInteger)startIndexForDrawLabel;

@property (nonatomic, strong) id<CCProtocolXAxisFormatterBase> formatter;

@property (nonatomic, assign) CCXAxisLabelPosition labelPosition;


/**
 用于显示在轴上的字符串, 也称原始字符串, 下标就是对应X轴索引
 */
@property (nonatomic, copy) NSArray<NSString *> *entities;

// x轴暂时不支持定义最大小值, 先根据具体可以显示的x轴上索引, 自动显示x轴上的信息

@end

NS_ASSUME_NONNULL_END
