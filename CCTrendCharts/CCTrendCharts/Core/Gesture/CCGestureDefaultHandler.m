//
//  CCGestureDefaultHandler.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/10/24.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCGestureDefaultHandler.h"

@interface CCGestureDefaultHandler() <UIGestureRecognizerDelegate> {

}

@end

@implementation CCGestureDefaultHandler
@synthesize viewPixelHandler = _viewPixelHandler;
@synthesize baseView = _baseView;
@synthesize delegate = _delegate;
@synthesize pinchGesture = _pinchGesture;
@synthesize longPressGesture = _longPressGesture;

- (instancetype)initWithTransformer:(CCChartViewPixelHandler *)viewPixelHandler {
    self = [super init];
    _viewPixelHandler = viewPixelHandler;
    return self;
}


- (void)longPressGestureStateChanging:(UILongPressGestureRecognizer *)gr {
    
    CGPoint center = [gr locationInView:self.baseView];
    // 更好的触摸体验:)
    center.x -= 2.5;
    if (gr.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(gestureDidLongPressInLocation:)]) {
            [self.delegate gestureDidLongPressInLocation:center];
        }
    }else if (gr.state == UIGestureRecognizerStateChanged) {
        if ([self.delegate respondsToSelector:@selector(gestureDidLongPressInLocation:)]) {
            [self.delegate gestureDidLongPressInLocation:center];
        }
    }else if (gr.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(gestureDidEndLongPressInLocation:)]) {
            [self.delegate gestureDidEndLongPressInLocation:center];
        }
    }
}

- (void)panGestureChange:(UIPanGestureRecognizer *)gr {
    
}

- (void)didScrollIncrementOffsetX:(CGFloat)incrementOffsetX {
    CGAffineTransform matrix =  self.viewPixelHandler.gestureMatrix;
    
    //offsetX是正数时, 说明视图正在显示左侧内容, 所以数据绘制时需要左平移, 所以需要 -= incrementOffsetX
    matrix.tx -= incrementOffsetX;
    self.viewPixelHandler.gestureMatrix = matrix;
    
    if ([self.delegate respondsToSelector:@selector(gestureDidPanIncrementOffset:matrix:)]) {
        [self.delegate gestureDidPanIncrementOffset:CGPointMake(incrementOffsetX, 0) matrix:matrix];
    }
}



- (void)doubleTapGestureStateChanging:(UITapGestureRecognizer *)gr {
    
}


- (void)tapGestureStateChanging:(UITapGestureRecognizer *)gr {
    
}

- (void)pinchGestureStateChanging:(UIPinchGestureRecognizer *)gr {
    
    // 缩放中心
    CGPoint scaleCenter = [gr locationInView:self.baseView];
    
    // 这里只关心x位置, 不关心y, 因为不打算支持y轴缩放
    // 围绕缩放中心进行缩放的算法如下:
    // 1. 平移到scaleCenter的x, y
    // 2. 缩放n倍
    // 3. 在缩放的基础上平移-x, -y
    CGAffineTransform matrix = [self.viewPixelHandler zoomScaleX:gr.scale scaleY:1 aroundCenter:scaleCenter];
    
//    matrix = CGAffineTransformTranslate(matrix, scaleCenter.x, scaleCenter.y);
//    matrix = CGAffineTransformScale(matrix, gr.scale, 1);
//    matrix = CGAffineTransformTranslate(matrix, -scaleCenter.x, -scaleCenter.y);
    
    self.viewPixelHandler.gestureMatrix = CGAffineTransformConcat(self.viewPixelHandler.gestureMatrix, matrix);
    
    // 还原缩放值, 因为缩放的部分已经叠加到gestureMatrix矩阵里了.
    gr.scale = 1.0;
    
    if (gr.state == UIGestureRecognizerStateBegan) {
        
    }else if (gr.state == UIGestureRecognizerStateChanged) {
        if ([self.delegate respondsToSelector:@selector(gestureDidPinchInLocation:matrix:)]) {
            [self.delegate gestureDidPinchInLocation:scaleCenter matrix:matrix];
        }
    }else if (gr.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(gestureDidEndPinchInLocation:matrix:)]) {
            [self.delegate gestureDidEndPinchInLocation:scaleCenter matrix:matrix];
        }
    }
}

#pragma mark Setter & Getter
- (UIPinchGestureRecognizer *)pinchGesture {
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureStateChanging:)];
        _pinchGesture.scale = 1.0;
        _pinchGesture.delegate = self;
    }
    
    return _pinchGesture;
}

- (UILongPressGestureRecognizer *)longPressGesture {
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureStateChanging:)];
    }

    return _longPressGesture;
}


#pragma mark - UIGestureRecognizerDelegate
// 开启滚动缩放同时响应之后会有BUG, 当前代码的滚动利用ScrollView实现,缩放时会暂时禁用滚动带来的影响.
// 若允许缩放的同时操作滚动, 会导致计算出的结果不准确, 后续可以重写滚动的实现方式来解决该问题.
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (gestureRecognizer == self.pinchGesture) {
//        // 允许缩放手势和滚动手势同时响应
//        if ([otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
//            return YES;
//        }
//    }
//    return NO;
//}

@end
