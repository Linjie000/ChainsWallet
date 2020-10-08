//
//  Get_table_rows_request.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSRequestManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface Get_table_rows_request : EOSRequestManager

@property(nonatomic , copy) NSString *code;
@property(nonatomic , copy) NSString *scope;
@property(nonatomic , copy) NSString *table;

@end

NS_ASSUME_NONNULL_END
