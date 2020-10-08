//
//  SCAddressBookController.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/9.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface SCAddressBookController : SCBaseViewController
 
@property(assign,nonatomic) NSString *brand;
@property(copy,nonatomic) void(^block)(NSString *address);
@end

NS_ASSUME_NONNULL_END
