//
//  BrowserTableController.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BrowserTableController.h"
#import "TKModuleWebViewController.h"
#import "BrowserCell.h"
#import "BrowserModel.h"
#import "BrowserWebController.h"
#import "BrowserManager.h"
#import "DAppDetailViewController.h"
#import "SCChooseWalletView.h"
#import "SCWalletTipView.h"
#import "SCImportEOSController.h"

@interface BrowserTableController ()<SCChooseWalletViewDelegate>
{
    NSInteger choose_dapp_index;
}
@end

@implementation BrowserTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = 0;
    self.fd_prefersNavigationBarHidden = YES;
    self.tableView.tableHeaderView = [UIView new];
}
 
- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
    if (self.dataCountBlock) {
        self.dataCountBlock(self.dataArray.count);
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrowserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrowserCell"];
    if (!cell) {
        cell = [[BrowserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BrowserCell"];
    }
    if (self.dataArray.count)
        cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    //是否有eos 账号
    NSArray *walletArr= [walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"ID"],[NSObject bg_sqlValue:@(194)]]];
    if (![wallet.ID isEqualToNumber:@(194)]) { 
        SCWalletTipView *tipview = [SCWalletTipView shareInstance];
        tipview.title = LocalizedString(@"提示");
        tipview.detailStr = walletArr.count?LocalizedString(@"请切换EOS账号"):LocalizedString(@"请导入EOS账号");
        [tipview setReturnBlock:^{
            if (walletArr.count) {
                SCChooseWalletView *walletView = [SCChooseWalletView shareInstance];
                walletView.delegate = self;
            }else
            {
                SCImportEOSController *scimport = [SCImportEOSController new];
                scimport.isChoose = YES;
                [self.navigationController pushViewController:scimport animated:YES];
            }
            
        }];
        return;
    }
    choose_dapp_index = indexPath.row;
    [self go_dapp_index];
}

#pragma mark - 选择钱包
- (void)SCChooseWalletViewSelectWallet:(walletModel *)walletModel
{
    WeakSelf(weakSelf);
    [self addNotificationForName:KEY_SCWALLET_TYPE_END response:^(NSDictionary * _Nonnull userInfo) {
        [weakSelf go_dapp_index];
        [weakSelf removeNotificationForName:KEY_SCWALLET_TYPE_END];
    }];
    [self postNotificationForName:KEY_SCWALLET_TYPE userInfo:@{@"wallet":walletModel}]; 
}

- (void)go_dapp_index
{
    DAppDetailViewController *webview = [DAppDetailViewController new];
    BrowserModel *browserModel = (BrowserModel *)self.dataArray[choose_dapp_index];
    webview.model = browserModel;
    [self.navigationController pushViewController:webview animated:YES];
}

@end
