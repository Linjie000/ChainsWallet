//
//  GetRequiredPublicKeyActionsRequest.m
//  ShainChainW
//
//  Created by 闪链 on 2019/6/26.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "GetRequiredPublicKeyActionsRequest.h"

@implementation GetRequiredPublicKeyActionsRequest
-(NSString *)requestUrlPath{
    return @"/get_required_keys";
}

-(NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *transacDic = [NSMutableDictionary dictionary];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_prefix) forKey:@"ref_block_prefix"];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_num) forKey:@"ref_block_num"];
    [transacDic setObject:VALIDATE_STRING(self.expiration) forKey:@"expiration"];
    
    [transacDic setObject:@[] forKey:@"context_free_data"];
    [transacDic setObject:@[] forKey:@"signatures"];
    [transacDic setObject:@[] forKey:@"context_free_actions"];
    [transacDic setObject:@0 forKey:@"delay_sec"];
    [transacDic setObject:@0 forKey:@"max_kcpu_usage"];
    [transacDic setObject:@0 forKey:@"max_net_usage_words"];
    
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
    
    [params setObject:transacDic forKey:@"transaction"];
    
    NSMutableArray *available_keysArr = [NSMutableArray array];
    for (NSString *publicKey in self.available_keys) {
        if ([publicKey hasPrefix:@"EOS"]) {
            [available_keysArr addObject: publicKey];
        }
    }
    [params setObject:VALIDATE_ARRAY(available_keysArr) forKey:@"available_keys"];
    
    return params;
}
@end
