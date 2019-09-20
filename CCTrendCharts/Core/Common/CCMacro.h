//
//  CCMacro.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/20.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CGContextIndependent(ctx, code) \
CGContextSaveGState(ctx); \
code \
CGContextRestoreGState(ctx); \

