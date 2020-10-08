//
//  ETHClient.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ethers/Account.h>
NS_ASSUME_NONNULL_BEGIN

@interface ETHClient : NSObject

+ (void)getEtnPrivateKey:(Account *)account password:(NSString *)pwd block:(void(^)(NSString *address,NSString *privateKey,NSString *keyStore))block;

//获取余额
+ (void)getAddressBalance:(NSString *)address handler:(void (^)(NSError * _Nullable error))handler;
//转账
+ (void)sendTransactionWithkeyStore:(NSString *)keyStore address:(NSString *)adderess password:(NSString *)pwd amount:(NSString *)amount gasPrice:(NSString *)gasPrice gasLimt:(NSString *)gasLimt block:(void(^)(NSString *hashStr,BOOL suc))block;
//获取交易记录
+ (void)getTransactionsByAddress:(NSString *)address handler:(void (^)(NSArray *result))result;
@end

NS_ASSUME_NONNULL_END
