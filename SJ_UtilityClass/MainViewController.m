//
//  MainViewController.m
//  SJ_UtilityClass
//
//  Created by SPIREJ on 16/7/7.
//  Copyright © 2016年 SPIREJ. All rights reserved.
//

#import "MainViewController.h"
#import "CountdownViewController.h"
#import "AttributedStringVC.h"
#import "VerifyViewController.h"
#import "EKeventViewController.h"
#import "ArchiveViewController.h"

#define cellHeight 70

#define kLabelTitles @[@"1- 倒计时", @"2- 富文本处理字符串", @"3- 校验类", @"4- 日历提醒", @"5- 归档"]
#define kDetialLabelText @[@"CountdownViewController", @"AttributedStringVC", @"VerifyViewController", @"EKeventViewController",@"ArchiveViewController"]

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, copy)NSMutableArray *labelTextArray;
@property(nonatomic, copy)NSMutableArray *DetailLabelTextArray;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"主页";
    
    [self labelTextArray];
    [self DetailLabelTextArray];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
    }
    return _tableView;
}
- (NSMutableArray *)labelTextArray{
    if (!_labelTextArray) {
        _labelTextArray = [NSMutableArray arrayWithArray:kLabelTitles];
    }
    return _labelTextArray;
}
- (NSMutableArray *)DetailLabelTextArray{
    if (!_DetailLabelTextArray) {
        _DetailLabelTextArray = [NSMutableArray arrayWithArray:kDetialLabelText];
    }
    return _DetailLabelTextArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _labelTextArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifily = @"cellIdentifily";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifily];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifily];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _labelTextArray[indexPath.row];
    cell.detailTextLabel.text = _DetailLabelTextArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            CountdownViewController *countdownVC = [[CountdownViewController alloc] init];
            [self.navigationController pushViewController:countdownVC animated:YES];
        }
            break;
        case 1:{
            AttributedStringVC *attVC = [[AttributedStringVC alloc] init];
            [self.navigationController pushViewController:attVC animated:YES];
        }
            break;
        case 2: {
            VerifyViewController *verifyVC = [[VerifyViewController alloc] init];
            [self.navigationController pushViewController:verifyVC animated:YES];
        }
            break;
        case 3:{
            EKeventViewController *ekeventVC = [[EKeventViewController alloc] init];
            [self.navigationController pushViewController:ekeventVC animated:YES];
        }
            break;
        case 4:{
            ArchiveViewController *archiveVC = [[ArchiveViewController alloc] init];
            [self.navigationController pushViewController:archiveVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
