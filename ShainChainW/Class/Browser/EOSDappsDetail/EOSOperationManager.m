//
//  EOSOperationManager.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSOperationManager.h"

@implementation EOSOperationManager
static EOSOperationManager *_ModelClass;

+(EOSOperationManager *)shareManage
{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _ModelClass = [[EOSOperationManager alloc]init]; 
    });
    return _ModelClass;
}
@end
