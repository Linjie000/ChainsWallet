//
//  ExcuteMultipleActionsService.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "ExcuteMultipleActionsService.h"
#import "ScatterResult_type_requestSignature.h"
#import "AESCrypt.h"
#import "EOS_Key_Encode.h"
#import "ScatterAction.h"
#import "Sha256.h"
#import "EosByteWriter.h"
#import "uECC.h"
#import "rmd160.h"
#import <ethers/base58.h>

@interface ExcuteMultipleActionsService ()
@property(nonatomic , copy) NSString *sender;
@property(nonatomic , strong) NSArray *excuteActionsArray;
@property(nonatomic , strong) NSMutableArray *finalExcuteActionsArray; // excuteActions add binargs Array
@property(nonatomic , strong) NSArray *available_keys;
@property(nonatomic , copy) NSString *password;

@property(nonatomic, copy) NSString *required_Publickey;
@end

@implementation ExcuteMultipleActionsService

- (NSString *)excuteMultipleActionsForScatterWithScatterResult:(ScatterResult_type_requestSignature *)scatterResult andAvailable_keysArray:(NSArray *)available_keysArray andPassword:(NSString *)password{
    
    self.sender = scatterResult.actor;
    self.excuteActionsArray = (NSMutableArray *)scatterResult.actions;
    self.available_keys = available_keysArray;
    self.password = password;
    self.required_Publickey = available_keysArray[0];
    
      walletModel *wallet = [[walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"address"],[NSObject bg_sqlValue:self.sender]]] lastObject];
    NSString *wif = [AESCrypt decrypt:wallet.account_active_private_key password:self.password];
    //    if ([accountInfo.account_owner_public_key isEqualToString:self.required_Publickey]) {
    //        wif = [AESCrypt decrypt:accountInfo.account_owner_private_key password:self.password];
    //    }else if ([accountInfo.account_active_public_key isEqualToString:self.required_Publickey]) {
    //        wif = [AESCrypt decrypt:accountInfo.account_active_private_key password:self.password];
    //    }else{
    //        [TOASTVIEW showWithText:NSLocalizedString(@"未找到账号的私钥!", nil)];
    //        return nil;
    //    }
    const int8_t *private_key = [[EOS_Key_Encode getRandomBytesDataWithWif:wif] bytes];
    //     [NSObject out_Int8_t:private_key andLength:32];
    if (!private_key) {
//        [TOASTVIEW showWithText:@"private_key can't be nil!"];
        return nil;
    }
    
    NSMutableDictionary *transacDic = [NSMutableDictionary dictionary];
    [transacDic setObject:VALIDATE_STRING(scatterResult.ref_block_prefix) forKey:@"ref_block_prefix"];
    [transacDic setObject:VALIDATE_STRING(scatterResult.ref_block_num) forKey:@"ref_block_num"];
    
    [transacDic setObject:VALIDATE_STRING(scatterResult.expiration) forKey:@"expiration"];
    
    NSMutableArray *actionsArr = [NSMutableArray array];
    for (int i = 0 ; i < self.excuteActionsArray.count; i++) {
        NSDictionary *dict = self.excuteActionsArray[i];
        ScatterAction *action = [ScatterAction mj_objectWithKeyValues:dict];
        NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
        [actionDict setObject:VALIDATE_STRING(action.account) forKey:@"account"];
        [actionDict setObject:VALIDATE_STRING(action.name) forKey:@"name"];
        [actionDict setObject:VALIDATE_STRING(action.data) forKey:@"data"];
        [actionDict setObject:VALIDATE_ARRAY(action.authorization) forKey:@"authorization"];
        [actionsArr addObject:actionDict];
    }
    
    [transacDic setObject:VALIDATE_ARRAY(actionsArr) forKey:@"actions"];
    
    Sha256 *sha256 = [[Sha256 alloc] initWithData:[EosByteWriter getBytesForSignatureExcuteMultipleActions:[NSObject convertHexStrToData:@"aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906"] andParams: transacDic andCapacity:255]]; // chainId 写死
    //    Sha256 *sha256 = [[Sha256 alloc] initWithData:[EosByteWriter getBytesForSignatureExcuteMultipleActions:[NSObject convertHexStrToData:scatterResult.chainId] andParams: transacDic andCapacity:255]];
    int8_t signature[uECC_BYTES*2];
    int recId = uECC_sign_forbc(private_key, sha256.mHashBytesData.bytes, signature);
    if (recId == -1 ) {
        printf("could not find recid. Was this data signed with this key?\n");
        return nil;
    }else{
        unsigned char bin[65+4] = { 0 };
        unsigned char *rmdhash = NULL;
        int binlen = 65+4;
        int headerBytes = recId + 27 + 4;
        bin[0] = (unsigned char)headerBytes;
        memcpy(bin + 1, signature, uECC_BYTES * 2);
        
        unsigned char temp[67] = { 0 };
        memcpy(temp, bin, 65);
        memcpy(temp + 65, "K1", 2);
        
        rmdhash = RMD(temp, 67);
        memcpy(bin + 1 +  uECC_BYTES * 2, rmdhash, 4);
        
        char sigbin[100] = { 0 };
        size_t sigbinlen = 100;
        b58enc(sigbin, &sigbinlen, bin, binlen);
        
        NSString *signatureStr = [NSString stringWithFormat:@"SIG_K1_%@", [NSString stringWithUTF8String:sigbin]];
        return signatureStr;
    }
    
}

