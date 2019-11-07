//
//  CCProtocolCursorRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/4.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CCProtocolChartRendererBase.h"
#import "CCProtocolCursorBase.h"
#import "CCProtocolAxisBase.h"

@protocol CCProtocolCursorRenderer <CCProtocolChartRendererBase>

- (void)beginRenderingInLayer:(CALayer *)layer center:(CGPoint)center;

- (void)rendererCursor:(CALayer *)layer center:(CGPoint)center;

- (void)rendererXLabel:(CALayer *)layer center:(CGPoint)center;

- (void)rendererLeftLabel:(CALayer *)layer center:(CGPoint)center;

- (void)rendererRightLabel:(CALayer *)layer center:(CGPoint)center;


/// 渲染层直接根据cursor对象进行渲染
@property (nonatomic, weak) id<CCProtocolCursorBase> cursor;


/// 为指示器提供数据信息
@property (nonatomic, weak) id<CCProtocolAxisBase> leftAxis;

/// 为指示器提供数据信息
@property (nonatomic, weak) id<CCProtocolAxisBase> rightAxis;

/// 为指示器提供数据信息
@property (nonatomic, weak) id<CCProtocolAxisBase> xAxis;

@end
