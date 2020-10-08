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
@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSNumber *ID;
@property(nonatomic,copy) NSString *idname;//身份名
@property(nonatomic,copy) NSString *name;//钱包
@property(nonatomic,copy) NSString *address;//钱包地址
@property(nonatomic,copy) NSString *password;// 加密密码 加密后置空
@property(nonatomic,copy) NSString *tips;//密码提示信息
@property(nonatomic,copy) NSString *mnemonics;//加密助记词
@property(nonatomic,copy) NSString *isHide;//是否隐藏此钱包的余额 0.不隐藏  1.隐藏
@property(nonatomic,copy) NSNumber *isSystem;//0 1 是否系统创建
@property(nonatomic,copy) NSString *privateKey;//加密私钥
@property(nonatomic,copy) NSString *balance;//余额
@property(nonatomic) BOOL resourceOP;//资源管理
@property(nonatomic,copy) NSString *keyStore; //加密keyStore
//一个钱包可以有多个币种
@property(nonatomic,strong) NSMutableArray *coinArray;

//EOS
@property(nonatomic, copy) NSString *account_active_public_key;

@property(nonatomic, copy) NSString *account_owner_public_key;

@property(nonatomic, copy) NSString *account_active_private_key;

@property(nonatomic, copy) NSString *account_owner_private_key;
 
@end

NS_ASSUME_NONNULL_END
