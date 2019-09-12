//
//  CCDefaultXAxisRenderer.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/9/12.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCProtocolAxisRenderer.h"
#import "CCDefaultXAxis.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCDefaultXAxisRenderer : NSObject <CCProtocolAxisRenderer>

@property (nonatomic, weak) CCDefaultXAxis *axis;


/**
 数据集x轴的值传给渲染层, 渲染层负责更新与之关联的axis中对应的值
 
 @param entities 显示在x轴上的字符串数组
 */
- (void)processAxisEntities:(NSArray<NSString *> *) entities;


@end

NS_ASSUME_NONNULL_END
