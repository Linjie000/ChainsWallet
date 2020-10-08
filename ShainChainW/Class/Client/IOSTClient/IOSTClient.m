//
//  IOSTClient.m
//  ShainChainW
//
//  Created by 闪链 on 2019/5/8.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "IOSTClient.h"
#import "BlinkEd25519.h"
#import "BTCBase58+Tests.h"

#import "IOSTAccounts.h"
#import "IOSTBalance.h"
#import "IOSTTransactionObject.h"
#import "IOSTChainInfo.h"
#import "IOSTRAMInfo.h"
#import "IOSTTransResult.h"
#import "IOSTTransListModel.h"

#import "AESCrypt.h"
#import "NSData+Hashing.h"

#import <ethers/SecureData.h>
#import <ethers/secp256k1.h>
#import <ethers/ecdsa.h>

#import <openssl/ecdsa.h>
#import "IOSTByteWriter.h"
#import "JKBigInteger.h"

#import <ethers/sha3.h>
#include "ge.h"
#include <string.h>
#import <CommonCrypto/CommonDigest.h>
#import "crypto_sign_ed25519.h"
#import "crypto_sign.h"
#define IOST_NODE @"http://18.209.137.246:30001/"


@implementation IOSTClient

+ (void)iost_createAccount_lib:(void(^)(NSString *privatekey,NSString *publickey))handle
{
    //生成随机公私钥
    unsigned char seed[32],publickey[32],privatekey[64];
    int i = crypto_sign_ed25519_keypair(publickey,privatekey);
    NSData * publickey_data= [NSData dataWithBytes:publickey length:32];
    NSData * privatekey_data= [NSData dataWithBytes:privatekey length:64];
    NSString *privatekey1 = BTCBase58StringWithData(privatekey_data);
    NSString *publickey1 = BTCBase58StringWithData(publickey_data);
    
    NSData *c_sk = BTCDataFromBase58(privatekey1);
    NSData *c_pk = BTCDataFromBase58(publickey1);
    
    //    crypto_sign(unsigned char *sm, unsigned long long *smlen_p,
    //                const unsigned char *m, unsigned long long mlen,
    //                const unsigned char *sk)
    //签名  0成功  -1失败
    NSData *message1 = [@"aia hsd fji h" dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char signature[64];
    int mlen = message1.length;
    int s = crypto_sign(signature,NULL,message1.bytes,mlen,privatekey);
    NSData * signature_data= [NSData dataWithBytes:signature length:64];
    
    //    [self testEd25519];
    //    [self testTransaction];
}

+ (void)iost_createAccount:(void(^)(NSString *privatekey,NSString *publickey))handle
{
    Ed25519Keypair *b = [BlinkEd25519 generateEd25519KeyPair];
    NSString *privatekey = BTCBase58StringWithData(b.privatekey);
    NSString *publickey = BTCBase58StringWithData(b.publickey);
    handle(privatekey,publickey);
}

+ (NSString *)iost_getPublicByPrivateKey:(NSString *)privatekey;
{
    return [BlinkEd25519 getPublicByPrivateKey:privatekey];
}

+ (void)iost_getAccountMessageWithPublicKey:(NSString *)publickey handle:(void(^)(NSArray *models,BOOL success))handle
{
    NSString *url = [NSString stringWithFormat:@"https://explorer.iost.io/iost-api/accounts/%@",publickey];
    [RequestManager get:url parameters:@{} success:^(id  _Nonnull responseObject) {
        if (![responseObject[@"code"] integerValue]) {
            NSArray *account = [IOSTAccounts mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"accounts"]];
            handle(account,YES);
        }else{
            handle(nil,NO);
        }
    } failure:^(NSError * _Nonnull error) {
        handle(nil,NO);
    }];
}

