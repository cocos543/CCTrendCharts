//
//  CCMain.m
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/5.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCMain.h"
#import "CCKLineChartView.h"

@implementation CCMain

- (void)hello {
    printf("hello CCMain3 ~\n");
    
    CCKLineChartView *view = [[CCKLineChartView alloc] init];
    //view.yAxis = [[CCDefualtYAxis alloc] init];
    NSLog(@"%@", view);
    NSLog(@"%@", view.yAxis);
    
    
}

- (void)hello2 {
    printf(__func__);
}

@end
