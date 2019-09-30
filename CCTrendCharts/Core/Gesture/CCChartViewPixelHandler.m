//
//  CCChartViewPixelHandler.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/9.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCChartViewPixelHandler.h"

@interface CCChartViewPixelHandler() {

}

@end

@implementation CCChartViewPixelHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        _scaleX = _scaleY = 1;
        _minScaleX = _minScaleY = 1;
        _maxScaleX = _maxScaleY = 2;
        
        _gestureMatrix = CGAffineTransformIdentity;
    }
    return self;
}

- (CGAffineTransform)zoomScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    return CGAffineTransformScale(_gestureMatrix, scaleX, scaleY);
}

- (CGAffineTransform)zoomScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY aroundCenter:(CGPoint)center {
    CGAffineTransform newMatrix = CGAffineTransformMakeTranslation(center.x, center.y);
    return CGAffineTransformTranslate(newMatrix, scaleX, scaleY);
}

- (CGAffineTransform)zoomInAroundCenter:(CGPoint)center {
    return [self zoomScaleX:1.1 scaleY:1.1 aroundCenter:center];
}

- (CGAffineTransform)zoomOutAroundCenter:(CGPoint)center {
    return [self zoomScaleX:1.1 scaleY:1.1 aroundCenter:center];
}


/**
 返回符合限制要求的矩形

 @param matrix 矩阵
 @return 符合要求的矩阵
 */
- (CGAffineTransform)_checkScale:(CGAffineTransform)matrix {
    _scaleX = MIN(matrix.a, self.minScaleX);
    _scaleY = MIN(matrix.b, self.minScaleY);
    
    matrix.a = _scaleX;
    matrix.b = _scaleX;
    return matrix;
}

#pragma mark - Getter & Setter
- (void)setGestureMatrix:(CGAffineTransform)gestureMatrix {
    gestureMatrix = [self _checkScale:gestureMatrix];
    _gestureMatrix = gestureMatrix;
}

- (CGFloat)viewWidth {
    return self.viewFrame.size.width;
}

- (CGFloat)viewHeight {
    return self.viewFrame.size.height;
}

- (CGFloat)contentWidth {
    return self.contentRect.size.width;
}

- (CGFloat)contentHeight {
    return self.contentRect.size.height;
}

- (CGFloat)contentLeft {
    return self.contentRect.origin.x;
}

- (CGFloat)contentRight {
    return self.contentRect.origin.x + self.contentRect.size.width;
}

- (CGFloat)contentTop {
    return self.contentRect.origin.y;
}

- (CGFloat)contentBottom {
    return self.contentRect.origin.y + self.contentRect.size.height;
}

- (CGFloat)offsetLeft {
    return self.contentRect.origin.x;
}

- (CGFloat)offsetRight {
    return self.viewWidth - self.contentRect.origin.x - self.contentRect.size.width;
}

- (CGFloat)offsetTop {
    return self.contentRect.origin.y;
}

- (CGFloat)offsetBottom {
    return self.viewHeight - self.contentRect.origin.y - self.contentRect.size.height;
}

@end
