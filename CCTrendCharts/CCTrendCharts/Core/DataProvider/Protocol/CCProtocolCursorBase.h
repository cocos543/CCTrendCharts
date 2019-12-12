//
//  CCProtocolCursorBase.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/5.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCProtocolBase.h"

@protocol CCProtocolCursorBase <CCProtocolBase>


/// 指示器颜色
@property (nonatomic, strong) UIColor *lineColor;

/// 文本颜色
@property (nonatomic, strong) UIColor *labelColor;

/// 字体
@property (nonatomic, strong) UIFont *font;

/// 线宽
@property (nonatomic, assign) CGFloat lineWidth;

/// CGContext - setLineDash
@property (nonatomic, assign) CGFloat lineDashPhase;
@property (nonatomic, strong) NSArray *lineDashLengths;

@property (nonatomic, assign) CGLineCap lineCap;


/// 提供震动反馈, 默认是UIImpactFeedbackStyleLight类型
@property (nonatomic, strong) UIImpactFeedbackGenerator *impactFeedback;


/// 震动强度, 取值0.0 ~ 1.0
@property (nonatomic, assign) CGFloat intensity API_AVAILABLE(ios(13.0));



@end