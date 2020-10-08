//
//  TransactionsResult.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/4.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "TransactionsResult.h"

@implementation TransactionsResult
+(NSDictionary *)mj_objectClassInArray{
    return @{ @"actions" : @"TransactionRecord"};
}
@end
