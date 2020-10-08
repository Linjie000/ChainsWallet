//
//  Get_token_info_service.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/3.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface Get_token_info_service : EOSRequestManager
@property(nonatomic, strong) NSString *accountName;

@property(nonatomic , strong) NSMutableArray *ids;

- (void)get_token_info:(CompleteBlock)complete;
@end

NS_ASSUME_NONNULL_END
