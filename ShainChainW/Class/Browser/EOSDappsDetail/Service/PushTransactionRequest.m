//
//  PushTransactionRequest.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "PushTransactionRequest.h"

@implementation PushTransactionRequest
-(NSString *)requestUrlPath{
    return @"/push_transaction";
}

//-(NSDictionary *)parameters{
//    NSMutableDictionary *transacDic = [NSMutableDictionary dictionary];
//    [transacDic setObject:VALIDATE_STRING(self.packed_trx) forKey:@"packed_trx"];
//    [transacDic setObject:@[self.signatureStr] forKey:@"signatures"];
//    [transacDic setObject:@"none" forKey:@"compression"];
//    [transacDic setObject:@"00" forKey:@"packed_context_free_data"];
//    return transacDic;
//}

-(NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *transacDic = [NSMutableDictionary dictionary];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_prefix) forKey:@"ref_block_prefix"];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_num) forKey:@"ref_block_num"];
    [transacDic setObject:VALIDATE_STRING(self.expiration) forKey:@"expiration"];
    
 
    [transacDic setObject:@[] forKey:@"context_free_actions"];
    [transacDic setObject:@[] forKey:@"transaction_extensions"];
 
    
    NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
    [actionDict setObject:VALIDATE_STRING(self.account) forKey:@"account"];
    [actionDict setObject:self.name forKey:@"name"];
    [actionDict setObject:VALIDATE_STRING(self.data) forKey:@"data"];
    
    NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
    [authorizationDict setObject:VALIDATE_STRING(self.sender) forKey:@"actor"];
    [authorizationDict setObject:IsStrEmpty(self.permission) ? @"active" :self.permission forKey:@"permission"];
    [actionDict setObject:@[authorizationDict] forKey:@"authorization"];
    [transacDic setObject:@[actionDict] forKey:@"actions"];
    
    [params setObject:transacDic forKey:@"transaction"];
    [params setObject:@"none" forKey:@"compression"];
    [params setObject:@[self.signatureStr] forKey:@"signatures"];
    return params;
}

@end
