//
//  EOSGetAccount.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSGetAccount.h"
#import "EOSPermission.h"

@implementation EOSGetAccount
+(NSDictionary *)objectClassInArray{
    return @{@"permissions"  : [EOSPermission class]};
}
@end
