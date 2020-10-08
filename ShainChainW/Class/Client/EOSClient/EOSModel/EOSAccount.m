//
//  EOSAccount.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/3.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSAccount.h"

@implementation RequiredAuth
+(NSDictionary *)mj_objectClassInArray{
    return @{@"keys"  : [Keys class]};
}
@end

@implementation SelfDelegatedBandwidth

@end

@implementation Permissions

@end

@implementation EOSAccount
+(NSDictionary *)mj_objectClassInArray{
    return @{@"permissions"  : [Permissions class]};
}
@end

@implementation Keys

@end

@implementation VoterInfo

@end

@implementation NetLimit

@end

@implementation CpuLimit

@end

@implementation TotalResources

@end
 
