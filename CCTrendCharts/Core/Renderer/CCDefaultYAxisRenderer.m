//
//  CCDefaultYAxisRenderer.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/12.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCDefaultYAxisRenderer.h"


//void Hello(int a) {
//    printf("hello %d\n", a);
//}

@interface CCDefaultYAxisRenderer()

@end

@implementation CCDefaultYAxisRenderer

@synthesize viewPixelHandler = _viewPixelHandler;
@synthesize transformer = _transformer;

- (instancetype)initWithAxis:(nonnull CCDefaultYAxis *)axis viewHandler:(nonnull CCChartViewPixelHandler *)viewPixelHandler transform:(nonnull CCChartTransformer *)transformer {
    self = [super init];
    if (self) {
        _axis = axis;
        _viewPixelHandler = viewPixelHandler;
        _transformer = transformer;
    }
    
    return self;
}

- (void)renderAxisLine:(CALayer *)contentLayer {
//    NSLog(@"渲染层接到画y轴直线通知~");

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(ctx, CGContextGetClipBoundingBox(ctx));
    
    if (self.axis.dependency == CCYAsixDependencyRight) {
        // 先把当前图层的内容画上去, 在原来的基础上进行绘制
        UIImage *oldImg = [UIImage imageWithCGImage:(__bridge CGImageRef)contentLayer.contents scale:CCBaseUtility.currentScale orientation:UIImageOrientationUp];
        [oldImg drawAtPoint:CGPointZero];
    }
    
    
    CGContextSaveGState(ctx);
    {
        CGContextSetStrokeColorWithColor(ctx, self.axis.axisColor.CGColor);
        CGContextSetLineWidth(ctx, self.axis.axisLineWidth);
        
        // 这里根据不同配置绘制左右轴
        if (self.axis.dependency == CCYAsixDependencyLeft) {
            CGContextMoveToPoint(ctx, self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentBottom);
            CGContextAddLineToPoint(ctx, self.viewPixelHandler.contentLeft, self.viewPixelHandler.contentTop);
        }else if (self.axis.dependency == CCYAsixDependencyRight) {
            CGContextMoveToPoint(ctx, self.viewPixelHandler.contentRight, self.viewPixelHandler.contentBottom);
            CGContextAddLineToPoint(ctx, self.viewPixelHandler.contentRight, self.viewPixelHandler.contentTop);
        }
        
        CGContextStrokePath(ctx);
    }
    
    CGContextRestoreGState(ctx);
    
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    
    // 这里使用__bridge_transfer关键字, img引用计数-1, 所以不需要再调用release方法了
    contentLayer.contents = (__bridge_transfer id)img;
    
}

- (void)renderGridLines:(CALayer *)contentLayer {
    
}

- (void)renderLabels:(CALayer *)contentLayer {
//    NSLog(@"准备开始渲染y轴 label 信息");
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(ctx, CGContextGetClipBoundingBox(ctx));
    
    // 先把当前图层的内容画上去, 在原来的基础上进行绘制
    UIImage *oldImg = [UIImage imageWithCGImage:(__bridge CGImageRef)contentLayer.contents scale:CCBaseUtility.currentScale orientation:UIImageOrientationUp];
    [oldImg drawAtPoint:CGPointZero];
    
    CGContextSaveGState(ctx);
    {
        
        // 临时代码, 绘制地基
        CGContextSetStrokeColorWithColor(ctx, self.axis.axisColor.CGColor);
        CGContextSetLineWidth(ctx, self.axis.axisLineWidth);
        
        // 确定文案x位置
        CGFloat xPos = 0;
        CGPoint anchor = CGPointZero;
        if (self.axis.dependency == CCYAsixDependencyLeft) {
            if (self.axis.labelPosition == CCYAxisLabelPositionOutside) {
                xPos = self.viewPixelHandler.contentLeft - self.axis.xLabelOffset;
                anchor = CGPointMake(1, 0.5);
            }else if (self.axis.labelPosition == CCYAxisLabelPositionInside) {
                xPos = self.viewPixelHandler.contentLeft + self.axis.xLabelOffset;
                anchor = CGPointMake(0, 0.5);
            }
            
        }else if (self.axis.dependency == CCYAsixDependencyRight) {
            if (self.axis.labelPosition == CCYAxisLabelPositionOutside) {
                xPos = self.viewPixelHandler.contentRight + self.axis.xLabelOffset;
                anchor = CGPointMake(0, 0.5);
            }else if (self.axis.labelPosition == CCYAxisLabelPositionInside) {
                xPos = self.viewPixelHandler.contentRight - self.axis.xLabelOffset;
                anchor = CGPointMake(1, 0.5);
            }
        }
        
        // 确定文案y位置
        for (NSNumber *num in self.axis.entities) {
            CGPoint position = CGPointMake(0, num.doubleValue);
            position = [self.transformer pointToPixel:position forAnimationPhaseY:1];
            position.x = xPos;
            if ([self.viewPixelHandler isInBoundsTop:position.y]) {
                continue;
            }
            
            // 临时代码, 绘制地基
            if (self.axis.dependency == CCYAsixDependencyLeft) {
                CGContextMoveToPoint(ctx, self.viewPixelHandler.contentLeft, position.y);
                CGContextAddLineToPoint(ctx, self.viewPixelHandler.contentLeft + 5, position.y);
            }else {
                CGContextMoveToPoint(ctx, self.viewPixelHandler.contentRight, position.y);
                CGContextAddLineToPoint(ctx, self.viewPixelHandler.contentRight - 5, position.y);
            }
            
            
            NSString *text = [self.axis.formatter stringFromNumber:num];
            [text drawTextIn:ctx x:position.x y:position.y + self.axis.yLabelOffset anchor:anchor attributes:@{NSFontAttributeName: self.axis.font, NSForegroundColorAttributeName: self.axis.labelColor}];
        }
        CGContextStrokePath(ctx);
    }
    
    CGContextRestoreGState(ctx);
    
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    contentLayer.contents = (__bridge_transfer id)img;
    
}

- (void)processAxisEntities:(CGFloat)min :(CGFloat)max {
    
}

@end
