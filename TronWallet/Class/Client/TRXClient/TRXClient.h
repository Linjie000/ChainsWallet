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

//获取TRX兑人民币等 数据
+ (void)getExchangeRates:(NSString *)type success:(void (^)(id responseObject))success;
//获取交易记录
+(void)loadTronTransferListWithIndex:(NSInteger)index success:(void (^)(NSArray *arr))success;
//转账 amount金额  address 转账地址
+ (void)reallySendAmount:(NSString *)amount toAddress:(NSString *)address;
@end

NS_ASSUME_NONNULL_END
