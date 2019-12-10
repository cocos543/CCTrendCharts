//
//  NetworkHelper.m
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/10.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "NetworkHelper.h"

@interface NetworkHelper ()

@end

@implementation NetworkHelper
- (instancetype)init {
    self = [super init];
    if (self) {
        [self _configAPINetwork];
    }
    return self;
}

+ (instancetype)share {
    static NetworkHelper *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[NetworkHelper alloc] init];
    });
    return obj;
}


- (void)_configAPINetwork {
    self.session    = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    [[self.session dataTaskWithURL:[NSURL URLWithString:@"https://www.xueqiu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    }] resume];
    
//        如果无法访问接口, 可以通过下面手动设置cookie, cookie的值可以用浏览器访问一下雪球官网得到~
//        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
//        [cookieJar setCookie:[NSHTTPCookie cookieWithProperties:@{
//            NSHTTPCookieDomain: @".xueqiu.com",
//            NSHTTPCookiePath: @"/",
//            NSHTTPCookieName: @"xq_a_token",
//            NSHTTPCookieValue: @"5e0d8a38cd3acbc3002589f46fc1572c302aa8a2",
//            NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:60 * 60]
//        }]];
//
//        [cookieJar setCookie:[NSHTTPCookie cookieWithProperties:@{
//            NSHTTPCookieDomain: @".xueqiu.com",
//            NSHTTPCookiePath: @"/",
//            NSHTTPCookieName: @"xqat",
//            NSHTTPCookieValue: @"5e0d8a38cd3acbc3002589f46fc1572c302aa8a2",
//            NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:60 * 60]
//        }]];
//
//        [cookieJar setCookie:[NSHTTPCookie cookieWithProperties:@{
//            NSHTTPCookieDomain: @".xueqiu.com",
//            NSHTTPCookiePath: @"/",
//            NSHTTPCookieName: @"xq_r_token",
//            NSHTTPCookieValue: @"670668eda313118d7214487d800c21ad0202e141",
//            NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:60 * 60]
//        }]];
}

    
@end
