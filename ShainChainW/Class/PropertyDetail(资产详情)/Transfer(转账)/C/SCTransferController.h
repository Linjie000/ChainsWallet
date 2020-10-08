//
//  SCTransferController.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EOSTokenInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface SCTransferController : UIViewController
@property(strong, nonatomic) NSString *brand;
@property(strong ,nonatomic) NSString *toAddress;

//@property(nonatomic , strong) EOSTokenInfo *currentToken;
@property(nonatomic , strong) coinModel *coin;
@end

NS_ASSUME_NONNULL_END
