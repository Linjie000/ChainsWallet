//
//  EOSPermission.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSPermission : NSObject
// active / owner
@property(nonatomic, copy) NSString *perm_name;
// active / owner  public key
@property(nonatomic, copy) NSString *required_auth_key;

@property(nonatomic , strong) NSArray *required_auth_keyArray;
@end

NS_ASSUME_NONNULL_END
