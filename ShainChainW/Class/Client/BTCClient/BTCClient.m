//
//  BTCClient.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/16.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BTCClient.h"
#import "BTCAccount.h"
#import "BTCAddress+Tests.h"
#import "BTCBlockchainInfo+Tests.h"
#import "BTCUnitsAndLimits.h"
#import "BTCTransaction+Tests.h"
#import "BTCTransactionOutput.h"
#import "BTCTransactionInput.h"
#import "BTCScript+Tests.h"
#import "BTCKey+Tests.h"
#import "BTCKeychain+Tests.h"
#import "BTCData.h"
#import "AFNetworking.h"
#import "BTCMnemonic+Tests.h"
#import "BTCBase58.h"
#define Official 1



#define BTC_HOST @"https://blockchain.info/"
#define BTC_TEST_HOST @"https://testnet.blockchain.info/"

#define BTC_NET_HOST (Official?BTC_HOST:BTC_TEST_HOST)
#define BTC_BIP44_Path     @"m/44'/0'/0'/0/0"

@implementation BTCClient

+(BTCMnemonic *)generateMnemonicPassphrase:(NSString *)phrase withPassword:(NSString *)password{
    BTCMnemonic *mnemonic;
    if (phrase != nil) {
        NSArray *words = [phrase componentsSeparatedByString:@" "];
        mnemonic = [[BTCMnemonic alloc] initWithWords:words password:password wordListType:BTCMnemonicWordListTypeEnglish];
    }else{
        mnemonic = [[BTCMnemonic alloc] initWithEntropy:BTCRandomDataWithLength(16) password:password wordListType:BTCMnemonicWordListTypeEnglish];
    }
    return mnemonic;
}

+(void)importPrivateKey:(NSString *)privateKey
                success:(void(^)(NSString *private,NSString *address))successblock
                  error:(void(^)(void))errorblock{
    BTCPrivateKeyAddress *privateKeyAddress;
    if (Official) {
        privateKeyAddress = [BTCPrivateKeyAddress addressWithString:privateKey];
    }else{
        privateKeyAddress = [BTCPrivateKeyAddressTestnet addressWithString:privateKey];
    }
    SCLog(@"aaaaa----- %@",privateKeyAddress);
    BTCKeychain *keychain = [[BTCKeychain alloc]initWithExtendedKey:BTCBase58StringWithData(privateKey.dataValue)];
    BTCKeychain *trxKeychain = [keychain derivedKeychainWithPath:@"m/49'/0'/0'"];
    
    SCLog(@"bbbbb----- %@",trxKeychain.key.address.string);
    if (privateKeyAddress == nil) {
        errorblock();
        return;
    }
    successblock(privateKeyAddress.string,privateKeyAddress.publicAddress.string);
}

+(void)importMnemonic:(NSString *)string
              success:(void(^)(NSString *private,NSString *address))successblock
                error:(void(^)(void))errorblock{
    
    BTCMnemonic *mnemonic = [self generateMnemonicPassphrase:string withPassword:nil];
    if (mnemonic ) {
        BTCKeychain *keyPr = mnemonic.keychain;
        BTCKey *key = [keyPr keyWithPath:BTC_BIP44_Path];
        
        if (Official) {
            successblock(key.privateKeyAddress.string,key.address.string);
        }else{
            successblock(key.privateKeyAddressTestnet.string,key.addressTestnet.string);
        }
    }else{
        errorblock();
    }
}

