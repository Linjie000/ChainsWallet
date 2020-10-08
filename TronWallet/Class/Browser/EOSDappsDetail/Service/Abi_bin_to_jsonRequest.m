//
//  Abi_bin_to_jsonRequest.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "Abi_bin_to_jsonRequest.h"

@implementation Abi_bin_to_jsonRequest
-(NSString *)requestUrlPath{
    return @"/abi_bin_to_json";
}

-(NSDictionary *)parameters{
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: VALIDATE_STRING(self.code) forKey:@"code"];
    [params setObject:VALIDATE_STRING(self.action) forKey:@"action"];
    [params setObject:VALIDATE_STRING(self.binargs) forKey:@"binargs"];
    return [self clearEmptyObject:params];
}

- (NSDictionary *)clearEmptyObject:(NSDictionary *)dic{
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionaryWithDictionary: dic];
    for(id key in [newDictionary allKeys]){
        id value = [newDictionary objectForKey: key];
        if([value isKindOfClass: [NSNull class]]){
            [newDictionary removeObjectForKey: key];
        }
        if([value isKindOfClass: [NSString class]]){
            if(IsStrEmpty(value)){
                [newDictionary removeObjectForKey: key];
            }
        }
        if([value isKindOfClass: [NSArray class]] || [value isKindOfClass: [NSMutableArray class]]){
            if([value count] == 0){
                [newDictionary removeObjectForKey: key];
            }
        }
        if([value isKindOfClass: [NSSet class]] || [value isKindOfClass: [NSMutableSet class]]){
            if([value count] == 0){
                [newDictionary removeObjectForKey: key];
            }
        }
    }
    return newDictionary;
}
@end
