//
//  EOSTracelistModel.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/4.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSTracelistModel.h"
 
@implementation EOSTracelistData

@end

@implementation EOSTracelistModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"_id" : @"id"
             };
}
@end
