//
//  ExcuteActions.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExcuteActions : NSObject
@property(nonatomic , copy) NSString *actor;
@property(nonatomic , copy) NSString *to;

@property(nonatomic , copy) NSString *account;

@property(nonatomic , copy) NSString *name;

@property(nonatomic , strong) NSMutableArray *authorization;

@property(nonatomic , strong) NSMutableDictionary *data;

@property(nonatomic , copy) NSString *binargs;


@property(nonatomic , copy) NSString *tag;
@end

NS_ASSUME_NONNULL_END
