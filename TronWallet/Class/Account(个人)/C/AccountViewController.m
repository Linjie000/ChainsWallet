//
//  AccountViewController.m
//  SCWallet
//
//  Created by zaker_sink on 2018/12/7.
//  Copyright © 2018 zaker_sink. All rights reserved.
//

#import "AccountViewController.h"
#import "SCWalletView.h"
#import "Colours.h"
#import "SCAccountCell.h"
#import "SCAccountHeadView.h"
//#import "SCDailyWalletController.h"
#import "SCMsgCenterController.h"
#import "SCFaceBackController.h"
#import "SCAddressBookController.h"
#import "SCMyIDController.h"
#import "SCChooseLgController.h"
#import "WalletNavViewController.h"
#import "SCWalletMController.h"

@interface AccountViewController ()
<UITableViewDelegate,UITableViewDataSource,SCAccountHeadViewDelegate>
@property(strong, nonatomic) UITableView *tableView;

@property(strong, nonatomic) NSArray *functionImgArray;
@property(strong, nonatomic) NSArray *functionTextArray;
@end

@implementation AccountViewController

- (NSArray *)functionImgArray
{
    if (!_functionImgArray) {
        _functionImgArray = @[@"使用设置",@"帮助与反馈",@"用户协议"];
    }
    return _functionImgArray;
}

- (NSArray *)functionTextArray
{
    if (!_functionTextArray) {
        _functionTextArray = @[@"钱包管理",@"多语言切换",@"问题反馈"];
    }
    return _functionTextArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fd_prefersNavigationBarHidden = YES;
    [self subViews];
}

- (void)subViews{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.contentInset = UIEdgeInsetsMake((NAVIBAR_HEIGHT>64?-44:-20), 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = 0;
    tableView.backgroundColor = SCGray(245);
    tableView.bounces = NO;
    _tableView = tableView;
    //顶部视图
    SCAccountHeadView *shv = [SCAccountHeadView new];
    shv.headViewDelegate = self;
    tableView.tableHeaderView = shv;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sc"];
    if (!cell) {
        cell = [[SCAccountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sc"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.image = IMAGENAME(self.functionImgArray[indexPath.row]);
    cell.funStr = self.functionTextArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.functionTextArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushToController:indexPath.row];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]animated:YES];
}

- (void)pushToController:(NSInteger)row
{
    UIViewController *vc = nil;
    if (row==0) {
        SCWalletMController *wc = [SCWalletMController new];
        wc.typeArray = @[@"BTC",@"ETH"];
        [self.navigationController pushViewController:wc animated:YES];
    }
    if (row==1) {
        SCChooseLgController *sc = [SCChooseLgController new];
        [self.navigationController pushViewController:sc animated:YES];
    }
    if (row==2) {
        SCFaceBackController *sc = [SCFaceBackController new];
        [self.navigationController pushViewController:sc animated:YES];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SCAccountHeadViewDelegate 地址本 消息 查看个人信息
- (void)SCAccountHeadViewClick:(NSInteger)tag
{
    if (tag==0) {
        SCAddressBookController *sc = [SCAddressBookController new];
        [self.navigationController pushViewController:sc animated:YES];
    }
    if (tag==1) {
        SCMsgCenterController *sc = [SCMsgCenterController new];
        [self.navigationController pushViewController:sc animated:YES];
    }
    if (tag==2) {
        SCMyIDController *sc = [SCMyIDController new];
        [self.navigationController pushViewController:sc animated:YES];
    }
}

@end
