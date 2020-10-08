//
//  EOSPermission.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSPermission.h"

@implementation EOSPermission
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"required_auth_key" : @"required_auth.keys[0].key",
             @"required_auth_keyArray": @"required_auth.keys"
             };
}

+(NSDictionary *)objectClassInArray{
    return @{
             @"required_auth_keyArray" : @"Key"
             };
}

@end
