//
//  BaseViewController.h
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CCTrendCharts;

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

- (void)loadDataWithStokeCode:(NSString *)code time:(NSInteger)time;

- (IBAction)clickBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

// 已获取的全部数据
@property (nonatomic, strong, nullable) NSArray *chartDataArr;

@end

NS_ASSUME_NONNULL_END
