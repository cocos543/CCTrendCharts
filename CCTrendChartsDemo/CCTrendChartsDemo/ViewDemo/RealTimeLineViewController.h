//
//  RealTimeLineViewController.h
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "BaseViewController.h"
#import "NetworkHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface RealTimeLineViewController : BaseViewController

@property (nonatomic, strong) CCSingleEventManager *eventManager;

@end

NS_ASSUME_NONNULL_END
