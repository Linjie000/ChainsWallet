//
//  TransferService.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "TransferService.h"
#import "GetBlockChainInfoRequest.h"
#import "EOSBlockChainInfo.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NSDate+ExFoundation.h"
#import "NSObject+Extension.h"
#import "GetRequiredPublicKeyRequest.h"
#import "PushTransactionRequest.h"
#import "AESCrypt.h"
#import "EOS_Key_Encode.h"
#import "Sha256.h"
#import "uECC.h"
#import "EosByteWriter.h"
#import "rmd160.h"
#import <ethers/base58.h>
#import "NSData+Hashing.h"

@interface TransferService ()
@property(strong, nonatomic) GetBlockChainInfoRequest *getBlockChainInfoRequest;
@property(strong, nonatomic) GetRequiredPublicKeyRequest *getRequiredPublicKeyRequest;
@property(strong, nonatomic) PushTransactionRequest *pushTransactionRequest;

@property(nonatomic, strong) JSContext *context;
@property(nonatomic, copy) NSString *ref_block_prefix;

@property(nonatomic , strong) NSData *chain_Id;
@property(nonatomic, copy) NSString *expiration;
@property(nonatomic, copy) NSString *required_Publickey;

@end

@implementation TransferService

- (PushTransactionRequest *)pushTransactionRequest{
    if (!_pushTransactionRequest) {
        _pushTransactionRequest = [[PushTransactionRequest alloc] init];
    }
    return _pushTransactionRequest;
}

- (GetRequiredPublicKeyRequest *)getRequiredPublicKeyRequest{
    if (!_getRequiredPublicKeyRequest) {
        _getRequiredPublicKeyRequest = [[GetRequiredPublicKeyRequest alloc] init];
    }
    return _getRequiredPublicKeyRequest;
}

- (GetBlockChainInfoRequest *)getBlockChainInfoRequest{
    if (!_getBlockChainInfoRequest) {
        _getBlockChainInfoRequest = [[GetBlockChainInfoRequest alloc] init];
    }
    return _getBlockChainInfoRequest;
}

- (JSContext *)context{
    if (!_context) {
        _context = [[JSContext alloc] init];
    }
    return _context;
}

// pushTransaction
- (void)pushTransaction{
    [self getBlockChainInfoOperation];
}

- (void)getBlockChainInfoOperation{
    [self.getBlockChainInfoRequest getRequestDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
#pragma mark -- [@"data"]
            EOSBlockChainInfo *model = [EOSBlockChainInfo mj_objectWithKeyValues:data];
            self.expiration = [[[NSDate dateFromString: model.head_block_time] dateByAddingTimeInterval: 30] formatterToISO8601];
            self.ref_block_num = [NSString stringWithFormat:@"%@",model.head_block_num];
            
            NSString *js = @"function readUint32( tid, data, offset ){var hexNum= data.substring(2*offset+6,2*offset+8)+data.substring(2*offset+4,2*offset+6)+data.substring(2*offset+2,2*offset+4)+data.substring(2*offset,2*offset+2);var ret = parseInt(hexNum,16).toString(10);return(ret)}";
            [self.context evaluateScript:js];
            JSValue *n = [self.context[@"readUint32"] callWithArguments:@[@8,VALIDATE_STRING(model.head_block_id) , @8]];
            
            self.ref_block_prefix = [n toString];
            
            self.chain_Id = [NSObject convertHexStrToData:model.chain_id];
            NSLog(@"get_block_info_success:%@, %@---%@-%@", self.expiration , self.ref_block_num, self.ref_block_prefix, self.chain_Id);
            
            [self getRequiredPublicKeyRequestOperation];
        }
    } failure:^(id DAO, NSError *error) {
        
    }];
 
}

