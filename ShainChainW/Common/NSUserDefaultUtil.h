//
//  NSUserDefaultUtil.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaultUtil : NSObject
+(void)PutBoolDefaults:(NSString *)key Value:(BOOL)value;
+(void)PutDefaults:(NSString *)key Value:(id)value;
+(id)GetDefaults:(NSString *)key;
//存储int类型数据
+(void)PutNumberDefaults:(NSString *)key Value:(NSNumber*)ID;
//取出int类型数据
+(NSNumber*)GetNumberDefaults:(NSString *)key;
@end
