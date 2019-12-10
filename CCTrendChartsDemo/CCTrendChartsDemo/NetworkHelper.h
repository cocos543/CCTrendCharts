//
//  NetworkHelper.h
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/10.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// 便捷请求网络
@interface NetworkHelper : NSObject

+ (instancetype)share;

@property (nonatomic, strong) NSURLSession *session;

@end

NS_ASSUME_NONNULL_END
