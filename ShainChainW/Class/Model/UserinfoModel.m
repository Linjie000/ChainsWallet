//
//  UserinfoModel.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "UserinfoModel.h"
#import "marketModel.h"

@implementation UserinfoModel
static UserinfoModel *_ModelClass;

+(UserinfoModel *)shareManage
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        _ModelClass = [[UserinfoModel alloc]init];
        _ModelClass.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    });
    return _ModelClass;
}

- (void)setWalletType:(SCWALLETTYPE)walletType
{
    _walletType = walletType;
    NSString *name = @"";
    NSString *enname = @"";
    NSString *coinType = @"";
    
    if (walletType==BTC_WALLET_TYPE) {
        name = @"BTC";
        enname = @"BitCoin";
        coinType = @"0";
    }
    if (walletType==ETH_WALLET_TYPE) {
        name = @"ETH";
        enname = @"Ether";
        coinType = @"60";
    }
    if (walletType==TRON_WALLET_TYPE) {
        name = @"TRX";
        enname = @"Tron";
        coinType = @"195";
    }
    if (walletType==EOS_WALLET_TYPE) {
        name = @"EOS";
        enname = @"EOS";
        coinType = @"194";
    }
    if (walletType==IOST_WALLET_TYPE) {
        name = @"IOST";
        enname = @"IOST";
        coinType = @"291";
    }
    if (walletType==ATOM_WALLET_TYPE) {
        name = @"ATOM";
        enname = @"ATOM";
        coinType = @"118";
    }
    _ModelClass.Namearray=[NSArray arrayWithObjects:name,nil];
    _ModelClass.englishNameArray=[NSArray arrayWithObjects:enname,nil];
    _ModelClass.coinTypeArray=[NSArray arrayWithObjects:coinType, nil];
    _ModelClass.PriveprefixTypeArray=[NSArray arrayWithObjects:@"-1",nil];
    _ModelClass.AddressprefixTypeArray=[NSArray arrayWithObjects:@"-1",nil];
    _ModelClass.recordTypeArray=[NSArray arrayWithObjects:@"1",nil];
    
}

@end
