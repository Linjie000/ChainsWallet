//
//  UserinfoModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SCWALLETTYPE) {
    BTC_WALLET_TYPE = 0,
    ETH_WALLET_TYPE,
    EOS_WALLET_TYPE,
    TRON_WALLET_TYPE,
    IOST_WALLET_TYPE,
    ATOM_WALLET_TYPE
};

@interface UserinfoModel : NSObject
@property (nonatomic, strong) walletModel* wallet;
@property(nonatomic,assign) SCWALLETTYPE walletType; 
@property(nonatomic,strong) NSArray*Namearray;
@property(nonatomic,strong) NSArray*englishNameArray;//币种英文全称
@property(nonatomic,strong) NSArray*coinTypeArray;//存储支持的币种cointype
@property(nonatomic,strong) NSArray*PriveprefixTypeArray;//比特币系列增加整型的prefix参数，用于衍生代币的地址前缀，其它币暂时可任意值
@property(nonatomic,strong) NSArray*AddressprefixTypeArray;//比特币系列增加整型的prefix参数，用于衍生代币的地址前缀，其它币暂时可任意值]//地址前缀
@property(nonatomic,strong) NSArray*recordTypeArray;//存储支持的币种交易类型
@property(nonatomic,strong) AppDelegate *appDelegate;
+(UserinfoModel *)shareManage;
-(void)reloadLocalDataWithWallet:(walletModel*)model;
@property (nonatomic,strong) NSMutableArray *marketArray;//行情数组
@property (nonatomic,strong) NSMutableArray *dataArray;//数据源

@end

NS_ASSUME_NONNULL_END
