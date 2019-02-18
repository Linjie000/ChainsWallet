//
//  SCTransferController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCTransferController.h"
#import "SCTransferTypeCell.h"
#import "SCTransferAddressCell.h"
#import "SCTransferFootView.h"
#import "SCCommonBtn.h"
#import "SCWalletEnterView.h"
#import "TRXClient.h"

@interface SCTransferController ()
<UITableViewDelegate,UITableViewDataSource>
{
    SCTransferTypeCell *_transferTypeCell;
    SCTransferAddressCell *_transferAddressCell;
}
@property(strong ,nonatomic) UITableView *tableView;


@end

@implementation SCTransferController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"转账");
    [self subViews];

    [self addNotification];
}

- (void)addNotification
{
    //trx 钱包
    [self addNotificationForName:kAccountUpdateNotification response:^(NSDictionary * _Nonnull userInfo) {
        TronAccount *model = [userInfo objectForKey:@"Account"];
        //更新界面
        _transferTypeCell.balanceLab.text = [NSString stringWithFormat:@"%@ %.2f %@",LocalizedString(@"余额："),model.balance/kDense,@"TRX"];
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.fd_fullscreenPopGestureRecognizer setEnabled:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.fd_fullscreenPopGestureRecognizer setEnabled:YES];
}

- (void)subViews
{
    SCCommonBtn *commonBtn = [SCCommonBtn createCommonBtnText:LocalizedString(@"下一步")];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-commonBtn.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = SCGray(245);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    if (![self.model.brand isEqualToString:@"TRX"]) {
        _tableView.tableFooterView = [SCTransferFootView new];
    }
    [self.view addSubview:_tableView];
    
    
    commonBtn.bottom = self.view.height-NAVIBAR_HEIGHT;
    [self.view addSubview:commonBtn];
    [commonBtn setTapActionWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self transactionAction];
        });
    }];
    
}

#pragma mark - 转账
- (void)transactionAction
{
    NSString *price = _transferTypeCell.priceTF.text;
    NSString *address = _transferAddressCell.addressTF.text;
    if ([price floatValue]<=0) {
        [TKCommonTools showToast:LocalizedString(@"转账金额需大于0")];
        return;
    }
    if ([RewardHelper isBlankString:address]) {
        [TKCommonTools showToast:LocalizedString(@"请输入地址")];
        return;
    }
    //输入密码
    SCWalletEnterView *ev = [SCWalletEnterView shareInstance];
    ev.title = LocalizedString(@"请输入密码");
    ev.placeholderStr = LocalizedString(@"密码");
    [ev setReturnTextBlock:^(NSString *showText) {
        walletModel*wallet= [[walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]] lastObject];
        if ([showText isEqualToString:wallet.password]) {
            //密码正确 TRX 转账
            [TRXClient reallySendAmount:price toAddress:address];
        }
        else
        {
            [TKCommonTools showToast:LocalizedString(@"密码错误")];
        }
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        SCTransferTypeCell *cell = [[SCTransferTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCTransferTypeCell"];
        _transferTypeCell = cell;
        cell.model = self.model;
        return cell;
    }
    if (indexPath.section==1) {
        SCTransferAddressCell *cell = [[SCTransferAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCTransferAddressCell"];
        _transferAddressCell = cell;
//        cell.model = self.model;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return TYPE_HEIGHT;
    }
    return ADDRESS_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

@end
