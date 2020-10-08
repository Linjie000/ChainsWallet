//
//  IOSTBalance.h
//  ShainChainW
//
//  Created by 闪链 on 2019/5/19.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOSTAccount.h"

@interface IOSTBalance : NSObject
@property (strong, nonatomic) NSString *balance;
@property (strong, nonatomic) NSArray *frozen_balances;
@end
 
