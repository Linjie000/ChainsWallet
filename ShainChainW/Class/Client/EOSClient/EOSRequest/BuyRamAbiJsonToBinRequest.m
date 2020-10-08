//
//  BuyRamAbiJsonToBinRequest.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/8.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BuyRamAbiJsonToBinRequest.h"

@implementation BuyRamAbiJsonToBinRequest

-(NSString *)requestUrlPath{
    return @"/abi_json_to_bin?apikey=d1b9a43576fab92c4b25a10cf5ae6ce8";
}

-(NSDictionary *)parameters{
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: VALIDATE_STRING(self.code) forKey:@"code"];
    [params setObject:VALIDATE_STRING(self.action) forKey:@"action"];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:VALIDATE_STRING(self.payer) forKey:@"payer"];
    [args setObject:VALIDATE_STRING(self.receiver) forKey:@"receiver"];
    [args setObject:VALIDATE_STRING(self.quant) forKey:@"quant"];
    [params setObject:args forKey:@"args"];
    return params;
}
@end
