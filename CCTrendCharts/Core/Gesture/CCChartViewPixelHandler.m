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
@synthesize gestureMatrix = _gestureMatrix;

- (instancetype)init {
    self = [super init];
    if (self) {
        _scaleX = _scaleY = 1;
        _minScaleX = _minScaleY = 0.5;
        _maxScaleX = _maxScaleY = 5;
        
        _gestureMatrix = CGAffineTransformIdentity;
        _anInitMatrix = CGAffineTransformIdentity;
    }
    return self;
}

- (BOOL)isInBoundsTop:(CGFloat)y {
    if (y < self.contentTop - 0.000001) {
        return YES;
    }
    return NO;
}

- (BOOL)isGestureProcessing {
    return !CGAffineTransformEqualToTransform(self.gestureMatrix, self.anInitMatrix);
}

- (void)updateContentRectOffsetLeft:(CGFloat)offsetLeft offsetRight:(CGFloat)offsetRight offsetTop:(CGFloat)offsetTop offsetBottom:(CGFloat)offsetBottom {
    CGFloat x = self.contentRect.origin.x;
    CGFloat y = self.contentRect.origin.y;
    CGFloat width = self.contentRect.size.width;
    CGFloat height = self.contentRect.size.height;
    
    x += offsetLeft;
    y += offsetTop;
    
    width = width - offsetLeft - offsetRight;
    height = height - offsetTop - offsetBottom;
    
    self.contentRect = CGRectMake(x, y, width, height);
}

- (CGAffineTransform)zoomScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    return CGAffineTransformScale(_gestureMatrix, scaleX, scaleY);
}

- (CGAffineTransform)zoomScaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY aroundCenter:(CGPoint)center {
    // 围绕缩放中心进行缩放的算法如下:
    // 1. 平移到scaleCenter的x, y
    // 2. 缩放n倍
    // 3. 在缩放的基础上平移-x, -y
    CGAffineTransform newMatrix = CGAffineTransformMakeTranslation(center.x, center.y);
    newMatrix = CGAffineTransformTranslate(newMatrix, scaleX, scaleY);
    newMatrix = CGAffineTransformTranslate(newMatrix, -center.x, -center.y);
    return newMatrix;
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
    if (matrix.a < self.minScaleX || matrix.a > self.maxScaleX) {
        return self.gestureMatrix;
    }
    
    _transX = matrix.tx;
    _scaleY = matrix.d;
    _scaleX = matrix.a;
    
    matrix.a = _scaleX;
    matrix.d = _scaleY;
    return matrix;
}

#pragma mark - Getter & Setter
- (void)setAnInitMatrix:(CGAffineTransform)anInitMatrix {
    _anInitMatrix = anInitMatrix;
    self.gestureMatrix = anInitMatrix;
}

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

- (NSString *)description {
    NSMutableString *str = NSMutableString.string;
    [str appendFormat:@"[%p] %@\n\n", self, NSStringFromClass(self.class)];
    [str appendFormat:@"viewFrame:%@\n", NSStringFromCGRect(self.viewFrame)];
    [str appendFormat:@"contentRect:%@\n", NSStringFromCGRect(self.contentRect)];
    [str appendFormat:@"offsetLeft:%f\n", self.offsetLeft];
    [str appendFormat:@"offsetRight:%f\n", self.offsetRight];
    [str appendFormat:@"offsetTop:%f\n", self.offsetTop];
    [str appendFormat:@"offsetBottom:%f\n", self.offsetBottom];
    
    return str;
}

@end
