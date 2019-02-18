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

@implementation SCRootTool

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

+ (void)creatWallet
{
    NSArray * arr = [walletModel bg_findAll:nil];
    walletModel*wallet=[arr lastObject];
    NSArray *Namearray=[UserinfoModel shareManage].Namearray;
    NSArray *typeArray=[UserinfoModel shareManage].coinTypeArray;
    NSArray *recordTypeArray=[UserinfoModel shareManage].recordTypeArray;
    NSArray *AddressprefixArray=[UserinfoModel shareManage].AddressprefixTypeArray;
    NSArray *PriveprefixArray=[UserinfoModel shareManage].PriveprefixTypeArray;
    NSArray *englishNameArray=[UserinfoModel shareManage].englishNameArray;
    for (int i=0; i<Namearray.count; i++) {
        [self creatCoins:Namearray[i] withEnglishName:englishNameArray[i] withCointype:[typeArray[i] intValue] withAddressprefix:[AddressprefixArray[i] intValue] withPriveprefix:[PriveprefixArray[i] intValue]  withRecordtype:recordTypeArray[i] withID:wallet.bg_id  withWallet:wallet];
    }
}

+(void)creatCoins:(NSString*)coinName withEnglishName:(NSString*)englishName withCointype:(int)type withAddressprefix:(int)addressprefix withPriveprefix:(int)priveprefix withRecordtype:(NSString*)recordType withID:(NSNumber*)ID   withWallet:(walletModel*)wallet{
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
    coin.addtime=[RewardHelper getNowTimeTimestamp];
    coin.totalAmount=@"0";
    if ([coin.brand isEqualToString:@"TRX"]) {
        coin.collect=1;//首页默认添加TRX
    }else{
        coin.collect=0;
    }
    if ([coin.brand isEqualToString:@"USDT"]) {
        coin.fatherCoin=@"BTC";
    }
    coin.address=wallet.address;
    NSLog(@"新建的地址--%@--%@--",coin.brand,coin.address);
    [coin bg_save];
}


@end
