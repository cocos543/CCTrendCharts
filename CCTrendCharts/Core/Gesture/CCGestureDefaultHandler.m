//
//  CCGestureDefaultHandler.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/10/24.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCGestureDefaultHandler.h"

@interface CCGestureDefaultHandler() {
    
}

@end

@implementation CCGestureDefaultHandler
@synthesize viewPixelHandler = _viewPixelHandler;
@synthesize baseView = _baseView;
@synthesize delegate = _delegate;

- (instancetype)initWithTransformer:(CCChartViewPixelHandler *)viewPixelHandler {
    self = [super init];
    _viewPixelHandler = viewPixelHandler;
    return self;
}


- (void)longPressGestureStateChanging:(UILongPressGestureRecognizer *)gr {

}

- (void)panGestureChange:(UIPanGestureRecognizer *)gr {
    
}

- (void)didScroll:(CGPoint)offset {
    CGAffineTransform matrix =  self.viewPixelHandler.gestureMatrix;
    // offset是正数时说明视图正在显示右边内容, 所以数据绘制时需要左平移
    matrix.tx = -offset.x;
    self.viewPixelHandler.gestureMatrix = matrix;
}


- (void)doubleTapGestureStateChanging:(UITapGestureRecognizer *)gr {
    
}


- (void)tapGestureStateChanging:(UITapGestureRecognizer *)gr {
    
}

- (void)pinchGestureStateChanging:(UIPinchGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateBegan) {
        
    }else if (gr.state == UIGestureRecognizerStateChanged) {
        // 缩放中心
        CGPoint scaleCenter = [gr locationInView:self.baseView];
        
        scaleCenter.x = scaleCenter.x - self.viewPixelHandler.contentLeft;
        scaleCenter.y = scaleCenter.y - self.viewPixelHandler.contentTop;
        
        // 这里只关心x位置, 不关心y, 因为不打算支持y轴缩放
        // 围绕缩放中心进行缩放的算法如下:
        // 1. 平移到scaleCenter的x, y
        // 2. 缩放n倍
        // 3. 在缩放的基础上平移-x, -y
        CGAffineTransform matrix = CGAffineTransformIdentity;
        
        matrix = CGAffineTransformTranslate(matrix, scaleCenter.x, scaleCenter.y);
        matrix = CGAffineTransformScale(matrix, gr.scale, 1);
        matrix = CGAffineTransformTranslate(matrix, -scaleCenter.x, -scaleCenter.y);
        self.viewPixelHandler.gestureMatrix = CGAffineTransformConcat(self.viewPixelHandler.gestureMatrix, matrix);
        
        [self.baseView setNeedsDisplay];
        
        // 还原缩放值, 因为缩放的部分已经叠加到gestureMatrix矩阵里了.
        gr.scale = 1.0;
        
        if ([self.delegate respondsToSelector:@selector(gestureDidPinchInLocation:matrix:)]) {
            [self.delegate gestureDidPinchInLocation:scaleCenter matrix:matrix];
        }
    }else if (gr.state == UIGestureRecognizerStateEnded) {
        
    }
}

#pragma mark Setter & Getter
- (UIPinchGestureRecognizer *)pinchGesture {
    UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureStateChanging:)];
    pinchGR.scale = 1.0;
    return pinchGR;
}


@end
