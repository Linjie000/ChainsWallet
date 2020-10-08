//
//  CreateWalletTool.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreateWalletTool : NSObject
+ (void)creatBTCWallet:(BOOL)witness;
+ (void)createTRXWallet;
+ (void)creatETHWallet:(Account *)account success:(void(^)(BOOL result))block;
+ (void)createATOMWallet; 
@end

NS_ASSUME_NONNULL_END
