//
//  CCTAIConfig.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/11/29.
//  Copyright © 2019 Cocos. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "CCProtocolTAIDataSet.h"

NS_ASSUME_NONNULL_BEGIN

/// 指标配置
///
/// 根据配置的指标信息, 绘制和计算对应的指标
@interface CCTAIConfig : NSObject

- (instancetype)initWithConfig:(NSDictionary<NSString *, NSArray *> *)config;


/// 配置指标信息
///
/// 格式: 配置对应数据集类名为key, value的内容表示对应的具体指标.
/// 比如配置 @{@"CCLineMADataSet", @[5, 10, 20, 60]}
/// 表示遇到CCLineMADataSet数据集时, 分别绘制N为5, 10, 20, 60的线形图
@property (nonatomic, strong) NSDictionary<NSString *, NSArray *> *conf;

@end

NS_ASSUME_NONNULL_END