- (NSString *)excuteSignatureMessageForScatterWithActor:(NSString *)actor signatureMessage:(NSString *)messageStr andPassword:(NSString *)password{
    
    walletModel *accountInfo = [[walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"address"],[NSObject bg_sqlValue:actor]]]  lastObject];
  
    const int8_t *private_key = [[EOS_Key_Encode getRandomBytesDataWithWif:[AESCrypt decrypt:accountInfo.account_active_private_key password:password]] bytes];
    //    const int8_t *private_key = [[EOS_Key_Encode getRandomBytesDataWithWif:@"5JLHReCKAn88SdEDtDt8DzMweDdD7eiaoc6w72jWFuVR4piNh5y"] bytes];
    //     [NSObject out_Int8_t:private_key andLength:32];
    if (!private_key) {
        [TKCommonTools showToast:LocalizedString(@"请输入私钥!")];
        return nil;
    }
    
    Sha256 *sha256 = [[Sha256 alloc] initWithData:[messageStr dataUsingEncoding:NSUTF8StringEncoding]];
    int8_t signature[uECC_BYTES*2];
    int recId = uECC_sign_forbc(private_key, sha256.mHashBytesData.bytes, signature);
    if (recId == -1 ) {
        printf("could not find recid. Was this data signed with this key?\n");
        return nil;
    }else{
        unsigned char bin[65+4] = { 0 };
        unsigned char *rmdhash = NULL;
        int binlen = 65+4;
        int headerBytes = recId + 27 + 4;
        bin[0] = (unsigned char)headerBytes;
        memcpy(bin + 1, signature, uECC_BYTES * 2);
        
        unsigned char temp[67] = { 0 };
        memcpy(temp, bin, 65);
        memcpy(temp + 65, "K1", 2);
        
        rmdhash = RMD(temp, 67);
        memcpy(bin + 1 +  uECC_BYTES * 2, rmdhash, 4);
        
        char sigbin[100] = { 0 };
        size_t sigbinlen = 100;
        b58enc(sigbin, &sigbinlen, bin, binlen);
        
        NSString *signatureStr = [NSString stringWithFormat:@"SIG_K1_%@", [NSString stringWithUTF8String:sigbin]];
        NSLog(@"signatureStr %@", signatureStr);
        return signatureStr;
    }
    
}


@end
