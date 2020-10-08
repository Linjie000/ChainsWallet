//
//  SCRootTool.h
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/27.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCRootTool : NSObject
+ (void)chooseRootController:(UIWindow *)window;

+ (void)creatWallet;

+ (void)delectWalletWithID:(NSNumber *)walletid handle:(void(^)(BOOL result))handle;

+ (void)creatCoins:(NSString*)coinName withEnglishName:(NSString*)englishName withCointype:(int)type withAddressprefix:(int)addressprefix withPriveprefix:(int)priveprefix withRecordtype:(NSString*)recordType withID:(NSNumber*)ID totalAmount:(NSString *)totalAmount   withWallet:(walletModel*)wallet contractAddress:(NSString *)contractAddress;

+ (void)checkSystemWalletCreate;
@end

NS_ASSUME_NONNULL_END
