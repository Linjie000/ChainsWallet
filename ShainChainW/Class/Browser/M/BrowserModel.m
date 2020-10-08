//
//  BrowserModel.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BrowserModel.h"
#import "LabelIDsModel.h"

@implementation BrowserModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"news" : @"new"//前边的是你想用的key，后边的是返回的key
             };
}
 

@end
