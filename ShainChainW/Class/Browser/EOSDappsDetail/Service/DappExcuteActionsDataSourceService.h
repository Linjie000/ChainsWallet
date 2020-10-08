//
//  DappExcuteActionsDataSourceService.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSRequestManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface DappExcuteActionsDataSourceService : EOSRequestManager
@property(nonatomic , copy) NSString *actionsResultDict;
@end

NS_ASSUME_NONNULL_END