+ (void)getAddressBalance:(NSString *)address handler:(void (^)(NSError * _Nullable error))handler
{
    NSString *urlString = [NSString stringWithFormat:@"%@address/%@?format=json",BTC_HOST,address];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    NSData *data = [self BTCClientNSURL:apiURL errorHandler:^(NSError * _Nullable error) {
        handler(nil);
    }];
    if (data.bytes) {
        BTCAccount *btcAccount = [BTCAccount mj_objectWithKeyValues:data];
        NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"BTC"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
        coinModel *model = [arr lastObject];
        CGFloat f = [btcAccount.final_balance floatValue]/kBTCDense;
        model.totalAmount = [NSString stringWithFormat:@"%.8f",f];
        [model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"BTC"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
        handler(nil);
    }
}

+ (void)getTxlistWithAddress:(NSString *)address
                   withPage:(NSInteger)page
                      block:(void(^)(NSArray *array,BOOL suc))block{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rawaddr/%@?offset=%zi&limit=10",BTC_HOST,address,page-1];
    [RequestManager get:urlStr parameters:nil success:^(id  _Nonnull responseObject) {
//        SCLog(@"---- %@",responseObject);
        block([responseObject objectForKey:@"txs"],YES);
    } failure:^(NSError * _Nonnull error) {
        block(nil,NO);
    }];

}

+(void)sendToAddress:(NSString *)toAddress money:(NSString *)money fromAddress:(NSString *)fromAddress privateKey:(NSString *)privateKey fee:(NSInteger)fee block:(void(^)(NSString *hashStr,BOOL suc))block{
    
    
    BTCPrivateKeyAddress *privateKeyAddress;
    if (Official) {
        privateKeyAddress = [BTCPrivateKeyAddress addressWithString:privateKey];
    }else{
        privateKeyAddress = [BTCPrivateKeyAddressTestnet addressWithString:privateKey];
    }
    
    BTCKey *key = privateKeyAddress.key;
    
    BTCBlockchainInfo *info = [[BTCBlockchainInfo alloc] init];
    
    NSError *error = nil;
    
    NSArray *utxos = [info unspentOutputsWithAddresses:@[[BTCAddress addressWithString:fromAddress]] error:&error];
   
    BTCAmount amount = money.doubleValue * pow(10.0, 8);
 
    // Sort utxo in order of amount.
    utxos = [utxos sortedArrayUsingComparator:^(BTCTransactionOutput* obj1, BTCTransactionOutput* obj2) {
        if ((obj1.value - obj2.value) < 0) return NSOrderedAscending;
        else return NSOrderedDescending;
    }];
    
    // Find enough outputs to spend the total amount.
    
    NSMutableArray *txouts = [NSMutableArray array];
    
    BTCAmount balance = 0;
    BTCAmount totalAmount = amount;
    
    
    //    for (BTCTransactionOutput *txout in utxos) {
    for (NSInteger i = 0; i < [utxos count];i++) {
        BTCTransactionOutput *txout = [utxos objectAtIndex:i];
        if (txout.script.isPayToPublicKeyHashScript) {
            [txouts addObject:txout];
            balance = balance + txout.value;
        }
        // 148 * 输入数量 + 34 * 输出数量 + 10 =b : fee sat/b
        fee = (148*utxos.count + 34*2 + 10)*fee;
        if (balance >= totalAmount) {
            if (balance >= amount + fee) {
                totalAmount = amount + fee;
                break;
            }
        }
    }

    if (!txouts || balance < totalAmount) {
        block(@"",NO);
    } else {
        BTCTransaction *tx = [[BTCTransaction alloc] init];
        
        BTCAmount spentCoins = 0;
        
        // Add all outputs as inputs
        for (BTCTransactionOutput *txout in txouts) {
            BTCTransactionInput *txin = [[BTCTransactionInput alloc] init];
            txin.previousHash = txout.transactionHash;
            txin.previousIndex = txout.index;
            [tx addInput:txin];
            
            spentCoins += txout.value;
        }

        // Add required outputs - payment and change
        BTCTransactionOutput *paymentOutput = [[BTCTransactionOutput alloc]initWithValue:amount address:[BTCPublicKeyAddress addressWithString:toAddress]];
        
        BTCTransactionOutput *changeOutput = [[BTCTransactionOutput alloc]initWithValue:(spentCoins - totalAmount) address:[BTCPublicKeyAddress addressWithString:fromAddress]];
        [tx addOutput:paymentOutput];
        [tx addOutput:changeOutput];
        
        for (int i = 0; i < txouts.count; i++) {
            BTCTransactionOutput *txout = txouts[i];
            BTCTransactionInput *txin = tx.inputs[i];
            
            BTCScript *sigScript = [[BTCScript alloc] init];
            NSData* hash = [tx signatureHashForScript:txout.script inputIndex:i hashType:BTCSignatureHashTypeAll error:&error];
            
            if (!hash) {
                block(@"",NO);
                return;
            } else {
                NSData *signature = [key signatureForHash:hash];
                
                NSMutableData *signatureForScript = [signature mutableCopy];
                unsigned char hashtype = BTCSignatureHashTypeAll;
                [signatureForScript appendBytes:&hashtype length:1];
                [sigScript appendData:signatureForScript];
                [sigScript appendData:key.publicKey];
                
                txin.signatureScript = sigScript;
            }
        }
        
    
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString* urlstring = [NSString stringWithFormat:@"%@pushtx",BTC_NET_HOST];
        
        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                     URLString:urlstring
                                                                                    parameters:nil error:nil];
        
        NSData *body =  [[NSString stringWithFormat:@"tx=%@", BTCHexFromData([tx data])] dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
        //发起请求
        [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            NSLog(@"Reply JSON: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (!error) {
                NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if ( [str hasPrefix:@"Transaction Submitted"]) {
                    block(nil,YES);
                }else{
                    block(nil,NO);
                }
            } else {
                block(nil,NO);
            }
        }] resume];
 
    }
}





+ (NSData *)BTCClientRequest:(NSMutableURLRequest *)request errorHandler:(void (^)(NSError * _Nullable))errorHandler
{
    __block NSData* retVal = nil;
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            errorHandler(error);
            retVal = [[NSData alloc]init];
        } else {
            retVal = data;
        }
    }];
    
    [tsk resume];
    while (retVal == nil) {}
    return retVal;
}

+ (NSData *)BTCClientNSURL:(NSURL *)url errorHandler:(void (^)(NSError * _Nullable))errorHandler
{
    __block NSData* retVal = nil;
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            errorHandler(error);
            retVal = [[NSData alloc]init];
        } else {
            retVal = data;
        }
    }];
    
    [tsk resume];
    while (retVal == nil) {}
    return retVal;
}

@end
