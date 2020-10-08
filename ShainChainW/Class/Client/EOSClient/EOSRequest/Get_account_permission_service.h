//
//  Get_account_permission_service.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface Get_account_permission_service : EOSRequestManager
@property(nonatomic, strong) NSString *name;

@property(nonatomic , strong) NSMutableArray *chainAccountOwnerPublicKeyArray;
@property(nonatomic , strong) NSMutableArray *chainAccountActivePublicKeyArray;

- (void)getAccountPermission:(CompleteBlock)complete;
@end

NS_ASSUME_NONNULL_END
