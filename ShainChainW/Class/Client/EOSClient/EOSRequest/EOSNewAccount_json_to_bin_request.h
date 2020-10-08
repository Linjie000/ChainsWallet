//
//  EOSNewAccount_json_to_bin_request.h
//  ShainChainW
//
//  Created by 闪链 on 2019/6/25.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSRequestManager.h"


@interface EOSNewAccount_json_to_bin_request : EOSRequestManager
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *action;
@property(nonatomic, copy) NSString *creator;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *ownerKey;
@property(nonatomic, copy) NSString *activeKey;
@end

