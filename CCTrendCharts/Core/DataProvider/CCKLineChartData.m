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
    for (CCTAIConfigItem *item in config.conf) {
        if ([item.dataSetClass conformsToProtocol:@protocol(CCProtocolTAIDataSet)]) {
            
            id<CCProtocolTAIDataSet> dataSet = [[item.dataSetClass alloc] initWithRawEntities:[[self dataSetWithName:kCCNameKLineDataSet] lastObject].entities N:item.N];
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
