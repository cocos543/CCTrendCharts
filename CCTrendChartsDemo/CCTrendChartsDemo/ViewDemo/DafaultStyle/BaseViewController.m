//
//  BaseViewController.m
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/11.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadDataWithStokeCode:(NSString *)code time:(NSInteger)time {
    
}

- (IBAction)clickBtnAction:(id)sender {
    [self.view endEditing:YES];
    if (self.codeTextField.text != nil) {
        self.chartDataArr = nil;
        [self loadDataWithStokeCode:self.codeTextField.text time:(NSInteger)[NSDate.date timeIntervalSince1970] * 1000];
    }
}

- (IBAction)stockAction:(UISegmentedControl *)sender {
    NSArray *s = @[@"SH600519", @"SZ000001", @"01810", @"BABA"];
    self.codeTextField.text = s[sender.selectedSegmentIndex];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
