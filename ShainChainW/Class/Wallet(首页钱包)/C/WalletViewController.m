//
//  FirstViewController.m
//  SCWallet
//
//  Created by zaker_sink on 2018/12/7.
//  Copyright © 2018 zaker_sink. All rights reserved.
//

#import "WalletViewController.h"
#import "SCLeftNavView.h"
#import "SCWalletView.h"
#import "Colours.h"
#import "SCPropertyTableView.h"
#import "SCGuideOneView.h"
#import "SCScanController.h"
#import "SCPropertyHead.h"
#import "SCDailyWalletController.h"
#import "SCDailyWalletExistCell.h"
#import "SCAddAssetController.h"
#import "WalletNavViewController.h"
#import "SCTransferController.h"
#import "SCPropertyDetailController.h"
#import "EOSResourceController.h"
#import "TRXClient.h"
#import "ETHClient.h"
#import "EOS_Key_Encode.h"
#import "NSString+MD5.h"
#import "SCRootTool.h"

//test
#import "EOSAttackClient.h"
#import "CreateWalletTool.h"


@interface WalletViewController ()<SCPropertyTableViewDelegate>

@property (strong, nonatomic) SCPropertyTableView *propertyTableView;
@property (strong, nonatomic) SCLeftNavView* leftView;
@property (strong, nonatomic) SCPropertyHead *propertyHead;
@property (strong, nonatomic) NSMutableArray *dataArray; 
@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"钱包";
    
//    [SCRootTool checkSystemWalletCreate];
    
    [self setUpNaviBtn];
    
    [self subViews];
    
    [self addNotification];
    
    [self loadWallet];

//    [KeyWindow addSubview:[SCGuideOneView new]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - 设置导航栏按钮
- (void)setUpNaviBtn{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"扫一扫-icon"]  style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];

    self.navigationItem.rightBarButtonItems = @[rightItem];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    SCLeftNavView* leftView =  [[SCLeftNavView alloc] initWithFrame:CGRectMake(0, 0, 55, 23)];
    [leftView layout];
    _leftView = leftView;
    WeakSelf(weakSelf);
    [_leftView setTapActionWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf leftClick];
        });
    }];
    leftView.walletType = @" ";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItems = @[leftItem];
}

- (void)chooseDailyWallet
{
    SCDailyWalletController *dwc = [SCDailyWalletController new];
    dwc.canPost = YES;
//    [dwc setBlock:^(SCDailyWalletExistCell * _Nonnull cell) {
//        self.leftView.walletType = cell.typeLab.text;
//    }];
    WalletNavViewController *navi = [[WalletNavViewController alloc]initWithRootViewController:dwc];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)subViews{
    [self.view addSubview:self.propertyTableView];
    self.propertyHead = [SCPropertyHead shareInstance];
    self.propertyTableView.tableHeaderView = self.propertyHead;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadWallet];
    });
}

#pragma mark - 添加通知
- (void)addNotification
{
    WeakSelf(weakSelf);
    [self addNotificationForName:KEY_SCWALLET_ADDASSET response:^(NSDictionary * _Nonnull userInfo) {
        SCAddAssetController *sc = [SCAddAssetController new];
        [weakSelf.navigationController pushViewController:sc animated:YES];
    }];
    [self addNotificationForName:KEY_SCWALLET_EDITED response:^(NSDictionary * _Nonnull userInfo) {
        [SCPropertyHead shareInstance].wallet = [UserinfoModel shareManage].wallet;
    }];
    [self addNotificationForName:kAccountUpdateNotification response:^(NSDictionary * _Nonnull userInfo) {
        TronAccount *account = [userInfo objectForKey:@"Account"];
        [UserinfoModel shareManage].appDelegate.walletClient.account = account;
        //查找 TRX 币
        NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"TRX"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
        coinModel *model = [arr lastObject];
        if (account.frozen.count||account.account_resource) {
            Account_Frozen *frozen = account.frozen[0];
            model.freeze = [NSString stringWithFormat:@"%.1f",frozen.frozen_balance/kDense+account.account_resource.frozen_balance_for_energy.frozen_balance/kDense];
        } 
        //更新数据
        model.totalAmount = [NSString stringWithFormat:@"%.4f",(account.balance/kDense)];
        //查询TRX兑人民汇率
        [TRXClient getExchangeRates:@"cny" coinName:@"TRX" success:^(id  _Nonnull responseObject) {
            [weakSelf updateCoinDataWithResponse:responseObject coinModel:model];
        }];
    }];
 
    [self addNotificationForName:KEY_SCWALLET_TYPE response:^(NSDictionary * _Nonnull userInfo) {
        walletModel *walletModel = [userInfo objectForKey:@"wallet"];
        weakSelf.leftView.walletType = [RewardHelper coinNameWithCoinNumber:walletModel.ID];
        //切换钱包
        if (![walletModel.bg_id isEqualToNumber:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]) {
            [NSUserDefaultUtil PutNumberDefaults:CurrentWalletID Value:walletModel.bg_id];
            SCLog(@"===== id %@",walletModel.bg_id);
            [weakSelf loadWallet];
        }
    }];
}

