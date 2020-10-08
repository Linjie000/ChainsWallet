//
//  EOSClient.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetEOSAccountRequest.h"
#import "EOSAccount.h"
#import "EOSTracelistModel.h"
#import "EOSTokenListModel.h"

NS_ASSUME_NONNULL_BEGIN

#define EOSParkKey @"d1b9a43576fab92c4b25a10cf5ae6ce8"

@interface EOSClient : NSObject

//获取账号信息 GetEOSAccountRequest
+ (void)GetEOSAccountRequestWithName:(NSString *)name
                              handle:(void (^)(EOSAccount *eosAccount))success;

//获取交易记录
+ (void)getEOSTransferRecordAccountName:(NSString *)account
                                   page:(NSInteger)page
                                 symbol:(NSString *)symbol
                                   code:(NSString *)code
                                 handle:(void (^)(NSMutableArray *tracelist))handle;


+ (void)getEOSTokenListAccountName:(NSString *)account
                            handle:(void (^)(EOSTokenListModel *listModel))handle;


+ (void)getRamPricehandle:(void (^)(double price))handle;


//创建账号
- (void)createEOSAccountCreator:(NSString *)creator
                           name:(NSString *)name
                       ownerKey:(NSString *)ownerkey
                      activeKey:(NSString *)activekey
                    walletModel:(walletModel *)wallet
                       password:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
