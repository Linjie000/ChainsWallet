//
//  ApproveAbiJsonToBinRequest.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/9.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "ApproveAbiJsonToBinRequest.h"

@implementation ApproveAbiJsonToBinRequest

-(NSString *)requestUrlPath{
    return @"/abi_json_to_bin?apikey=d1b9a43576fab92c4b25a10cf5ae6ce8";
}

-(NSDictionary *)parameters{
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: VALIDATE_STRING(self.code) forKey:@"code"];
    [params setObject:VALIDATE_STRING(self.action) forKey:@"action"];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:VALIDATE_STRING(self.from) forKey:@"from"];
    [args setObject:VALIDATE_STRING(self.receiver) forKey:@"receiver"];
    [args setObject:VALIDATE_STRING(self.stake_net_quantity) forKey:@"stake_net_quantity"];
    [args setObject:VALIDATE_STRING(self.stake_cpu_quantity) forKey:@"stake_cpu_quantity"];
    [args setObject:VALIDATE_STRING(self.transfer) forKey:@"transfer"];
    [params setObject:args forKey:@"args"];
    return params;
}
@end
