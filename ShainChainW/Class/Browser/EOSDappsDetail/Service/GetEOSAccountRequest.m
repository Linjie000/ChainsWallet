//
//  GetEOSAccountRequest.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "GetEOSAccountRequest.h"

@implementation GetEOSAccountRequest
-(NSString *)requestUrlPath{
    return @"/get_account";
}

-(id)parameters{
    return @{@"account_name" : VALIDATE_STRING(self.account_name) };
}
@end
