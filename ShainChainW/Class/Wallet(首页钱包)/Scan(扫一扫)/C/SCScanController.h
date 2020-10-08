//
//  SCScanController.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/3.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^addressBlock)(NSString *address,NSString *brand);

NS_ASSUME_NONNULL_BEGIN

@interface SCScanController : UIViewController
@property(copy, nonatomic) addressBlock block;
@property(assign, nonatomic) ADDRESS_TYPE_STRING addressType;;
@end

NS_ASSUME_NONNULL_END
