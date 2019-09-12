//
//  CCProtocolChartRendererBase.h
//  CCTrendCharts
//
//  渲染层基础协议
//
//  Created by Cocos on 2019/9/9.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCChartViewHandler.h"


@protocol CCProtocolChartRendererBase <NSObject>

@property (nonatomic, strong) CCChartViewHandler *viewhandler;

// 持有一个视图操作者CCChartViewPixelHandler, 所有放大缩小平移等信息都存储在viewHandler里面的CGAffineTransform, 这样方便运算数据的最终座标

// maxX, minX, 记录当前要渲染的区间

// 子协议还需要持有具体的DataProvider, 也就是视图类, 这样就可以直接从Provider里获取要渲染的数据.

// 渲染层可以拆分成多个子类, x轴类, 左y轴类, 右y轴类, 数据渲染类, Marker渲染类(就是手指长按浮出来的标记块)
// 其中每个子类由负责各种渲染, 比如x轴的负责画一条横线, 横线上的文字等

// 还可以设置其它子协议, 比如最小可见x index, 最大可见x index, 这样就可以提供给渲染层, 渲染层才知道要渲染哪些数据
@end

