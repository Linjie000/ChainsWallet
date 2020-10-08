//
//  EOSActionsModel.h
//  ShainChainW
//
//  Created by 闪链 on 2019/6/26.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSActionsModel : NSObject
@property(nonatomic, copy) NSString *sender;
@property(nonatomic, copy) NSString *data;
@property(nonatomic, copy) NSString *account;
@property(nonatomic , copy) NSString *name;
@property(nonatomic , copy) NSString *permission;

@end

NS_ASSUME_NONNULL_END