- (void)updateCoinDataWithResponse:(id)responseObject coinModel:(coinModel *)model
{
    WeakSelf(weakSelf);
    NSDictionary *dic = (NSDictionary *)responseObject;
    NSString *close = [dic objectForKey:@"close"];
    model.closePrice = close;
    [model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:model.brand],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf TotalassetsCalculatedWithWallet:[UserinfoModel shareManage].wallet withtype:0];
        //更新coinmodel数据
        [weakSelf postNotificationForName:kcoinModelUpdateNotification userInfo:@{}];
    });
}

-(void)rightClick{
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    SCScanController *sc = [SCScanController new];
    sc.addressType = [RewardHelper typeNamecoin:[RewardHelper coinNameWithCoinNumber:wallet.ID]];
    WeakSelf(weakSelf);
    [sc setBlock:^(NSString *address, NSString *brand) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SCTransferController *sfc = [SCTransferController new];
            sfc.toAddress = address;
            sfc.brand = brand;
            WalletNavViewController *wn = [[WalletNavViewController alloc]initWithRootViewController:sfc];
            [weakSelf presentViewController:wn animated:YES completion:nil];
        });
    }];
    [self presentViewController:sc animated:YES completion:nil];
}

-(void)leftClick{
    [self chooseDailyWallet];
}

#pragma mark -- 计算总资产
-(void)TotalassetsCalculatedWithWallet:(walletModel*)wallet withtype:(int)type{
    [SCPropertyHead shareInstance].wallet = wallet;
    NSMutableArray *mArray =(NSMutableArray*)[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
    self.dataArray = mArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.propertyTableView.dataArray = self.dataArray;
    });
}

#pragma mark -- 点击代币 SCPropertyTableViewDelegate
- (void)propertySeleteTableView:(coinModel *)model
{
    SCPropertyDetailController *sc = [SCPropertyDetailController new];
    sc.brand = model.brand;
    [self.navigationController pushViewController:sc animated:YES];
}

#pragma make - lazyload
- (SCPropertyTableView *)propertyTableView
{
    if (!_propertyTableView) {
        _propertyTableView = [[SCPropertyTableView alloc]initWithFrame:
                              CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT)
                                                                 style:UITableViewStylePlain];
        _propertyTableView.propertyDelegate = self;
        _propertyTableView.separatorStyle = 0;
        _propertyTableView.tableFooterView = [UIView new];
    }
    return _propertyTableView;
}

