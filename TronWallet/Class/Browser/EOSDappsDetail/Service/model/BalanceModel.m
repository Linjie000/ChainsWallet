//
//  BalanceModel.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BalanceModel.h"

@implementation BalanceModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"balance" : @"data.rows[0].balance",
             };
}
@end
