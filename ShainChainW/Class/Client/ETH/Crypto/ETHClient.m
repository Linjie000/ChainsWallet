//
//  ETHClient.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "ETHClient.h"
#import "BTCData.h"
#import "HSEther.h"
#import <ethers/Provider.h>
#import "RequestManager.h"
#import "NSObject+Extension.h"
#import "ETHTxlistModel.h"

@implementation ETHClient

+ (void)getEtnPrivateKey:(Account *)account password:(NSString *)pwd block:(void(^)(NSString *address,NSString *privateKey,NSString *keyStore))block
{
    [account encryptSecretStorageJSON:pwd callback:^(NSString *json) {
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        //地址
        NSString *addressStr = [NSString stringWithFormat:@"0x%@",dic[@"address"]];
        //私钥
        NSString *privateKeyStr = BTCHexFromData(account.privateKey);
        //助记词account.mnemonicPhrase
        //助记keyStore 就是json字符串
        
        block(addressStr,privateKeyStr,json);
    }];
}
 
+ (void)getAddressBalance:(NSString *)address handler:(void (^)(NSError * _Nullable))handler
{
    NSString *url = [NSString stringWithFormat:@"https://mainnet.infura.io/v3/f78f31fdc293426187f8a2a7230fbe67"];
    NSDictionary *param = @{@"jsonrpc":@"2.0",
                            @"method":@"eth_getBalance",
                            @"params": @[address, @"latest"],
                            @"id":@(1)
                            };
    [RequestManager post:url parameters:param success:^(id  _Nonnull responseObject) {
        if (responseObject) {
            NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([responseObject[@"result"] UTF8String],0,16)];
//            NSString *blanceStr = BTCHexFromData([NSData dataWithHexString:temp10]);
            NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@ ",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"ETH"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
            coinModel *model = [arr lastObject];
            CGFloat f = [temp10 floatValue]/kETHDense;
            model.totalAmount = [NSString stringWithFormat:@"%.6f",f];
            [model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"ETH"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
            handler(nil);
        }  
    } failure:^(NSError * _Nonnull error) {
        
    }];
 
}

+ (void)sendTransactionWithkeyStore:(NSString *)keyStore address:(NSString *)adderess password:(NSString *)pwd amount:(NSString *)amount gasPrice:(NSString *)gasPrice gasLimt:(NSString *)gasLimt block:(void(^)(NSString *hashStr,BOOL suc))block
{
    [HSEther hs_sendToAssress:adderess money:amount tokenETH:nil decimal:@"18" currentKeyStore:keyStore pwd:pwd gasPrice:gasPrice gasLimit:gasLimt block:^(NSString *hashStr, BOOL suc, HSWalletError error) {
        block(hashStr,suc); 
    }];
}

+ (void)getTransactionsByAddress:(NSString *)address handler:(void (^)(NSArray *result))result
{
    NSString *url = [NSString stringWithFormat:@"http://api.etherscan.io/api?module=account&action=txlist&address=%@&startblock=0&endblock=99999999&sort=asc&apikey=77AKCF8ZFHFG9DJ2ZQV67XTEH3381P3V6E",address];
    [RequestManager get:url parameters:@{} success:^(id  _Nonnull responseObject) {
        NSArray *results = responseObject[@"result"];
        NSMutableArray *resultArray = [NSMutableArray new];
        if (results.count) {
            for (NSDictionary *dic in results) {
                ETHTxlistModel *model = [ETHTxlistModel mj_objectWithKeyValues:dic];
                [resultArray addObject:model];
            }
        }
        result(resultArray);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
