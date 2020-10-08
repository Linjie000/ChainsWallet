//
//  EOSNewAccount_json_to_bin_request.m
//  ShainChainW
//
//  Created by 闪链 on 2019/6/25.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSNewAccount_json_to_bin_request.h"

@implementation EOSNewAccount_json_to_bin_request
-(NSString *)requestUrlPath{
    return @"/abi_json_to_bin?apikey=d1b9a43576fab92c4b25a10cf5ae6ce8";
}

-(NSDictionary *)parameters{
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: VALIDATE_STRING(self.code) forKey:@"code"];
    [params setObject:VALIDATE_STRING(self.action) forKey:@"action"];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:VALIDATE_STRING(self.creator) forKey:@"creator"];
    [args setObject:VALIDATE_STRING(self.name) forKey:@"name"];
    
    //owner
    NSMutableDictionary *owner = [NSMutableDictionary dictionary];
    [owner setObject:@(1) forKey:@"threshold"];
    [owner setObject:@[] forKey:@"accounts"];
    [owner setObject:@[] forKey:@"waits"];
    NSMutableArray *ownerkeys = [NSMutableArray new];
    [ownerkeys addObject:@{@"key":VALIDATE_STRING(self.ownerKey),@"weight":@(1)}];
    [owner setObject:ownerkeys forKey:@"keys"];
    
    //active
    NSMutableDictionary *active = [NSMutableDictionary dictionary];
    [active setObject:@(1) forKey:@"threshold"];
    [active setObject:@[] forKey:@"accounts"];
    [active setObject:@[] forKey:@"waits"];
    NSMutableArray *activekeys = [NSMutableArray new];
    [activekeys addObject:@{@"key":VALIDATE_STRING(self.activeKey),@"weight":@(1)}];
    [active setObject:activekeys forKey:@"keys"];
    
    [args setObject:owner forKey:@"owner"];
    [args setObject:active forKey:@"active"];
    
    [params setObject:args forKey:@"args"];
    return params;
}
@end
