//
//  CreateWalletTool.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "CreateWalletTool.h"
#import "SCRootTool.h"
#import "AESCrypt.h"

#import "BTC256+Tests.h"
#import "BTCData+Tests.h"
#import "BTCMnemonic+Tests.h"
#import "BTCBigNumber+Tests.h"
#import "BTCBase58+Tests.h"
#import "BTCAddress+Tests.h"
#import "BTCProtocolSerialization+Tests.h"
#import "BTCKey+Tests.h"
#import "BTCKeychain+Tests.h"
#import "BTCCurvePoint+Tests.h"
#import "BTCBlindSignature+Tests.h"
#import "BTCEncryptedBackup+Tests.h"
#import "BTCEncryptedMessage+Tests.h"
#import "BTCFancyEncryptedMessage+Tests.h"
#import "BTCScript+Tests.h"
#import "BTCTransaction+Tests.h"
#import "BTCBlockchainInfo+Tests.h"
#import "BTCPriceSource+Tests.h"
#import "BTCMerkleTree+Tests.h"
#import "BTCBitcoinURL+Tests.h"
#import "BTCCurrencyConverter+Tests.h"
#import "NSData+BTCData.h"
#import "BTCBase58.h"
#import "NS+BTCBase58.h"

#import "BTCData.h"
#import "BTCNetwork.h"

#import <ethers/SecureData.h>
#include <ethers/bip39.h>
#import <ethers/bip32.h>
#import <ethers/curves.h>
#import <ethers/secp256k1.h>
#import <ethers/sha3.h>

#import "segwit_addr.h"
#include "ge.h"
#include <string.h>
#import <CommonCrypto/CommonDigest.h>
#import "crypto_sign_ed25519.h"
#import "crypto_sign.h"

#import "bech32_test.h"

#define Main_Path @"m/44'/0'/0'/0/0"
#define Witness_Path @"m/49'/0'/0'/0/0"

@implementation CreateWalletTool

+ (void)creatBTCWallet:(BOOL)witness
{
#pragma mark - 创建BTC钱包
    NSString *whereStr = [NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"ID"],[NSObject bg_sqlValue:@(0)]];
    
    NSArray *arr = [walletModel bg_find:nil where:whereStr];
    walletModel *btcWallet = [arr lastObject];
    
    NSString *ss = [AESCrypt decrypt:btcWallet.mnemonics password:btcWallet.password];
    NSArray *words = [ss componentsSeparatedByString:@" "];
//    BTCMnemonic *mnemonic = [[BTCMnemonic alloc]initWithWords:words password:btcWallet.password wordListType:BTCMnemonicWordListTypeEnglish];
//    mnemonic.keychain.network = [BTCNetwork mainnet];
    const char* phraseStr = [ss cStringUsingEncoding:NSUTF8StringEncoding];
    SecureData *seed = [SecureData secureDataWithLength:(512 / 8)];
    mnemonic_to_seed(phraseStr, "", seed.mutableBytes, NULL);
    NSData * seed_data= [NSData dataWithBytes:seed.mutableBytes length:64];
    
    BTCKeychain *keychain = [[BTCKeychain alloc]initWithSeed:seed_data];
    NSString *path = @"";
    if (witness) {
        path = Witness_Path;
    }else
    {
        path = Main_Path;
    }
    BTCKeychain *btcKeychain = [keychain derivedKeychainWithPath:path];
    NSMutableString *string = [[NSMutableString alloc]init];
    for (NSString *word in words) {
        [string appendString:word];
        [string appendString:@" "];
    }
  
    btcWallet.address = witness?btcKeychain.key.witnessAddress.string:btcKeychain.key.address.string;
    btcWallet.privateKey = [AESCrypt encrypt:btcKeychain.key.privateKeyAddress.string password:btcWallet.password];
    btcWallet.name = @"BTC-Wallet";
