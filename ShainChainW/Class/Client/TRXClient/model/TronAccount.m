//
//  TronAccount.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "TronAccount.h"

@implementation TronAccount
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{ 
             @"address2": @"address"
             };
}
+ (NSDictionary *)mj_objectClassInArray{
    
    return @{ @"frozen" : @"Account_Frozen" };
}
@end

@implementation Account_Frozen

 
@end

@implementation Vote

@end

@implementation AccountResource

@end
@implementation AccountNetMessage

@end
@implementation AccountResourceMessage

@end

 
