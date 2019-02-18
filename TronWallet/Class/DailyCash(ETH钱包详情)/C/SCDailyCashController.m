//
//  SCDailyCashController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/7.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCDailyCashController.h"
#import "SCReplacePicController.h"
#import "SCPWPromptController.h"
#import "SCExpKeyController.h"
#import "SCExpPriKController.h"
#import "SCDeriveWordsController.h"

#import "SCDailyWalletCell.h"
#import "SCDailyFunCell.h"
#import "SCWalletEnterView.h"

@interface SCDailyCashController ()
<UITableViewDelegate,UITableViewDataSource>
@property(strong ,nonatomic) NSArray *imgArray;
@property(strong ,nonatomic) NSArray *textArray;
@end

@implementation SCDailyCashController

- (NSArray *)imgArray
{
    if (!_imgArray) {
        _imgArray = @[@"密码提示信息",@"导出助记词",@"导出Keystore",@"导出私钥"];
    }
    return _imgArray;
}

- (NSArray *)textArray
{
    if (!_textArray) {
        _textArray = @[@"密码提示信息",@"导出助记词",@"导出Keystore",@"导出私钥"];
    }
    return _textArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"管理");
    [self subViews];
}

- (void)subViews{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = SCGray(244);
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        SCDailyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCDailyWalletCell"];
        if (!cell) {
            cell = [[SCDailyWalletCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCDailyWalletCell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (indexPath.section==1) {
        SCDailyFunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCDailyFunCell"];
        if (!cell) {
            cell = [[SCDailyFunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCDailyFunCell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.funStr = self.textArray[indexPath.row];
        cell.image = IMAGENAME(self.imgArray[indexPath.row]);
        return cell;
    }
    return [UITableViewCell new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return KWalletHeight;
    }
    return KFunHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) return 22;
    return 13;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]animated:YES];
    if (indexPath.section==0) {
        [self.navigationController pushViewController:[SCReplacePicController new] animated:YES];
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            [self.navigationController pushViewController:[SCPWPromptController new] animated:YES];
        }
        if (indexPath.row==1) {
            SCWalletEnterView *se = [SCWalletEnterView shareInstance];
            se.title = LocalizedString(@"请输入密码");
            se.placeholderStr = @"密码";
            
            [se setReturnTextBlock:^(NSString *showText) {
               [self.navigationController pushViewController:[SCDeriveWordsController new] animated:YES];
            }];
        }
        if (indexPath.row==2) {
            [self.navigationController pushViewController:[SCExpKeyController new] animated:YES];
        }
        if (indexPath.row==3) {
            [self.navigationController pushViewController:[SCExpPriKController new] animated:YES];
        }
    }
}

@end
