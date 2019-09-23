//
//  CCProtocolAxisBase.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolBase.h"

typedef NS_ENUM(NSUInteger, CCXAxisLabelPosition) {
    CCXAxisLabelPositionTop, // X轴上方
    CCXAxisLabelPositionBottom, // x轴下方
};

typedef NS_ENUM(NSUInteger, CCYAxisLabelPosition) {
    CCYAxisLabelPositionInside, // y轴里侧
    CCYAxisLabelPositionOutside, // y轴外侧
};

typedef NS_ENUM(NSUInteger, CCYAsixDependency) {
    CCYAsixDependencyLeft = 0 << 0, // 左侧Y轴
    CCYAsixDependencyRight = 1 << 1, // 右侧Y轴
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
@property (nonatomic, assign) CGFloat axisLineWidth;






@end
