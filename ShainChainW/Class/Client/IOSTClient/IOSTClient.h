//
//  IOSTClient.h
//  ShainChainW
//
//  Created by 闪链 on 2019/5/8.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger , IOSTTransactionType) {
    IOSTTransactionTransfer = 0 ,  //转账
    IOSTTransactionBuyRam ,   //买 Ram
    IOSTTransactionSellRam ,  //卖 Ram
    IOSTTransactionPledge ,   //抵押 iost
    IOSTTransactionUnpledge   //赎回 iost
};

@class IOSTAccount;
@class IOSTAccounts;
@class IOSTBalance;
@class IOSTRAMInfo;
@class IOSTTransResult;
@interface IOSTClient : NSObject
//创建IOST账号公私钥
+ (void)iost_createAccount_lib:(void(^)(NSString *privatekey,NSString *publickey))handle;

+ (void)iost_createAccount:(void(^)(NSString *privatekey,NSString *publickey))handle;

//私钥转公钥
+ (NSString *)iost_getPublicByPrivateKey:(NSString *)privatekey;

//根据公钥获取账号信息
+ (void)iost_getAccountMessageWithPublicKey:(NSString *)publickey handle:(void(^)(NSArray *models,BOOL success))handle;

//根据账号名获取账号信息
+ (void)iost_getAccount:(NSString *)account handle:(void(^)(IOSTAccount *account))handle;

//获取余额
+ (void)iost_getBalance:(NSString *)account token:(NSString *)token handle:(void(^)(IOSTBalance *IOSTBalance))handle;

//转账
+ (void)iost_sendToAssress:(NSString *)toAddress fromAddress:(NSString *)fromAddress money:(NSString *)money token:(NSString *)token memo:(NSString *)memo transactionType:(IOSTTransactionType)type walletPassword:(NSString *)pwd  block:(void(^)(IOSTTransResult *result))block;

//获取全网ram 信息 单价等
+ (void)iost_getRamInfoHandle:(void(^)(IOSTRAMInfo *ramInfo))handle;

//获取账号交易记录
+ (void)iost_getAccount:(NSString *)account page:(NSInteger)page transferList:(void(^)(NSArray *transferList))handle;

/**
  sdk 转账/交易
  */
+ (void)iost_sendToAssress:(NSString *)toAddress
               fromAddress:(NSString *)fromAddress
                     money:(NSString *)money
                     token:(NSString *)token
                      memo:(NSString *)memo
                  contract:(NSString *)contract
          walletPrivateKey:(NSString *)privateKey
                     block:(void(^)(IOSTTransResult *result))block;

/**
  sdk push transaction
  */
+ (void)iost_sendActionsParm:(NSArray *)actions
            walletPrivateKey:(NSString *)privateKey
                      wallet:(walletModel *)wallet
                       block:(void(^)(IOSTTransResult *result))block;

@end

