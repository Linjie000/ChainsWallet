//
//  ExcuteMutipleActionsGetRequiredPublicKeyRequest.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/2.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"
#import "ExcuteActions.h"

@interface ExcuteMutipleActionsGetRequiredPublicKeyRequest : EOSRequestManager
@property(nonatomic, copy) NSString *ref_block_prefix;
@property(nonatomic, copy) NSString *ref_block_num;
@property(nonatomic, copy) NSString *expiration;

@property(nonatomic, copy) NSString *sender;


@property(nonatomic , strong) NSArray *excuteActionsArray;

@property(nonatomic, strong) NSArray *available_keys;

@end