//    btcWallet.isSystem = @(1);
    btcWallet.portrait = @"葡萄";//默认头像
    btcWallet.password = [AESCrypt encrypt:btcWallet.password password:btcWallet.password];
    
    [btcWallet bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:btcWallet.bg_id]]];
    
    [UserinfoModel shareManage].walletType = BTC_WALLET_TYPE;
    NSArray *Namearray=[UserinfoModel shareManage].Namearray;
    NSArray *typeArray=[UserinfoModel shareManage].coinTypeArray;
    NSArray *recordTypeArray=[UserinfoModel shareManage].recordTypeArray;
    NSArray *AddressprefixArray=[UserinfoModel shareManage].AddressprefixTypeArray;
    NSArray *PriveprefixArray=[UserinfoModel shareManage].PriveprefixTypeArray;
    NSArray *englishNameArray=[UserinfoModel shareManage].englishNameArray;
    for (int i=0; i<Namearray.count; i++) {
        [SCRootTool creatCoins:Namearray[i] withEnglishName:englishNameArray[i] withCointype:[typeArray[i] intValue] withAddressprefix:[AddressprefixArray[i] intValue] withPriveprefix:[PriveprefixArray[i] intValue]  withRecordtype:recordTypeArray[i] withID:btcWallet.bg_id totalAmount:@"0.00" withWallet:btcWallet contractAddress:@""];
    }
}

+ (void)creatETHWallet:(Account *)account success:(void(^)(BOOL result))block
{
    NSString *whereStreth = [NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"ID"],[NSObject bg_sqlValue:@(60)]];
    
    NSArray *arre = [walletModel bg_find:nil where:whereStreth];
    walletModel *ethWallet = [arre lastObject];
    
    __block NSString *ethPrivateKey = @"";// [MnemonicUtil getPrivateKeyWithMnemonics:ss];
    __block NSString *ethAddress =@"";// [MnemonicUtil getAddressWithPrivateKey:ethPrivateKey];
    
    [ETHClient getEtnPrivateKey:account password:ethWallet.password block:^(NSString * _Nonnull address, NSString * _Nonnull privateKey, NSString * _Nonnull keyStore) {
        ethPrivateKey = privateKey;
        ethAddress = address;
        
        NSLog(@"address=%@", ethAddress);
        NSLog(@"privateKey=%@", ethPrivateKey);
        
        ethWallet.address = ethAddress;
        ethWallet.privateKey = [AESCrypt encrypt:ethPrivateKey password:ethWallet.password];
        ethWallet.name = @"ETH-Wallet";
        ethWallet.portrait = @"菠萝";
        ethWallet.keyStore = [AESCrypt encrypt:keyStore password:ethWallet.password];
//        ethWallet.isSystem = @(1);
        ethWallet.password = [AESCrypt encrypt:ethWallet.password password:ethWallet.password];
        
        [UserinfoModel shareManage].walletType = ETH_WALLET_TYPE;
        NSArray *Namearray2=[UserinfoModel shareManage].Namearray;
        NSArray *typeArray2=[UserinfoModel shareManage].coinTypeArray;
        NSArray *recordTypeArray2=[UserinfoModel shareManage].recordTypeArray;
        NSArray *AddressprefixArray2=[UserinfoModel shareManage].AddressprefixTypeArray;
        NSArray *PriveprefixArray2=[UserinfoModel shareManage].PriveprefixTypeArray;
        NSArray *englishNameArray2=[UserinfoModel shareManage].englishNameArray;
        for (int i=0; i<Namearray2.count; i++) {
            [SCRootTool creatCoins:Namearray2[i] withEnglishName:englishNameArray2[i] withCointype:[typeArray2[i] intValue] withAddressprefix:[AddressprefixArray2[i] intValue] withPriveprefix:[PriveprefixArray2[i] intValue]  withRecordtype:recordTypeArray2[i] withID:ethWallet.bg_id totalAmount:@"0.00" withWallet:ethWallet contractAddress:@""];
        }
        //创建完成
        BOOL success = [ethWallet bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:ethWallet.bg_id]]];
        if (block) {
            block(success);
        }
    }];
}

