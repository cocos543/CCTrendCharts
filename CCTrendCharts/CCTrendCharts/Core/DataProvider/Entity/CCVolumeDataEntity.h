//
//  CCVolumeDataEntity.h
//  CCTrendCharts
//
//  Created by Cocos on 2019/12/3.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "CCKLineDataEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVolumeDataEntity : CCKLineDataEntity

- (instancetype)initWithKLineDataEntity:(CCKLineDataEntity *)entity;

@end

NS_ASSUME_NONNULL_END
