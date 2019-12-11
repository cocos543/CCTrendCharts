//
//  MainTableViewController.m
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/6.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "MainTableViewController.h"
#import "KLineViewController.h"
#import "VolumeViewController.h"
#import "RealTimeLineViewController.h"

#import "NetworkHelper.h"

@interface MainTableViewController ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *demoArray;
@property (nonatomic, strong) NSArray *sectionTitleArray;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Demo(金融数据来自雪球)";
    self.titleArray = @[@"K线图", @"交易量图", @"分时图", @"指标线形图", @"多种数据集的合成图", @"组合图", @"其他类型开发中..."];
    self.demoArray = @[@"Yunex交易所", @"涨乐富", @"富途牛牛", @"招商证券", @"陆续添加中..."];
    self.sectionTitleArray = @[@"各类趋势图", @"各平台的渲染器"];
    
    [NetworkHelper share];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.titleArray.count;
    }
    return self.demoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.titleArray[indexPath.row];
    }else {
        cell.textLabel.text = self.demoArray[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIViewController *vc;
        if (indexPath.row == 0) {
            vc = [[KLineViewController alloc] init];
        }else if (indexPath.row == 1) {
            vc = [[VolumeViewController alloc] init];
        }else if (indexPath.row == 2) {
            vc = [[RealTimeLineViewController alloc] init];
        }
        vc.title = self.titleArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
    }
    
}

#pragma mark - DataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 200, 20)];
    label.text = self.sectionTitleArray[section];
    label.font = [UIFont boldSystemFontOfSize:14];
    [view addSubview:label];
    
    return view;
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
