//
//  CCCoordinateUtility.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/23.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 根据传入的Edge结构体, 剪切rect, 返回剪切后的rect

 @param rect 要剪切的rect
 @param insets 剪切掉的边缘值
 @return 剪切之后的rect
 */
CG_EXTERN CGRect CGRectClipRectUsingEdge(CGRect rect, UIEdgeInsets insets);
