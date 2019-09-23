//
//  CCCoordinateUtility.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/23.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCCoordinateUtility.h"

CGRect CGRectClipRectUsingEdge(CGRect rect, UIEdgeInsets insets) {
    return CGRectMake(rect.origin.x + insets.left,
                      rect.origin.y + insets.top,
                      rect.size.width - insets.left - insets.right,
                      rect.size.height - insets.top - insets.bottom);
}
