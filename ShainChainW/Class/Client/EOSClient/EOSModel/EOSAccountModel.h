//
//  EOSAccountModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSAccountModel : NSObject
@property(nonatomic , copy) NSString *accountName;
@property(nonatomic , copy) NSString *ownerPrivateKey;
@property(nonatomic , copy) NSString *activePrivateKey;

// 账号状态 0 ：未导入 1 ： 已经导入 2 ：导入失败 3 :本地存在 4:权限错误
@property(nonatomic , assign) NSUInteger status;
@end

NS_ASSUME_NONNULL_END
