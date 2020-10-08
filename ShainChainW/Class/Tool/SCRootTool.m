//
//  SCRootTool.m
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/27.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import "SCRootTool.h"
#import "SCTabBarViewController.h"
#import "TWWalletAccountClient.h"
#import "SCEnterController.h"
#import "WalletNavViewController.h"
#import "SCWalletEnterView.h"
#import "AESCrypt.h"
@implementation SCRootTool

+ (void)creatCoins:(NSString*)coinName withEnglishName:(NSString*)englishName withCointype:(int)type withAddressprefix:(int)addressprefix withPriveprefix:(int)priveprefix withRecordtype:(NSString*)recordType withID:(NSNumber*)ID totalAmount:(NSString *)totalAmount   withWallet:(walletModel*)wallet contractAddress:(NSString *)contractAddress{
    coinModel*coin=[[coinModel  alloc]init];
    coin.brand=coinName;
    coin.englishName=englishName;
    coin.own_id=ID;
    coin.cointype=type;
    coin.Addressprefix=addressprefix;
    coin.Priveprefix=priveprefix;
    coin.recordType=recordType;
    coin.blockHeight=0;
    coin.usdPrice=@"0";
    coin.closePrice=@"0";
    coin.totalAmount=totalAmount;
    coin.contractAddress = contractAddress;
    if (![coin.brand isEqualToString:@"BTC"]&
        ![coin.brand isEqualToString:@"ETH"]&
        ![coin.brand isEqualToString:@"EOS"]&
        ![coin.brand isEqualToString:@"TRX"]&
        ![coin.brand isEqualToString:@"IOST"]&
        ![coin.brand isEqualToString:@"ATOM"])
    {
        coin.fatherCoin=[RewardHelper coinNameWithCoinNumber:wallet.ID];
    }
    coin.address=wallet.address;
    //是否存在代币
    NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:coin.brand],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:ID]]];
    if (arr.count) {
        [coin bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:coin.brand],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:ID]]];
    }
    else
    {
        [coin bg_save];
    }
}

+ (void)chooseRootController:(UIWindow *)window
{
    //1.获取旧版本号
    NSString *oldVersion = [DEFAULTS objectForKey:@""];
    //2.获取当前版本号
    NSString *currentVersion  = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    
    if (![oldVersion isEqualToString:currentVersion]) {
 
//        TWWalletAccountClient *_walletClient = [TWWalletAccountClient loadWallet];
        if (![walletModel bg_findAll:nil].count) {
            WalletNavViewController *navController = [[WalletNavViewController alloc] initWithRootViewController:[SCEnterController new]];
            window.rootViewController = navController;
        }else
        {
            //主界面
            SCTabBarViewController *main = [SCTabBarViewController new];
            window.rootViewController = main;
            window.backgroundColor = [UIColor whiteColor];
            [window makeKeyAndVisible];
        }
    }else{
        //新特性界面
 
        window.backgroundColor = [UIColor whiteColor];
        [window makeKeyAndVisible];
    }
}

+ (void)delectWalletWithID:(NSNumber *)walletid handle:(void(^)(BOOL result))handle
{
    SCWalletEnterView *se = [SCWalletEnterView shareInstance];
    se.title = LocalizedString(@"请输入密码");
    se.placeholderStr = LocalizedString(@"密码");
    [se setReturnTextBlock:^(NSString *showText) {
        [SVProgressHUD showWithStatus:LocalizedString(@"正在删除身份...")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BOOL success = [walletModel bg_delete:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentOperationWalletID]]]];
            [SVProgressHUD dismiss];
            if (success) {
                [self postNotificationForName:KEY_SCWALLET_EDITED userInfo:@{}];
            }
            handle(success);
        });
    }];
}

+ (void)creatWallet
{
    NSArray * arr = [walletModel bg_findAll:nil];
    walletModel*wallet=[arr lastObject];
    [UserinfoModel shareManage].walletType = TRON_WALLET_TYPE;
    NSArray *Namearray=[UserinfoModel shareManage].Namearray;
    NSArray *typeArray=[UserinfoModel shareManage].coinTypeArray;
    NSArray *recordTypeArray=[UserinfoModel shareManage].recordTypeArray;
    NSArray *AddressprefixArray=[UserinfoModel shareManage].AddressprefixTypeArray;
    NSArray *PriveprefixArray=[UserinfoModel shareManage].PriveprefixTypeArray;
    NSArray *englishNameArray=[UserinfoModel shareManage].englishNameArray;
    
    TWWalletAccountClient *client = [TWWalletAccountClient loadWallet];
    client.own_id = wallet.bg_id;
    [client bg_save];
    
    for (int i=0; i<Namearray.count; i++) {
        [self creatCoins:Namearray[i] withEnglishName:englishNameArray[i] withCointype:[typeArray[i] intValue] withAddressprefix:[AddressprefixArray[i] intValue] withPriveprefix:[PriveprefixArray[i] intValue]  withRecordtype:recordTypeArray[i] withID:wallet.bg_id totalAmount:@"0.00" withWallet:wallet contractAddress:@""];
    }
}

//防止创建过程中 退出应用
+ (void)checkSystemWalletCreate
{
    NSArray *walletArr= [walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"isSystem"],[NSObject bg_sqlValue:@(1)]]];
    for (walletModel *model in walletArr) {
        if (IsStrEmpty(model.address)) {
            [(AppDelegate *)ShareApplicationDelegate reset];
        }
    }
}

@end