+ (void)createTRXWallet
{
#pragma mark - 创建TRX钱包
    NSString *whereStrtrx = [NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"ID"],[NSObject bg_sqlValue:@(195)]];
    
    NSArray *arrt = [walletModel bg_find:nil where:whereStrtrx];
    walletModel *trxWallet = [arrt lastObject];
    
    NSString *ss = [AESCrypt decrypt:trxWallet.mnemonics password:trxWallet.password];
//    NSArray *words = [ss componentsSeparatedByString:@" "];
//    BTCMnemonic *mnemonic = [[BTCMnemonic alloc]initWithWords:words password:trxWallet.password wordListType:BTCMnemonicWordListTypeEnglish];
//    mnemonic.keychain.network = [BTCNetwork mainnet];
    const char* phraseStr = [ss cStringUsingEncoding:NSUTF8StringEncoding];
    SecureData *seed = [SecureData secureDataWithLength:(512 / 8)];
    mnemonic_to_seed(phraseStr, "", seed.mutableBytes, NULL);
    NSData * seed_data= [NSData dataWithBytes:seed.mutableBytes length:64];
    
    BTCKeychain *keychain = [[BTCKeychain alloc]initWithSeed:seed_data];
    BTCKeychain *trxKeychain = [keychain derivedKeychainWithPath:@"m/44'/195'/0'/0/0"];
  
    [UserinfoModel shareManage].walletType = TRON_WALLET_TYPE;
    NSArray *Namearray3=[UserinfoModel shareManage].Namearray;
    NSArray *typeArray3=[UserinfoModel shareManage].coinTypeArray;
    NSArray *recordTypeArray3=[UserinfoModel shareManage].recordTypeArray;
    NSArray *AddressprefixArray3=[UserinfoModel shareManage].AddressprefixTypeArray;
    NSArray *PriveprefixArray3=[UserinfoModel shareManage].PriveprefixTypeArray;
    NSArray *englishNameArray3=[UserinfoModel shareManage].englishNameArray;
    
    TWWalletType type = TWWalletDefault;
//    TWWalletAccountClient *client = [[TWWalletAccountClient alloc] initWithGenKey:YES type:type];
     TWWalletAccountClient *client = [[TWWalletAccountClient alloc] initWithPriKeyStr:BTCHexFromData(trxKeychain.key.privateKey) type:type];
    [client store:trxWallet.password];
    client.own_id = trxWallet.bg_id;
    [client bg_save];
    
    for (int i=0; i<Namearray3.count; i++) {
        [SCRootTool creatCoins:Namearray3[i] withEnglishName:englishNameArray3[i] withCointype:[typeArray3[i] intValue] withAddressprefix:[AddressprefixArray3[i] intValue] withPriveprefix:[PriveprefixArray3[i] intValue]  withRecordtype:recordTypeArray3[i] withID:trxWallet.bg_id totalAmount:@"0.00" withWallet:trxWallet contractAddress:@""];
    }
    trxWallet.address = client.base58OwnerAddress;
    trxWallet.privateKey = [AESCrypt encrypt:BTCHexFromData(trxKeychain.key.privateKey) password:trxWallet.password];
    trxWallet.name = @"Tron-Wallet";
    trxWallet.portrait = @"苹果";
//    trxWallet.isSystem = @(1);
    trxWallet.password = [AESCrypt encrypt:trxWallet.password password:trxWallet.password];
    trxWallet.resourceOP = YES;
    
    [trxWallet bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:trxWallet.bg_id]]];
    
}

#pragma mark - 创建ATOM钱包
+ (void)createATOMWallet
{
    NSString *whereStr = [NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"ID"],[NSObject bg_sqlValue:@(118)]];
        
        NSArray *arr = [walletModel bg_find:nil where:whereStr];
        walletModel *btcWallet = [arr lastObject];
        
        NSString *ss = [AESCrypt decrypt:btcWallet.mnemonics password:btcWallet.password];
    
    // imtoken
