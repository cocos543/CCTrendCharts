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
    for (NSString *clsStr in config.conf.allKeys) {
        Class cls = NSClassFromString(clsStr);
        if ([cls conformsToProtocol:@protocol(CCProtocolTAIDataSet)]) {
            
            id<CCProtocolTAIDataSet> dataSet = [[cls alloc] initWithRawEntities:[[self dataSetWithName:kCCNameKLineDataSet] lastObject].entities N:0];
            
            [self.dataSets addObject:dataSet];
        }
    }
}


@end
