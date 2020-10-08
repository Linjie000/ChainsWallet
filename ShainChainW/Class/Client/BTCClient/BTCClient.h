//
//  BTCClient.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/16.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTCClient : NSObject

//导入
+(void)importPrivateKey:(NSString *)privateKey
                success:(void(^)(NSString *private,NSString *address))successblock
                  error:(void(^)(void))errorblock;
//导入助记词
+(void)importMnemonic:(NSString *)string
              success:(void(^)(NSString *private,NSString *address))successblock
                error:(void(^)(void))errorblock;
//获取btc余额
+ (void)getAddressBalance:(NSString *)address handler:(void (^)(NSError * _Nullable error))handler;

//转账
+(void)sendToAddress:(NSString *)toAddress money:(NSString *)money fromAddress:(NSString *)fromAddress privateKey:(NSString *)privateKey fee:(NSInteger)fee block:(void(^)(NSString *hashStr,BOOL suc))block;

//查询交易记录
+(void)getTxlistWithAddress:(NSString *)address
                   withPage:(NSInteger)page
                      block:(void(^)(NSArray *array,BOOL suc))block;
@end

NS_ASSUME_NONNULL_END
