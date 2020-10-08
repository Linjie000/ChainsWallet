//
//  IOSTTransactionObject.h
//  ShainChainW
//
//  Created by 闪链 on 2019/5/19.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOSTAmountLimit : NSObject
@property (strong,nonatomic) NSString *token;
@property (strong,nonatomic) NSString *value; 
@end

@interface IOSTAction : NSObject
@property (strong,nonatomic) NSString *contract;
@property (strong,nonatomic) NSString *action_name;
@property (strong,nonatomic) NSString *data;
@end

@interface IOSTTransactionObject : NSObject

@property (strong,nonatomic) NSString *gas_ratio;
@property (strong,nonatomic) NSString *gas_limit;
@property (strong,nonatomic) NSString *time;
@property (strong,nonatomic) NSString *expiration;
@property (strong,nonatomic) NSString *delay;
@property (strong,nonatomic) NSString *chain_id;

@property (strong,nonatomic) NSMutableArray *signs;
@property (strong,nonatomic) NSMutableArray *actions;
@property (strong,nonatomic) NSMutableArray *publisher_sigs;
@property (strong,nonatomic) NSMutableArray *signers;
@property (strong,nonatomic) NSMutableArray *amount_limit;
@property (strong,nonatomic) NSMutableArray *signatures;
@property (strong,nonatomic) NSMutableArray *reserved;
@property (strong,nonatomic) NSString *publisher;
 

@end

