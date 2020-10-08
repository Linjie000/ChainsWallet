//
//  LabelIDsModel.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "LabelIDsModel.h"

@implementation LabelIDsModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"dappCategory_id" : @"id"
             };
}
@end
