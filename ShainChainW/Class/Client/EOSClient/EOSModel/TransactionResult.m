//
//  TransactionResult.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "TransactionResult.h"

@implementation TransactionResult
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"data" : @"processed",
             @"details":@"error.details"
             };
}
@end
