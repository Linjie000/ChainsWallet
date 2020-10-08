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
#import "AESCrypt.h"
#import "NSData+Hashing.h"

#import <ethers/SecureData.h>
#import <ethers/secp256k1.h>
#import <ethers/ecdsa.h>

#import <openssl/ecdsa.h>
#import "IOSTByteWriter.h"
#import "JKBigInteger.h"

#import "uECC.h"
#import "NSObject+Extension.h"
#import "Sha256.h"
#include "ed25519.h"
#define IOST_NODE @"http://18.209.137.246:30001/"


@implementation IOSTClient

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

+ (void)getIOSTAccount:(NSString *)account handle:(void (^)(id model))handle
{
    NSString *url = [NSString stringWithFormat:@"%@getAccount/%@/true",IOST_NODE,account];
    [RequestManager get:url parameters:@{} success:^(id  _Nonnull responseObject) {
        IOSTAccount *account = [IOSTAccount mj_objectWithKeyValues:responseObject];
        SCLog(@"");
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

+ (void)iost_sendToAssress:(NSString *)toAddress fromAddress:(NSString *)fromAddress money:(NSString *)money token:(NSString *)token memo:(NSString *)memo pwd:(NSString *)pwd gasRatio:(NSString *)gas_ratio gasLimit:(NSString *)gasLimit block:(void(^)(NSString *hashStr))block
{
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    NSString *privatekey = [AESCrypt decrypt:wallet.privateKey password:@"a1111111"];
    if (IsStrEmpty(privatekey)) {
        [TKCommonTools showToast:LocalizedString(@"密码错误")];
        return;
    }
    [self getBlockInfo:^(IOSTChainInfo *IOSTChainInfo) {
        IOSTAction *action = [IOSTAction new];
        action.contract = @"token.iost";
        action.action_name = @"transfer";
        NSMutableArray *mArray = [NSMutableArray new];
        [mArray addObject:@"iost"];
        [mArray addObject:fromAddress];
        [mArray addObject:toAddress];
        [mArray addObject:money];
        [mArray addObject:!IsStrEmpty(memo)?memo:@"memo"];
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
        transactionObject.gas_ratio = gas_ratio;
        transactionObject.gas_limit = gasLimit;
        transactionObject.delay = @"0";
        transactionObject.chain_id = IOSTChainInfo.chain_id;
        transactionObject.signers = [NSMutableArray new];
        
        transactionObject.amount_limit = [NSMutableArray new];
        IOSTAmountLimit *amountlimt = [IOSTAmountLimit new];
        amountlimt.token = token;
        amountlimt.value = @"unlimited";
        [transactionObject.amount_limit addObject:amountlimt];
        transactionObject.publisher = fromAddress;
        transactionObject.signatures = @[].mutableCopy;
        [self iost_signTransaction:transactionObject privateKey:privatekey];
    }];

}

+ (NSString *)getNowTimeTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%f", a];
    return timeString;
}

+ (NSString *)subPointText:(NSString *)text
{
    NSRange rang = [text rangeOfString:@"."];
    return [text substringToIndex:rang.location];
}

+ (void)iost_signTransaction:(IOSTTransactionObject *)transaction privateKey:(NSString *)privatekey
{
    
//    NSData *data23 = [NSJSONSerialization dataWithJSONObject:[transaction mj_keyValues] options:NSJSONWritingPrettyPrinted error:nil];
    NSData *data2 = [IOSTByteWriter getBytesForSignatureAndParams:[transaction mj_keyValues] andCapacity:256];
    NSData * data = [data2 SHA256Hash];
  
    NSString *content = [transaction modelToJSONString];
    //转换公钥
    NSString *publicKey = [BlinkEd25519 getPublicByPrivateKey:privatekey];
    Ed25519Keypair *keypair = [Ed25519Keypair new];
    keypair.publickey = BTCDataFromBase58(publicKey);
    keypair.privatekey = BTCDataFromBase58(privatekey);
    
    NSData *s_data = [privatekey dataUsingEncoding:NSUTF8StringEncoding];
    NSData *p_data = [publicKey dataUsingEncoding:NSUTF8StringEncoding];
    
    const unsigned char message[] = privatekey;
    const int message_len = strlen((char*) message);
//   1
    unsigned char signature[64];
    ed25519_sign(signature, [data bytes], data.length, [keypair.publickey bytes], [keypair.privatekey bytes]);
    NSData *signData1 = [NSData dataWithBytes:signature length:64];
    
    if (ed25519_verify(signature, [data bytes], strlen([data bytes]), [keypair.publickey bytes])) {
        printf("valid signature\n");
    } else {
        printf("invalid signature\n");
    }
    
//    2
    NSData *signData2 = [self signatureForHash:data withPrivateKey:keypair.privatekey];
//    3
    NSData *signData3 = [BlinkEd25519 BLinkEd25519_Signature:keypair Content:content];
    if ([BlinkEd25519 BlinkEd25519_Verify:signData3 content:content.dataValue Ed25519Keypair:keypair]) {
        printf("valid signature\n");
    } else {
        printf("invalid signature\n");
    }
//    4
//    unsigned char signature4[64];
//    const int8_t *private_key = [keypair.privatekey bytes];
//    int recId = uECC_sign_forbc(private_key, data.bytes, signature4);
//    NSData *signData4 = [NSData dataWithBytes:signature4 length:64];
    //    SECP256K1  ED25519
    NSMutableDictionary *publisher_signDic = [NSMutableDictionary new];
    [publisher_signDic setObject:@"ED25519" forKey:@"algorithm"];
    [publisher_signDic setObject:base64_encode_data(keypair.publickey) forKey:@"public_key"];
    [publisher_signDic setObject:base64_encode_data(signData1) forKey:@"signature"];
    transaction.publisher_sigs = [NSMutableArray new];
    [transaction.publisher_sigs addObject:publisher_signDic];
    
    SCLog(@"==== %@",[transaction mj_keyValues]);
    [self sendTx:transaction];
}

static NSString *base64_encode_string(NSString *string){
    NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    return [data base64EncodedStringWithOptions:0];
}

static NSString *base64_encode_data(NSData *data){
//    NSData *data =[string dataUsingEncoding:NSUTF8StringEncoding];
    //2、对二进制数据进行base64编码，完成后返回字符串
    return [data base64EncodedStringWithOptions:0];
}

//请求交易
+ (void)sendTx:(IOSTTransactionObject *)transaction
{
    NSString *url = [NSString stringWithFormat:@"%@sendTx",IOST_NODE];
    [RequestManager post:url parameters:[transaction mj_keyValues] success:^(id  _Nonnull responseObject) {
        SCLog(@"%@",responseObject);
        SCLog(@"%@",responseObject);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

+ (NSData*)signatureForHash:(NSData *)hash withPrivateKey:(NSData *)_privateKey {
    SecureData *signatureData = [SecureData secureDataWithLength:64];;
    uint8_t pby;
//    ecdsa_sign_digest(&secp256k1, [_privateKey bytes], hash.bytes, signatureData.mutableBytes, &pby, NULL);
    
    return signatureData.data;
 }
@end
