//
//  TWWalletAccountClient.h
//  TronWallet
//
//  Created by chunhui on 2018/5/24.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWEllipticCurveCrypto.h"
#import "TronAccount.h"
#import "TronTransaction.h"
#import "TronAccount.h"

typedef NS_ENUM( NSInteger,TWWalletType) {
    TWWalletDefault = 0, //正常钱包
    TWWalletCold   = 1,//冷钱包
    TWWalletAddressOnly  = 2,//只有地址
};

extern NSString *const kAccountUpdateNotification;

@interface TWWalletAccountClient : NSObject

@property(nonatomic , strong) NSNumber *own_id;

@property(nonatomic , strong) TronAccount *account;

@property(nonatomic , strong , readonly) TWEllipticCurveCrypto *crypto;

@property(nonatomic , assign) TWWalletType type;

+(instancetype)loadWallet;

+(NSString *)loadPwdKey;

-(NSString *)loadPriKey;


-(instancetype)initWithPriKey:(NSData *)priKey  type:(TWWalletType)type;

-(instancetype)initWithGenKey:(BOOL)genKey type:(TWWalletType)type;

-(instancetype)initWithPriKeyStr:(NSString *)priKey  type:(TWWalletType)type;

-(instancetype)initWithAddress:(NSString *)address;

-(void)clear;

-(void)store:(NSString *)password;

-(NSData *)address;

-(NSString *)base58PriKey;

-(NSString *)base58OwnerAddress;

-(void)refreshAccount:(void(^)(TronAccount *account, NSError *error))completion;

-(BOOL)isRightPassword:(NSString *)pasword;

-(TronTransaction *)signTransaction:(TronTransaction *)transaction;

- (void)getAccountNetWithRequest:(void(^)(AccountNetMessage *netMessage, NSError *error))completion;

- (void)getAccountResourceWithRequest:(void(^)(AccountResourceMessage *netMessage, NSError *error))completion;

 


@end
