//
//  CCChartTransformer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/19.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartTransformer.h"

@interface CCChartTransformer () {
    // 偏差矩阵
    CGAffineTransform _offsetMatrix;
    // 标准矩阵
    CGAffineTransform _matrix;
}

/**
 视图放大缩小的所有信息都存放在CCChartViewHandler对象中, 结合matrixValueToPx可以计算出元素最终位置
 */
@property (nonatomic, strong) CCChartViewPixelHandler *viewPixelHandler;

@end


@implementation CCChartTransformer

- (instancetype)initWithViewPixelHandler:(CCChartViewPixelHandler *)viewPixelHandler {
    self = [super init];
    if (self) {
        _matrix = CGAffineTransformIdentity;
        _offsetMatrix = CGAffineTransformIdentity;
        _viewPixelHandler = viewPixelHandler;
    }
    return self;
}

- (void)refreshMatrix:(CGAffineTransform)matrix {
    _matrix = matrix;
}

- (void)refreshOffsetMatrix:(CGAffineTransform)offsetMatrix {
    _offsetMatrix = offsetMatrix;
}


- (CGPoint)pointToPixel:(CGPoint)point forAnimationPhaseY:(CGFloat)phaseY {
    return CGPointApplyAffineTransform(point, self.valueToPixelMatrix);
}

- (CGRect)rectToPixel:(CGRect)rect forAnimationPhaseY:(CGFloat)phaseY {
    return CGRectApplyAffineTransform(rect, self.valueToPixelMatrix);
}

#pragma mark - Getter & Setter
- (CGAffineTransform)valueToPixelMatrix {

    // 这里手势矩阵暂时是CGAffineTransformIdentity
    CGAffineTransform transform = CGAffineTransformConcat(_matrix, self.viewPixelHandler.gestureMatrix);
    transform = CGAffineTransformConcat(transform, _offsetMatrix);
    return transform;
    
}


@end
