//
//  EOSAccount.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/3.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RequiredAuth;
@class SelfDelegatedBandwidth;
@class Permissions;
@class EOSAccount;
@class Keys;
@class VoterInfo;
@class TotalResources;
NS_ASSUME_NONNULL_BEGIN

@interface SelfDelegatedBandwidth : NSObject
@property(strong, nonatomic) NSString *cpu_weight;
@property(strong, nonatomic) NSString *from;
@property(strong, nonatomic) NSString *net_weight;
@property(strong, nonatomic) NSString *to;
@end

@interface Permissions : NSObject
@property(strong, nonatomic) NSString *parent;
@property(strong, nonatomic) NSString *perm_name;
@property(strong, nonatomic) RequiredAuth *required_auth;
@end

@interface RequiredAuth : NSObject
@property(strong, nonatomic) NSArray *waits;
@property(strong, nonatomic) NSArray *accounts;
@property(strong, nonatomic) NSArray<Keys *> *keys;
@property(strong, nonatomic) NSString *threshold;
@end

@interface Keys : NSObject
@property(strong, nonatomic) NSString *key;
@property(strong, nonatomic) NSString *weight;

@end

@interface TotalResources : NSObject
@property(strong, nonatomic) NSString *cpu_weight;
@property(strong, nonatomic) NSString *net_weight;
@property(strong, nonatomic) NSString *owner;
@property(strong, nonatomic) NSString *ram_bytes;
@end

@interface VoterInfo : NSObject
@property(strong, nonatomic) NSString *flags1;
@property(strong, nonatomic) NSString *is_proxy;
@property(strong, nonatomic) NSString *last_vote_weight;
@property(strong, nonatomic) NSString *owner;
@property(strong, nonatomic) NSString *proxied_vote_weight;
@property(strong, nonatomic) NSString *proxy;
@property(strong, nonatomic) NSString *reserved2;
@property(strong, nonatomic) NSString *reserved3;
@property(strong, nonatomic) NSString *staked;
@property(strong, nonatomic) NSArray  *producers;
@end

@interface NetLimit : NSObject
@property(strong, nonatomic) NSString *used;
@property(strong, nonatomic) NSString *available;
@property(strong, nonatomic) NSString *max;
@end

@interface CpuLimit : NSObject
@property(strong, nonatomic) NSString *used;
@property(strong, nonatomic) NSString *available;
@property(strong, nonatomic) NSString *max;
@end

@interface EOSAccount : NSObject

@property(strong, nonatomic) NSString *core_liquid_balance;
@property(strong, nonatomic) NSString *ram_quota;
@property(strong, nonatomic) NSString *ram_usage;
@property(strong, nonatomic) SelfDelegatedBandwidth *self_delegated_bandwidth;
@property(strong, nonatomic) NSString *cpu_weight;
@property(strong, nonatomic) NSArray<Permissions*> *permissions;
@property(strong, nonatomic) CpuLimit *cpu_limit;
@property(strong, nonatomic) NSString *last_code_update;
@property(strong, nonatomic) NSString *account_name;
@property(strong, nonatomic) NSString *voter_info;
@property(strong, nonatomic) NSString *refund_request;
@property(strong, nonatomic) NSString *head_block_time;
@property(strong, nonatomic) NetLimit *net_limit;
@property(strong, nonatomic) NSString *privileged;
@property(strong, nonatomic) NSString *created;
@property(strong, nonatomic) NSString *net_weight;
@property(strong, nonatomic) TotalResources *total_resources;
@property(strong, nonatomic) NSString *head_block_num;

@end

NS_ASSUME_NONNULL_END
