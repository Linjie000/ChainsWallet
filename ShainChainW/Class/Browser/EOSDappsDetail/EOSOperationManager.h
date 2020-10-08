//
//  EOSOperationManager.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSOperationManager : NSObject
@property (nonatomic, strong) walletModel* wallet;
+ (EOSOperationManager *)shareManage;
@end

NS_ASSUME_NONNULL_END
