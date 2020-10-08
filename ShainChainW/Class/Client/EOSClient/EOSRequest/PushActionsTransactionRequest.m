//
//  PushActionsTransactionRequest.m
//  ShainChainW
//
//  Created by 闪链 on 2019/6/26.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "PushActionsTransactionRequest.h"

@implementation PushActionsTransactionRequest

-(NSString *)requestUrlPath{
    return @"/push_transaction";
}

-(NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *transacDic = [NSMutableDictionary dictionary];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_prefix) forKey:@"ref_block_prefix"];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_num) forKey:@"ref_block_num"];
    [transacDic setObject:VALIDATE_STRING(self.expiration) forKey:@"expiration"];
    
    
    [transacDic setObject:@[] forKey:@"context_free_actions"];
    [transacDic setObject:@[] forKey:@"transaction_extensions"];
    
    
    
    NSMutableArray *actions_keysArr = [NSMutableArray array];
    for (EOSActionsModel *model in self.actions) {
        NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
        [actionDict setObject:VALIDATE_STRING(model.account) forKey:@"account"];
        [actionDict setObject:model.name forKey:@"name"];
        [actionDict setObject:VALIDATE_STRING(model.data) forKey:@"data"];
        NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
        [authorizationDict setObject:VALIDATE_STRING(model.sender) forKey:@"actor"];
        [authorizationDict setObject:IsStrEmpty(model.permission) ? @"active" :model.permission forKey:@"permission"];
        [actionDict setObject:@[authorizationDict] forKey:@"authorization"];
        
        [actions_keysArr addObject:actionDict];
    }
    [transacDic setObject:actions_keysArr forKey:@"actions"];
    
    
//    NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
//    [actionDict setObject:VALIDATE_STRING(self.account) forKey:@"account"];
//    [actionDict setObject:self.name forKey:@"name"];
//    [actionDict setObject:VALIDATE_STRING(self.data) forKey:@"data"];
//    
//    NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
//    [authorizationDict setObject:VALIDATE_STRING(self.sender) forKey:@"actor"];
//    [authorizationDict setObject:IsStrEmpty(self.permission) ? @"active" :self.permission forKey:@"permission"];
//    [actionDict setObject:@[authorizationDict] forKey:@"authorization"];
//    [transacDic setObject:@[actionDict] forKey:@"actions"];
    
    [params setObject:transacDic forKey:@"transaction"];
    [params setObject:@"none" forKey:@"compression"];
    [params setObject:@[self.signatureStr] forKey:@"signatures"];
    return params;
}

@end
