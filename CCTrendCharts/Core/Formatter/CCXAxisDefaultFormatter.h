//
//  CCXAxisDefaultFormatter.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolXAxisFormatterBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCXAxisDefaultFormatter : NSObject <CCProtocolXAxisFormatterBase>

- (instancetype)initWithAxis:(id<CCProtocolAxisBase>)axisInfo;

@end

NS_ASSUME_NONNULL_END
