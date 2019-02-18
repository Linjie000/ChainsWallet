//
//  TWAccountManager.h
//  TronWallet
//
//  Created by chunhui on 2018/5/23.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWAccountManager : NSObject

DEF_SINGLETON;

-(void)saveAccount:(TronAccount *)account;

-(TronAccount *)account;

@end
