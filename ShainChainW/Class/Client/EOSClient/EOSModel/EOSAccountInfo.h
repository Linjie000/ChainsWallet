//
//  EOSAccountInfo.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSAccountInfo : NSObject
@property(nonatomic, copy) NSString *account_name;

@property(nonatomic, strong) NSString *account_img;

@property(nonatomic, copy) NSString *account_active_public_key;

@property(nonatomic, copy) NSString *account_owner_public_key;

@property(nonatomic, copy) NSString *account_active_private_key;

@property(nonatomic, copy) NSString *account_owner_private_key;


// 0 表示 没有隐私保护, 1 表示有隐私保护
@property(nonatomic, copy) NSString *is_privacy_policy;

@property(nonatomic, copy) NSString *is_main_account;

 
@property(nonatomic, assign) BOOL selected;
@end

NS_ASSUME_NONNULL_END
