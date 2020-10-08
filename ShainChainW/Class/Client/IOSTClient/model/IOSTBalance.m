//
//  IOSTBalance.m
//  ShainChainW
//
//  Created by 闪链 on 2019/5/19.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "IOSTBalance.h"

@implementation IOSTBalance

+(NSDictionary *)mj_objectClassInArray{
    return @{
             @"frozen_balances"  : [FrozenBalances class]
             };
}
@end
