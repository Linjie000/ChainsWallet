//
//  ExcuteActionsResult.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExcuteActionsResult : NSObject
@property(nonatomic , copy) NSString *type;
@property(nonatomic , strong) NSMutableArray *actions;

@property(nonatomic , copy) NSString *dappName;
@property(nonatomic , copy) NSString *dappIcon;
@property(nonatomic , copy) NSString *serialNumber;
@property(nonatomic , copy) NSString *expired;
@property(nonatomic , copy) NSString *desc;
@property(nonatomic , copy) NSString *callback;
@property(nonatomic , copy) NSString *protocol;

@end

NS_ASSUME_NONNULL_END
