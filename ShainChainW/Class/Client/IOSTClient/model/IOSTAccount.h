//
//  IOSTAccount.h
//  ShainChainW
//
//  Created by 闪链 on 2019/5/8.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vote_Infos : NSObject

@end

@interface FrozenBalances : NSObject
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *time;
@end

@interface Groups : NSObject

@end

@interface Items : NSObject
@property (strong, nonatomic) NSString *ids;
@property (strong, nonatomic) NSString *is_key_pair;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSString *permission;
@end

@interface Active : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *group_names;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSString *threshold;
@end


@interface Pledged_Info : NSObject
@property (strong, nonatomic) NSString *pledger;
@property (strong, nonatomic) NSString *amount;
@end

@interface IOSTPermissions : NSObject
@property (strong, nonatomic) Active *active;
@property (strong, nonatomic) Active *owner;
@end

@interface Ram_Info : NSObject
@property (strong, nonatomic) NSString *available;
@property (strong, nonatomic) NSString *used;
@property (strong, nonatomic) NSString *total;
@end

@interface Gas_Info : NSObject
@property (strong, nonatomic) NSString *current_total;
@property (strong, nonatomic) NSString *transferable_gas;
@property (strong, nonatomic) NSString *pledge_gas;
@property (strong, nonatomic) NSString *increase_speed;
@property (strong, nonatomic) NSString *limit;
@property (strong, nonatomic) NSArray *pledged_info;

@property (strong, nonatomic) NSString *pledgedCount;//抵押iost数量
@end

@interface IOSTAccount : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *balance;
@property (strong, nonatomic) Gas_Info *gas_info;
@property (strong, nonatomic) Ram_Info *ram_info;
@property (strong, nonatomic) IOSTPermissions *permissions;
@property (strong, nonatomic) Groups *groups;
@property (strong, nonatomic) NSArray *frozen_balances;
@property (strong, nonatomic) NSArray *vote_infos;
//add
@property (strong, nonatomic) NSString *unpledgedCount;//赎回中的iosts数量
@end