+ (void)iost_getAccount:(NSString *)account handle:(void(^)(IOSTAccount *account))handle
{
    NSString *url = [NSString stringWithFormat:@"%@getAccount/%@/true",IOST_NODE,account];
    [RequestManager get:url parameters:@{} success:^(id  _Nonnull responseObject) {
        IOSTAccount *account = [IOSTAccount mj_objectWithKeyValues:responseObject];
        handle(account);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

+ (void)iost_getBalance:(NSString *)account token:(NSString *)token handle:(void(^)(IOSTBalance *IOSTBalance))handle
{
    //    curl http://127.0.0.1:30001/getTokenBalance/admin/iost/true
    NSString *url = [NSString stringWithFormat:@"%@getTokenBalance/%@/%@/true",IOST_NODE,account,token?token:@"iost"];
    [RequestManager get:url parameters:@{} success:^(id  _Nonnull responseObject) {
        IOSTBalance *account = [IOSTBalance mj_objectWithKeyValues:responseObject];
        NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@ ",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"IOST"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
        coinModel *model = [arr lastObject];
        model.totalAmount = [account.balance stringByReplacingOccurrencesOfString:@"IOST" withString:@""];
        [model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"IOST"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
        handle(account);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

+ (void)getBlockInfo:(void(^)(IOSTChainInfo *IOSTChainInfo))block
{
    NSString *url = [NSString stringWithFormat:@"%@getChainInfo",IOST_NODE];
    [RequestManager get:url parameters:@{} success:^(id  _Nonnull responseObject) {
        IOSTChainInfo *chainInfo = [IOSTChainInfo mj_objectWithKeyValues:responseObject];
        block(chainInfo);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

+ (void)iost_sendActionsParm:(NSArray *)actions
            walletPrivateKey:(NSString *)privateKey
                      wallet:(walletModel *)wallet
                       block:(void (^)(IOSTTransResult *))block
{
    if (IsStrEmpty(privateKey)) {
        return;
    }
    [self getBlockInfo:^(IOSTChainInfo *IOSTChainInfo) {
        
        IOSTTransactionObject *transactionObject = [IOSTTransactionObject new];
        transactionObject.actions = [NSMutableArray new];
        for (NSDictionary *dic in actions) {
            IOSTAction *action = [IOSTAction new];
            action.contract = VALIDATE_STRING(dic[@"contract"]);
            action.action_name = VALIDATE_STRING(dic[@"action_name"]);
            NSMutableArray *mArray = [NSMutableArray new];
            [mArray addObject:VALIDATE_STRING(dic[@"token"])];
            [mArray addObject:VALIDATE_STRING(wallet.address)];
            [mArray addObject:VALIDATE_STRING(dic[@"to"])];
            [mArray addObject:VALIDATE_STRING(dic[@"amount"])];
            [mArray addObject:VALIDATE_STRING(dic[@"memo"])];
            action.data = [mArray modelToJSONString];
            
            [transactionObject.actions addObject:action];
        }
        NSString *time1 = [NSString stringWithFormat:@"%f",[[self getNowTimeTimestamp] doubleValue]];
        NSDecimalNumber *hundred1 = [NSDecimalNumber decimalNumberWithString:@"1000000000"];
        NSDecimalNumber *addNum1 = [NSDecimalNumber decimalNumberWithString:@"30000000000"];
        NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:time1];
        NSDecimalNumber *product = [num1 decimalNumberByMultiplyingBy:hundred1];
        NSDecimalNumber *product2 = [product decimalNumberByAdding:addNum1];
        
        transactionObject.time = [product stringValue];
        transactionObject.expiration = [product2 stringValue];
        transactionObject.gas_ratio = @"1";
        transactionObject.gas_limit = @"350000";
        transactionObject.delay = @"0";
        transactionObject.chain_id = IOSTChainInfo.chain_id;
        transactionObject.signers = [NSMutableArray new];
        
        transactionObject.amount_limit = [NSMutableArray new];
        IOSTAmountLimit *amountlimt = [IOSTAmountLimit new];
        amountlimt.token = @"*";
        amountlimt.value = @"unlimited";
        [transactionObject.amount_limit addObject:amountlimt];
        transactionObject.publisher = VALIDATE_STRING(wallet.address);
        transactionObject.signatures = @[].mutableCopy;
        [self iost_signTransaction:transactionObject privateKey:privateKey block:block];
    }];
}


+ (void)iost_sendToAssress:(NSString *)toAddress fromAddress:(NSString *)fromAddress money:(NSString *)money token:(NSString *)token memo:(NSString *)memo contract:(NSString *)contract walletPrivateKey:(NSString *)privateKey  block:(void(^)(IOSTTransResult *result))block
{
    if (IsStrEmpty(privateKey)) {
        return;
    }
    [self getBlockInfo:^(IOSTChainInfo *IOSTChainInfo) {
        IOSTAction *action = [IOSTAction new];
        action.contract = @"contract";
        action.action_name = @"transfer";
        NSMutableArray *mArray = [NSMutableArray new];
        
        [mArray addObject:token];
        [mArray addObject:fromAddress];
        [mArray addObject:toAddress];
        [mArray addObject:money];
        [mArray addObject:memo];
        
        action.data = [mArray modelToJSONString];
        
        IOSTTransactionObject *transactionObject = [IOSTTransactionObject new];
        transactionObject.actions = [NSMutableArray new];
        [transactionObject.actions addObject:action];
        NSString *time1 = [NSString stringWithFormat:@"%f",[[self getNowTimeTimestamp] doubleValue]];
        NSDecimalNumber *hundred1 = [NSDecimalNumber decimalNumberWithString:@"1000000000"];
        NSDecimalNumber *addNum1 = [NSDecimalNumber decimalNumberWithString:@"30000000000"];
        NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:time1];
        NSDecimalNumber *product = [num1 decimalNumberByMultiplyingBy:hundred1];
        NSDecimalNumber *product2 = [product decimalNumberByAdding:addNum1];
        
        transactionObject.time = [product stringValue];
        transactionObject.expiration = [product2 stringValue];
        transactionObject.gas_ratio = @"1";
        transactionObject.gas_limit = @"350000";
        transactionObject.delay = @"0";
        transactionObject.chain_id = IOSTChainInfo.chain_id;
        transactionObject.signers = [NSMutableArray new];
        
        transactionObject.amount_limit = [NSMutableArray new];
        IOSTAmountLimit *amountlimt = [IOSTAmountLimit new];
        amountlimt.token = @"*";
        amountlimt.value = @"unlimited";
        [transactionObject.amount_limit addObject:amountlimt];
        transactionObject.publisher = fromAddress;
        transactionObject.signatures = @[].mutableCopy;
        [self iost_signTransaction:transactionObject privateKey:privateKey block:block];
    }];
}

+ (void)iost_sendToAssress:(NSString *)toAddress fromAddress:(NSString *)fromAddress money:(NSString *)money token:(NSString *)token memo:(NSString *)memo transactionType:(IOSTTransactionType)type walletPassword:(NSString *)pwd  block:(void(^)(IOSTTransResult *result))block
{
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    NSString *privateKey = [AESCrypt decrypt:wallet.privateKey password:pwd];
    if (IsStrEmpty(privateKey)) {
        return;
    }
    [self getBlockInfo:^(IOSTChainInfo *IOSTChainInfo) {
        IOSTAction *action = [IOSTAction new];
        action.contract = [self getContract:type];
        action.action_name = [self getAction:type];
        NSMutableArray *mArray = [NSMutableArray new];
        if (type==IOSTTransactionTransfer) {
            [mArray addObject:token];
        }
        [mArray addObject:fromAddress];
        [mArray addObject:toAddress];
        if (type==IOSTTransactionBuyRam||type==IOSTTransactionSellRam)
        {
            [mArray addObject:@([money floatValue])];
        }else{
            [mArray addObject:money];
        }
        if (type==IOSTTransactionTransfer) {
            [mArray addObject:memo];
        }
        action.data = [mArray modelToJSONString];
        
        IOSTTransactionObject *transactionObject = [IOSTTransactionObject new];
        transactionObject.actions = [NSMutableArray new];
        [transactionObject.actions addObject:action];
        
        NSString *time1 = [NSString stringWithFormat:@"%f",[[self getNowTimeTimestamp] doubleValue]];
        NSDecimalNumber *hundred1 = [NSDecimalNumber decimalNumberWithString:@"1000000000"];
        NSDecimalNumber *addNum1 = [NSDecimalNumber decimalNumberWithString:@"30000000000"];
        NSDecimalNumber *num1 = [NSDecimalNumber decimalNumberWithString:time1];
        NSDecimalNumber *product = [num1 decimalNumberByMultiplyingBy:hundred1];
        NSDecimalNumber *product2 = [product decimalNumberByAdding:addNum1];
        
        transactionObject.time = [product stringValue];
        transactionObject.expiration = [product2 stringValue];
        transactionObject.gas_ratio = @"1";
        transactionObject.gas_limit = @"350000";
        transactionObject.delay = @"0";
        transactionObject.chain_id = IOSTChainInfo.chain_id;
        transactionObject.signers = [NSMutableArray new];
        
        transactionObject.amount_limit = [NSMutableArray new];
        IOSTAmountLimit *amountlimt = [IOSTAmountLimit new];
        amountlimt.token = @"*";
        amountlimt.value = @"unlimited";
        [transactionObject.amount_limit addObject:amountlimt];
        transactionObject.publisher = fromAddress;
        transactionObject.signatures = @[].mutableCopy;
        [self iost_signTransaction:transactionObject privateKey:privateKey block:block];
    }];
}

+ (void)iost_signTransaction:(IOSTTransactionObject *)transaction privateKey:(NSString *)privatekey block:(void(^)(IOSTTransResult *result))block
{
    NSData *data = [IOSTByteWriter getBytesForSignatureAndParams:[transaction mj_keyValues] andCapacity:65536];
    uint8_t buf[32];
    SHA3_CTX ctx;
    sha3_256_Init(&ctx);
    sha3_Update(&ctx, data.bytes, data.length);
    sha3_Final(&ctx, buf);
    NSData *bufData = [[NSData alloc]initWithBytes:buf length:32];
    
    //转换公钥
    NSString *publicKey = [BlinkEd25519 getPublicByPrivateKey:privatekey];
    Ed25519Keypair *keypair = [Ed25519Keypair new];
    keypair.publickey = BTCDataFromBase58(publicKey);
    keypair.privatekey = BTCDataFromBase58(privatekey);
    
    unsigned char signature[64];
    int d_len = bufData.length;
    
    int s = crypto_sign(signature,NULL,bufData.bytes,d_len,keypair.privatekey.bytes);
    NSData * signature_data= [NSData dataWithBytes:signature length:64];
    
    NSMutableDictionary *publisher_signDic = [NSMutableDictionary new];
    [publisher_signDic setObject:@"ED25519" forKey:@"algorithm"];
    [publisher_signDic setObject:base64_encode_data(keypair.publickey) forKey:@"public_key"];
    [publisher_signDic setObject:base64_encode_data(signature_data) forKey:@"signature"];
    transaction.publisher_sigs = [NSMutableArray new];
    [transaction.publisher_sigs addObject:publisher_signDic];
    SCLog(@"=== %@",[transaction mj_keyValues]);
    [self sendTx:transaction block:block];
}

//请求交易
+ (void)sendTx:(IOSTTransactionObject *)transaction block:(void(^)(IOSTTransResult *result))block
{
    NSString *url = [NSString stringWithFormat:@"%@sendTx",IOST_NODE];
    [RequestManager post:url parameters:[transaction mj_keyValues] success:^(id  _Nonnull responseObject) {
        IOSTTransResult *result = [IOSTTransResult mj_objectWithKeyValues:responseObject];
        if (!IsStrEmpty(result.hashs)) {
            if ([result.pre_tx_receipt.status_code isEqualToString:@"SUCCESS"]) {
                [TKCommonTools showToast:LocalizedString(@"操作成功，等待区块确认!")];
            }else{
                [TKCommonTools showToast:result.pre_tx_receipt.message];
            }
        }
        block(result);
        SCLog(@"%@",responseObject);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

static NSString *base64_encode_data(NSData *data){
    return [data base64EncodedStringWithOptions:0];
}

+ (NSString *)getNowTimeTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%f", a];
    return timeString;
}



+ (void)iost_getRamInfoHandle:(void(^)(IOSTRAMInfo *ramInfo))handle
{
    NSString *url = [NSString stringWithFormat:@"%@getRAMInfo",IOST_NODE];
    [RequestManager get:url parameters:@{} success:^(id  _Nonnull responseObject) {
        IOSTRAMInfo *raminfo = [IOSTRAMInfo mj_objectWithKeyValues:responseObject];
        handle(raminfo);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

+ (NSString *)getContract:(IOSTTransactionType)type
{
    NSString *contract ;
    switch (type) {
        case IOSTTransactionTransfer:
            contract = @"token.iost";
            break;
        case IOSTTransactionBuyRam:
            contract = @"ram.iost";
            break;
        case IOSTTransactionSellRam:
            contract = @"ram.iost";
            break;
        case IOSTTransactionPledge:
            contract = @"gas.iost";
            break;
        case IOSTTransactionUnpledge:
            contract = @"gas.iost";
            break;
        default:
            break;
    }
    return contract;
}

+ (NSString *)getAction:(IOSTTransactionType)type
{
    NSString *contract ;
    switch (type) {
        case IOSTTransactionTransfer:
            contract = @"transfer";
            break;
        case IOSTTransactionBuyRam:
            contract = @"buy";
            break;
        case IOSTTransactionSellRam:
            contract = @"sell";
            break;
        case IOSTTransactionPledge:
            contract = @"pledge";
            break;
        case IOSTTransactionUnpledge:
            contract = @"unpledge";
            break;
        default:
            break;
    }
    return contract;
}

+ (void)iost_getAccount:(NSString *)account page:(NSInteger)page transferList:(void(^)(NSArray *transferList))handle
{
    NSString *url = [NSString stringWithFormat:@"https://www.iostabc.com/api/account/%@/actions?&type=&page=%ld&size=20",account,page];
    [RequestManager get:url parameters:@{} success:^(id  _Nonnull responseObject) {
        NSMutableArray *listArray = [NSMutableArray new];
        NSArray *actions = responseObject[@"actions"];
        if (actions.count) {
            listArray = [IOSTTransListModel mj_objectArrayWithKeyValuesArray:actions];
        }
        handle(listArray);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 测试

+ (void)testEd25519
{
    NSData *sec = BTCDataFromBase58(@"1rANSfcRzr4HkhbUFZ7L1Zp69JZZHiDDq5v7dNSbbEqeU4jxy3fszV4HGiaLQEyqVpS1dKT9g7zCVRxBVzuiUzB");
    unsigned char pk[32];
    NSString *publicKey = [BlinkEd25519 getPublicByPrivateKey:@"1rANSfcRzr4HkhbUFZ7L1Zp69JZZHiDDq5v7dNSbbEqeU4jxy3fszV4HGiaLQEyqVpS1dKT9g7zCVRxBVzuiUzB"];
    NSData *dd = BTCDataFromBase58(publicKey);
    NSData *pk_data = [[NSData alloc]initWithBytes:pk length:32];
    SCLog(@"5731adeb5d1a807ec9c43825389e5edff70412e4643a94629a652af1bfcf2f08 === %@",dd.hexString);
    
    NSString *message = @"hello";
    uint8_t buf[32];
    SHA3_CTX ctx;
    sha3_256_Init(&ctx);
    sha3_Update(&ctx, message.dataValue.bytes, message.dataValue.length);
    sha3_Final(&ctx, buf);
    NSData *bufData = [[NSData alloc]initWithBytes:buf length:32];
    SCLog(@"3338be694f50c5f338814986cdf0686453a888b84f424d792af4b9202398f392 === %@",bufData.hexString);
    
    //签名
    unsigned char signature[64];
    int d_len = bufData.length;
    unsigned long long mlen = 64 ;
    int s = crypto_sign(signature,NULL,bufData.bytes,d_len,sec.bytes);
    NSData * signature_data= [NSData dataWithBytes:signature length:64];
    
}

+ (void)testTransaction
{
    NSString *time = @"1544013436179000000";
    NSString *expiration = @"1544013526179000000";
    NSString *gas_ratio = @"1";
    NSString *gas_limit = @"1234";
    NSString *delay = @"0";
    NSString *chain_id = @"1024";
    
    NSString *contract = @"cont";
    NSString *action_name = @"abi";
    NSString *token = @"iost";
    NSString *value = @"123";
    
    IOSTAction *action = [IOSTAction new];
    action.contract = contract;
    action.action_name = action_name;
    NSMutableArray *mArray = [NSMutableArray new];
    [mArray addObject:token];
    //    [mArray addObject:fromAddress];
    //    [mArray addObject:toAddress];
    //    [mArray addObject:money];
    //    [mArray addObject:!IsStrEmpty(memo)?memo:@"memo"];
    action.data = [mArray modelToJSONString];
    
    IOSTTransactionObject *transactionObject = [IOSTTransactionObject new];
    transactionObject.actions = [NSMutableArray new];
    [transactionObject.actions addObject:action];
    
    
    transactionObject.time = time;
    transactionObject.expiration = expiration;
    transactionObject.gas_ratio = gas_ratio;
    transactionObject.gas_limit = gas_limit;
    transactionObject.delay = delay;
    transactionObject.chain_id = chain_id;
    
    transactionObject.signers = [NSMutableArray new];
    [transactionObject.signers addObject:@"abc"];
    
    transactionObject.amount_limit = [NSMutableArray new];
    IOSTAmountLimit *amountlimt = [IOSTAmountLimit new];
    amountlimt.token = token;
    amountlimt.value = value;
    [transactionObject.amount_limit addObject:amountlimt];
    
    NSData *datad = [IOSTByteWriter getBytesForSignatureAndParams:[transactionObject mj_keyValues] andCapacity:65536];
    SCLog(@"156d700a27e12ac0156d701f1c4c2ec00000000000000064000000000001e208000000000000000000000400000000000000000100000003616263000000010000001500000004636f6e7400000003616269000000025b5d000000010000000f00000004696f737400000003313233 == %@",datad.hexString);
}

@end
