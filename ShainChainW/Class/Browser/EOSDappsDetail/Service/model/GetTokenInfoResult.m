//
//  GetTokenInfoResult.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/3.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "GetTokenInfoResult.h"

@implementation GetTokenInfoResult
+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             
             @"data" : @"EOSTokenInfo"
             
             };
}
@end
