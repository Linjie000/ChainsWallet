//
//  EOSGetAccount.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSGetAccount : NSObject
@property(nonatomic, strong) NSString *staked_balance;
@property(nonatomic, strong) NSString *account_name;
@property(nonatomic, strong) NSString *last_unstaking_time;
@property(nonatomic, strong) NSString *unstaking_balance;
@property(nonatomic, strong) NSString *eos_balance;
@property(nonatomic, strong) NSArray *permissions;

@property(nonatomic, strong) NSArray *ownerPermission_keys;
@property(nonatomic, strong) NSArray *activePermission_keys;
@end

NS_ASSUME_NONNULL_END
