//
//  GetEOSAccountRequest.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRequestManager.h"

@interface GetEOSAccountRequest : EOSRequestManager
@property(nonatomic, strong) NSString *account_name;//账户名
@end
 
