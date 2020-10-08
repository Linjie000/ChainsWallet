//
//  EOSBaseResult.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSBaseResult : NSObject
@property(nonatomic , strong) NSNumber *code;
@property(nonatomic , copy) NSString *message;
@property(nonatomic , copy) NSString *msg;

@end

NS_ASSUME_NONNULL_END
