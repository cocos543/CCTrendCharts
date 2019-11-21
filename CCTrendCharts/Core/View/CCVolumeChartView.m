//
//  CCVolumeChartView.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/20.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCVolumeChartView.h"

@implementation CCVolumeChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 交易量柱型图渲染器
        self.dataRenderer = [[CCVolumeDataChartRenderer alloc] initWithViewHandler:self.viewPixelHandler transform:self.transformer DataProvider:self];
    }
    return self;
}

- (CCKLineChartData *)klineChartData {
    return (CCKLineChartData *)self.data;
}

@end
