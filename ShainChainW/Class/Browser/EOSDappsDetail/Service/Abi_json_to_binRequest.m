//
//  Abi_json_to_binRequest.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "Abi_json_to_binRequest.h"

@implementation Abi_json_to_binRequest
-(NSString *)requestUrlPath{
    return @"/abi_json_to_bin";
}

-(NSDictionary *)parameters{
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: VALIDATE_STRING(self.code) forKey:@"code"];
    [params setObject:VALIDATE_STRING(self.action) forKey:@"action"];
    [params setObject:self.args forKey:@"args"];
    return [RewardHelper clearEmptyObject:params];
}

@end
