//
//  NSObject+BGKVTool.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BGKVTool)
+ (NSString*)bg_sqlKey:(NSString* )key;

/**
 转换OC对象成数据库数据.
 */
+ (NSString*)bg_sqlValue:(id)value;
@end

NS_ASSUME_NONNULL_END