//    const char* phraseStr = [@"measure slogan connect luggage stereo federal stuff stomach stumble security end differ" cStringUsingEncoding:NSUTF8StringEncoding];
    
    //火币钱包
//    const char* phraseStr = [@"sibling august fiber ball merge stay talk emotion airport zoo public beach" cStringUsingEncoding:NSUTF8StringEncoding];
    
    //demo
//    const char* phraseStr = [@"car taste absurd genius miracle toy earth true glare mobile pig forest" cStringUsingEncoding:NSUTF8StringEncoding];
 
    
    const char* phraseStr = [ss cStringUsingEncoding:NSUTF8StringEncoding];
  
    SecureData *seed2 = [SecureData secureDataWithLength:(512 / 8)];
    mnemonic_to_seed(phraseStr, "", seed2.mutableBytes, NULL);
    NSData * seed_data= [NSData dataWithBytes:seed2.mutableBytes length:64];
    
    HDNode node;
    hdnode_from_seed([seed2 bytes], (int)[seed2 length], SECP256K1_NAME, &node);
    
    hdnode_private_ckd(&node, (0x80000000 | (44)));   // 44' - BIP 44 (purpose field)
    hdnode_private_ckd(&node, (0x80000000 | (118)));   // 118' - ATOM (see SLIP 44)
    hdnode_private_ckd(&node, (0x80000000 | (0)));    // 0'  - Account 0
    hdnode_private_ckd(&node, 0);                     // 0   - External
    hdnode_private_ckd(&node, 0);                     // 0   - Slot #0
    
    SecureData *privateKey = [SecureData secureDataWithLength:32];
    memcpy(privateKey.mutableBytes, node.private_key, 32);
    
    SecureData *publicKey = [SecureData secureDataWithLength:33];
    ecdsa_get_public_key33(&secp256k1, privateKey.bytes, publicKey.mutableBytes);
  
    NSMutableData *atom_data = BTCHash160(publicKey.data);
    uint8_t data[65];
    size_t datalen = 0;
    convert_bits(data,&datalen,5,atom_data.bytes,atom_data.length,8,1);
    NSMutableData *result = [[NSMutableData alloc] initWithCapacity:89];
    bech32_encode(result.mutableBytes, [@"cosmos" UTF8String],data, datalen);
 
    btcWallet.address = [NSString stringWithUTF8String:result.bytes];
    btcWallet.privateKey = [AESCrypt encrypt:privateKey.string password:btcWallet.password];
    btcWallet.name = @"ATOM-Wallet";
    btcWallet.portrait = @"葡萄";//默认头像
    btcWallet.password = [AESCrypt encrypt:btcWallet.password password:btcWallet.password];
    
    [btcWallet bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:btcWallet.bg_id]]];
    
    [UserinfoModel shareManage].walletType = ATOM_WALLET_TYPE;
    NSArray *Namearray=[UserinfoModel shareManage].Namearray;
    NSArray *typeArray=[UserinfoModel shareManage].coinTypeArray;
    NSArray *recordTypeArray=[UserinfoModel shareManage].recordTypeArray;
    NSArray *AddressprefixArray=[UserinfoModel shareManage].AddressprefixTypeArray;
    NSArray *PriveprefixArray=[UserinfoModel shareManage].PriveprefixTypeArray;
    NSArray *englishNameArray=[UserinfoModel shareManage].englishNameArray;
    for (int i=0; i<Namearray.count; i++) {
        [SCRootTool creatCoins:Namearray[i] withEnglishName:englishNameArray[i] withCointype:[typeArray[i] intValue] withAddressprefix:[AddressprefixArray[i] intValue] withPriveprefix:[PriveprefixArray[i] intValue]  withRecordtype:recordTypeArray[i] withID:btcWallet.bg_id totalAmount:@"0.00" withWallet:btcWallet contractAddress:@""];
    }
}

@end
