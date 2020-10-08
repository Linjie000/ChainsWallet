//
//  EOSMappingResult.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSMappingResult.h"

@implementation EOSMappingResult
+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"account_names" : @"data.account_names"};
}
@end
