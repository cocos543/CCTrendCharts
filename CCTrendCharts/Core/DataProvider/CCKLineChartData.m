//
//  CCKLineChartData.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/16.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCKLineChartData.h"

@implementation CCKLineChartData

- (void)notifyTAIConfigChange:(CCTAIConfig *)config {
    id<CCProtocolChartDataSet> klineDataSet = [[self dataSetWithName:kCCNameKLineDataSet] lastObject];
    if (!klineDataSet) {
         klineDataSet = [[self dataSetWithName:kCCVolumeChartDataSet] lastObject];
    }
    
    if (!klineDataSet) {
        return;
    }
    
    for (CCTAIConfigItem *item in config.conf) {
        if ([item.dataSetClass conformsToProtocol:@protocol(CCProtocolTAIDataSet)]) {
            id<CCProtocolTAIDataSet> dataSet = [[item.dataSetClass alloc] initWithRawEntities:klineDataSet.entities N:item.N];
            if (!dataSet) {
                continue;
            }
            
            dataSet.label = item.label;
            dataSet.color = item.color;
            dataSet.font  = item.font;
            
            [self.dataSets addObject:dataSet];
        }
    }
}

@end
