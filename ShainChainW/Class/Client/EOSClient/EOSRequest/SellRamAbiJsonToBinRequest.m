//
//  SellRamAbiJsonToBinRequest.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/8.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SellRamAbiJsonToBinRequest.h"

@implementation SellRamAbiJsonToBinRequest
-(NSString *)requestUrlPath{
    return @"/abi_json_to_bin";
}

-(NSDictionary *)parameters{
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: VALIDATE_STRING(self.code) forKey:@"code"];
    [params setObject:VALIDATE_STRING(self.action) forKey:@"action"];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:VALIDATE_STRING(self.account) forKey:@"account"];
    [args setObject:VALIDATE_STRING(self.bytes) forKey:@"bytes"];
    [params setObject:args forKey:@"args"];
    return params;
}
@end
