//
//  CCProtocolAxisBase.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolBase.h"

typedef NS_ENUM(NSUInteger, XAxisLabelPosition) {
    XAxisLabelPositionTop, // X轴上方
    XAxisLabelPositionBottom, // x轴下方
};

typedef NS_ENUM(NSUInteger, YAxisLabelPosition) {
    YAxisLabelPositionInside, // y轴里侧
    YAxisLabelPositionOutside, // y轴外侧
};

@protocol CCProtocolAxisBase <CCProtocolBase>
@required


/**
 轴上文字字体
 */
@property (nonatomic, strong) UIFont *font;

/**
 Label数量
 */
@property (nonatomic, assign) NSInteger labelCount;

/**
 label颜色
 */
@property (nonatomic, strong) UIColor *labelColor;


/**
 label最大行数, 支持文本多行摆放
 */
@property (nonatomic, strong) UIColor *labelMaxLine;


/**
 轴的颜色
 */
@property (nonatomic, strong) UIColor *axisColor;


/**
 轴线粗细程度
 */
@property (nonatomic, strong) UIColor *axisLineWidth;






@end
