//
//  Get_key_accounts_request.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"

 
NS_ASSUME_NONNULL_BEGIN

@interface Get_key_accounts_request : EOSRequestManager
@property(nonatomic, copy) NSString *public_key;

- (void)get_key_accounts:(CompleteBlock)complete;
@end

NS_ASSUME_NONNULL_END
