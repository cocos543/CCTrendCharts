//
//  BarViewController.h
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/24.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CCTrendCharts;

NS_ASSUME_NONNULL_BEGIN

@interface BarViewController : UIViewController <CCChartViewDataSource, CCChartViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

NS_ASSUME_NONNULL_END
