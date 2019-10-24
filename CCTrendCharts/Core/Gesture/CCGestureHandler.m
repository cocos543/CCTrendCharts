//
//  CCGestureHandler.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/10/24.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCGestureHandler.h"

@interface CCGestureHandler() {
    CGPoint _lastScrollOfffset;
}

@end

@implementation CCGestureHandler
@synthesize viewPixelHandler = _viewPixelHandler;

- (instancetype)initWithTransformer:(CCChartViewPixelHandler *)viewPixelHandler {
    self = [super init];
    _viewPixelHandler = viewPixelHandler;
    _lastScrollOfffset = CGPointZero;
    return self;
}


- (void)longPressGestureStateChanging:(UILongPressGestureRecognizer *)gr {

}

- (void)panGestureChange:(UIPanGestureRecognizer *)gr {
    
}

- (void)didScroll:(CGPoint)offset {
    CGFloat tx = offset.x - _lastScrollOfffset.x;
    CGAffineTransform matrix =  self.viewPixelHandler.gestureMatrix;
    // offset是正数时说明视图正在显示右边内容, 所以数据绘制时需要左平移
    matrix.tx -= tx;
    
    self.viewPixelHandler.gestureMatrix = matrix;
    
    _lastScrollOfffset = offset;
}


- (void)doubleTapGestureStateChanging:(UITapGestureRecognizer *)gr {
    
}


- (void)tapGestureStateChanging:(UITapGestureRecognizer *)gr {
    
}


@end