- (void)getRequiredPublicKeyRequestOperation{
    self.getRequiredPublicKeyRequest.ref_block_prefix = self.ref_block_prefix;
    self.getRequiredPublicKeyRequest.ref_block_num = self.ref_block_num;
    self.getRequiredPublicKeyRequest.expiration = self.expiration;
    self.getRequiredPublicKeyRequest.sender = self.sender;
    self.getRequiredPublicKeyRequest.data = self.binargs;
    self.getRequiredPublicKeyRequest.account = self.code;
    self.getRequiredPublicKeyRequest.name = self.action;
    self.getRequiredPublicKeyRequest.available_keys = self.available_keys;
    self.getRequiredPublicKeyRequest.permission = self.permission;
 
    [self.getRequiredPublicKeyRequest postRequestDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        if (data) {
            self.required_Publickey = data[@"required_keys"][0];
            [self pushTransactionRequestOperation];

        }else{
            [TKCommonTools showToast:VALIDATE_STRING(data[@"message"])];
        }

    } failure:^(id DAO, NSError *error) {
    }];
}

- (void)pushTransactionRequestOperation{
    walletModel *accountInfo = [UserinfoModel shareManage].wallet;
    NSString *wif;
    if ([accountInfo.account_owner_public_key isEqualToString:self.required_Publickey]) {
        wif = [AESCrypt decrypt:accountInfo.account_owner_private_key password:self.password];
    }else if ([accountInfo.account_active_public_key isEqualToString:self.required_Publickey]) {
        wif = [AESCrypt decrypt:accountInfo.account_active_private_key password:self.password];
    }else{
        [TKCommonTools showToast:LocalizedString(@"未找到账号的私钥!")];
        return;
    }
    if (IsStrEmpty(wif)) {
        [TKCommonTools showToast:LocalizedString(@"密码错误")];
        return;
    }
    const int8_t *private_key = [[EOS_Key_Encode getRandomBytesDataWithWif:wif] bytes];
//         [NSObject out_Int8_t:private_key andLength:32];
    if (!private_key) {
        [TKCommonTools showToast:LocalizedString(@"私钥不能为空!")];
        return;
    }
    
    Sha256 *sha256 = [[Sha256 alloc] initWithData:[EosByteWriter getBytesForSignature:self.chain_Id andParams: [[self.getRequiredPublicKeyRequest parameters] objectForKey:@"transaction"] andCapacity:255]];
    int8_t signature[uECC_BYTES*2];
    int recId = uECC_sign_forbc(private_key, sha256.mHashBytesData.bytes, signature);
    if (recId == -1 ) {
        printf("could not find recid. Was this data signed with this key?\n");
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
        NSString *packed_trxHexStr = [[EosByteWriter getBytesForSignature:nil andParams: [[self.getRequiredPublicKeyRequest parameters] objectForKey:@"transaction"] andCapacity:512] hexadecimalString];
        
//        self.pushTransactionRequest.packed_trx = packed_trxHexStr;
//        self.pushTransactionRequest.signatureStr = signatureStr;
        self.pushTransactionRequest.ref_block_prefix = self.ref_block_prefix;
        self.pushTransactionRequest.ref_block_num = self.ref_block_num;
        self.pushTransactionRequest.expiration = self.expiration;
        self.pushTransactionRequest.sender = self.sender;
        self.pushTransactionRequest.data = self.binargs;
        self.pushTransactionRequest.account = self.code;
        self.pushTransactionRequest.name = self.action; 
        self.pushTransactionRequest.permission = self.permission;
        self.pushTransactionRequest.signatureStr = signatureStr;
        NSLog(@"pushTransactionRequest  %@", [[self.pushTransactionRequest parameters] mj_JSONObject]);
        
        [self.pushTransactionRequest postRequestDataSuccess:^(id DAO, id data) {
            NSLog(@"success: -- %@",data );
            [SVProgressHUD dismiss];
            TransactionResult *result = [TransactionResult mj_objectWithKeyValues:data];
            
            if (self.pushTransactionType == PushTransactionTypeTransfer) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(pushTransactionDidFinish:)]) {
                    [self.delegate pushTransactionDidFinish:result];
                }
            }
        } failure:^(id DAO, NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(pushTransactionDidFinish:)]) {
                [self.delegate pushTransactionDidFinish:nil];
            }
        }];
    }
}


@end
