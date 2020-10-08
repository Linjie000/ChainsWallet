//
//  TRXClient.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/14.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TronTransactionsModel;
NS_ASSUME_NONNULL_BEGIN

@interface TRXClient : NSObject
+(void)startRequest;

//获取T兑人民币等 数据
+ (void)getExchangeRates:(NSString *)type coinName:(NSString *)coinname success:(void (^)(id responseObject))success;
//获取 Account
+ (void)getAccount:(TronAccount *)amount success:(void (^)(id responseObject))success;
//获取资源数据
+ (void)getAccountResource:(TronAccount *)amount success:(void (^)(AccountResourceMessage *netMessage))success;
//获取交易记录
+(void)loadTronTransferListWithIndex:(NSInteger)index success:(void (^)(NSArray *arr))success;
//转账 amount金额  address 转账地址
+ (void)reallySendAmount:(NSString *)amount toAddress:(NSString *)address handler:(void(^)(id response))handler;
//冻结
+ (void)freezeBalance:(NSInteger)blance freezeType:(NSInteger)type success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull))failure;
//解冻
+ (void)unfreezeType:(NSInteger)type success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull))failure;
//网络签名
+ (void)getTransactionSign:(TronTransactionSign *)transactionSign completion:(void(^)(id responseObject))completion;
@end

NS_ASSUME_NONNULL_END