- (void)loadWallet
{
    WeakSelf(weakSelf);
    if ([[walletModel bg_findAll:nil] count]>0) {
        //有钱包
        walletModel*wallet= [[walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]] lastObject];
        if (!wallet) {
            walletModel*model=[[walletModel bg_findAll:nil] objectAtIndex:0];
            [NSUserDefaultUtil PutNumberDefaults:CurrentWalletID Value:model.bg_id];//存储到本地
            wallet = model;
            [SCPropertyHead shareInstance].wallet = wallet;
        }else{
            [SCPropertyHead shareInstance].wallet = wallet;
        }
        if ([wallet.ID isEqualToNumber:@(195)]) {
            
            [UserinfoModel shareManage].walletType = TRON_WALLET_TYPE;
            [UserinfoModel shareManage].wallet=wallet;
            
            TWWalletAccountClient *walletClient = [[TWWalletAccountClient bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]] lastObject];
            [UserinfoModel shareManage].appDelegate.walletClient=walletClient;
            _leftView.walletType = @"TRX";
            dispatch_async(dispatch_get_main_queue(), ^{
                [self TotalassetsCalculatedWithWallet:wallet withtype:0];
            });
            [walletClient refreshAccount:^(TronAccount *account, NSError *error) {
                
            }];
        }
        if ([wallet.ID isEqualToNumber:@(0)]) {
            [UserinfoModel shareManage].walletType = BTC_WALLET_TYPE;
            [UserinfoModel shareManage].wallet=wallet;
            _leftView.walletType = @"BTC";
            
            [BTCClient getAddressBalance:wallet.address handler:^(NSError * _Nullable error) {
                //查询BTC兑人民汇率
                //查找 BTC 币
                NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"BTC"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
                coinModel *model = [arr lastObject];
                [TRXClient getExchangeRates:@"cny" coinName:@"BTC" success:^(id  _Nonnull responseObject) {
                    [self updateCoinDataWithResponse:responseObject coinModel:model];
                }];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self TotalassetsCalculatedWithWallet:wallet withtype:0];
            });
        }
        if ([wallet.ID isEqualToNumber:@(60)]) {
            [UserinfoModel shareManage].walletType = ETH_WALLET_TYPE;
            [UserinfoModel shareManage].wallet=wallet;
            _leftView.walletType = @"ETH";
            [ETHClient getAddressBalance:wallet.address handler:^(NSError * _Nullable error) {
                //查询ETH兑人民汇率
                //查找 ETH 币
                NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"ETH"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
                coinModel *model = [arr lastObject];
                [TRXClient getExchangeRates:@"cny" coinName:@"ETH" success:^(id  _Nonnull responseObject) {
                    [self updateCoinDataWithResponse:responseObject coinModel:model];
                }];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self TotalassetsCalculatedWithWallet:wallet withtype:0];
            });
        }
        
        if ([wallet.ID isEqualToNumber:@(194)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf TotalassetsCalculatedWithWallet:wallet withtype:0];
            });
            [UserinfoModel shareManage].walletType = EOS_WALLET_TYPE;
            [UserinfoModel shareManage].wallet=wallet;
            _leftView.walletType = @"EOS";
            [self eosCoinRefresh:wallet];
            [EOSClient getEOSTokenListAccountName:wallet.address handle:^(EOSTokenListModel * _Nonnull listModel) {
                [weakSelf eosCoinRefresh:wallet];
            }];
        }
        
        if ([wallet.ID isEqualToNumber:@(291)]) {
            [UserinfoModel shareManage].walletType = IOST_WALLET_TYPE;
            [UserinfoModel shareManage].wallet=wallet;
            _leftView.walletType = @"IOST";
            [IOSTClient iost_getBalance:wallet.address token:@"iost" handle:^(IOSTBalance *IOSTBalance) {
                NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"IOST"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
                coinModel *coinModel = [arr lastObject];
                [TRXClient getExchangeRates:@"cny" coinName:@"IOST" success:^(id  _Nonnull responseObject) {
                    [self updateCoinDataWithResponse:responseObject coinModel:coinModel];
                }];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self TotalassetsCalculatedWithWallet:wallet withtype:0];
            });
        }
        if ([wallet.ID isEqualToNumber:@(118)]) {
            [UserinfoModel shareManage].walletType = ATOM_WALLET_TYPE;
            [UserinfoModel shareManage].wallet=wallet;
            _leftView.walletType = @"ATOM";
            [ATOMClient atom_getBalanceWithAddress:@"" handle:^(ATOMBalance * _Nonnull ATOMBalance) {
                NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"ATOM"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
                coinModel *coinModel = [arr lastObject];
                [TRXClient getExchangeRates:@"cny" coinName:@"ATOM" success:^(id  _Nonnull responseObject) {
                    [self updateCoinDataWithResponse:responseObject coinModel:coinModel];
                }];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self TotalassetsCalculatedWithWallet:wallet withtype:0];
            });
        }
        [self postNotificationForName:KEY_SCWALLET_TYPE_END userInfo:@{}];
    }
}

- (void)eosCoinRefresh:(walletModel *)wallet
{
    [EOSClient GetEOSAccountRequestWithName:wallet.address handle:^(EOSAccount * _Nonnull eosAccount) {
        //查询EOS兑人民汇率
        NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"EOS"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
        coinModel *model = [arr lastObject];
        [TRXClient getExchangeRates:@"cny" coinName:@"EOS" success:^(id  _Nonnull responseObject) {
            [self updateCoinDataWithResponse:responseObject coinModel:model];
        }];
    }];
}

@end
