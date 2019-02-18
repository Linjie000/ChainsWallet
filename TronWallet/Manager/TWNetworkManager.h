//
//  EANetworkmanager.h
//  FunApp
//
//  Created by chunhui on 16/6/1.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Api.pbrpc.h"

#define AppHost  [TWNetworkManager appHost]


@interface TWNetworkManager : NSObject

@property(nonatomic , strong,readonly) Wallet *walletClient;
@property(nonatomic , strong,readonly) WalletSolidity *walletSolidityClient;
@property(nonatomic , strong,readonly) Network *networkClient;
@property(nonatomic , strong,readonly) Database *databaseClient;

DEF_SINGLETON;

/**
 *  应用主的host
 *
 *  @return host
 */
+(NSString *)appHost;

-(NSString *)ip;

-(NSString *)port;

-(void)resetToDefault;

-(void)resetIp:(NSString *)ip andPort:(NSString *)port;

//-(void)resetToken;

//-(void)setRequestSerializer:(BOOL)isJson resetAuthorization:(BOOL)resetAuth;

@end
