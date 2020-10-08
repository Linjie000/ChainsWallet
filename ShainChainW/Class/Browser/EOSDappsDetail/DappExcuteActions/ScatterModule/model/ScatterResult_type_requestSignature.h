//
//  ScatterResult_type_requestSignature.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScatterResult_type_requestSignature : NSObject

@property(nonatomic , copy) NSString *scatterResult_id;

@property(nonatomic , copy) NSString *expiration;

@property(nonatomic , copy) NSString *ref_block_num;

@property(nonatomic , copy) NSString *ref_block_prefix;

@property(nonatomic , copy) NSString *chainId;

@property(nonatomic , copy) NSString *actor;

@property(nonatomic , copy) NSString *permission;

@property(nonatomic , strong) NSArray *actions;

@property(nonatomic , strong) NSMutableDictionary *transaction;

@property(nonatomic , copy) NSString *requestSignatureMessage;

@end

NS_ASSUME_NONNULL_END
