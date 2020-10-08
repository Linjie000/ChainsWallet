//
//  IOSTAccount.m
//  ShainChainW
//
//  Created by 闪链 on 2019/5/8.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "IOSTAccount.h"
@implementation Vote_Infos

@end

@implementation FrozenBalances

@end

@implementation Groups

@end

@implementation Items
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ids" : @"id"
             };
}
@end

@implementation Active
+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"items"  : [Items class] 
             };
}
@end

@implementation Pledged_Info

@end

@implementation IOSTPermissions
+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"active"  : [Active class],
             @"owner"  : [Active class]
             };
}
@end

@implementation Ram_Info

@end

@implementation Gas_Info
+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"pledged_info"  : [Pledged_Info class]
             };
}

- (void)setPledged_info:(NSArray *)pledged_info
{
    //计算抵押总数
    CGFloat count = 0;
    for (Pledged_Info *pledgeinfo in pledged_info) {
        count += [pledgeinfo.amount floatValue];
    }
    self.pledgedCount = [NSString stringWithFormat:@"%.1f",count];
}

@end

@implementation IOSTAccount
+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"frozen_balances"  : [FrozenBalances class],
             @"vote_infos"  : [Vote_Infos class]
             };
}

- (void)setFrozen_balances:(NSArray *)frozen_balances
{
    //计算赎回总数
    CGFloat count = 0;
    for (FrozenBalances *frozenBalances in frozen_balances) {
        count += [frozenBalances.amount floatValue];
    }
    self.unpledgedCount = [NSString stringWithFormat:@"%.1f",count];
}


@end
