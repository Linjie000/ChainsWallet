//
//  EOSGetAccountResult.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class EOSGetAccount;
@interface EOSGetAccountResult : NSObject
@property(nonatomic, strong) NSNumber *code;
@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) EOSGetAccount *data;
@end

NS_ASSUME_NONNULL_END
