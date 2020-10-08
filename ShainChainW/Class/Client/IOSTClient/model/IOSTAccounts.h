//
//  IOSTAccounts.h
//  ShainChainW
//
//  Created by 闪链 on 2019/5/17.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IOSTAccount.h"

@interface IOSTAccounts : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *create_time;
@property (strong, nonatomic) NSString *creator;
@property (strong, nonatomic) IOSTAccount *account_info;

//"name":"admin",
//"create_time":1546300800000000000,
//"creator":"deadaddr",
//"account_info":Object{...}
@end

