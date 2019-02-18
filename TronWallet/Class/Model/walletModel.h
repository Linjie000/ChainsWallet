//
//  walletModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWWalletAccountClient.h"
NS_ASSUME_NONNULL_BEGIN

@interface walletModel : NSObject

@property(nonatomic,copy) NSString *portrait;//头像
@property(nonatomic,strong) NSNumber *ID;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *address;//钱包地址
@property(nonatomic,copy) NSString *password;//加密主私钥
@property(nonatomic,copy) NSString *tips;//密码提示信息
@property(nonatomic,copy) NSString *mnemonics;//加密助记词
@property(nonatomic,copy) NSString *isHide;//是否隐藏此钱包的余额 0.不隐藏  1.隐藏
//一个钱包可以有多个币种
@property(nonatomic,strong) NSMutableArray *coinArray;

//波场钱包
@property(nonatomic,strong) TWWalletAccountClient *tronClient;
@end

NS_ASSUME_NONNULL_END
