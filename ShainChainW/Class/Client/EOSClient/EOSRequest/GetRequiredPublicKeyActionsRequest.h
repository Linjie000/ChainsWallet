//
//  GetRequiredPublicKeyActionsRequest.h
//  ShainChainW
//
//  Created by 闪链 on 2019/6/26.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"
#import "EOSActionsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GetRequiredPublicKeyActionsRequest : EOSRequestManager
@property(nonatomic, copy) NSString *ref_block_prefix;
@property(nonatomic, copy) NSString *ref_block_num;
@property(nonatomic, copy) NSString *expiration;

@property(nonatomic, copy) NSArray *actions;
//数组
//@property(nonatomic, copy) NSString *sender;
//@property(nonatomic, copy) NSString *data;
//@property(nonatomic, copy) NSString *account;
//@property(nonatomic , copy) NSString *name;
//@property(nonatomic , copy) NSString *permission;

@property(nonatomic, strong) NSArray *available_keys;


@end

NS_ASSUME_NONNULL_END
