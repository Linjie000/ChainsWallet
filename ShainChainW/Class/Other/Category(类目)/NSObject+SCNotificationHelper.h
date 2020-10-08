//
//  NSObject+SCNotificationHelper.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/11.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SCNotificationHelper)

/**
 * 添加通知
 * @param notificationName 通知名称
 * @param response 收到通知的响应
 */
- (void)addNotificationForName:(NSString *)notificationName response:(void (^)(NSDictionary *userInfo))response;

/**
 * 仅用于移除单个通知
 * 提示: 界面释放时, 会自动移除所有的Observer, 无需手动调用.
 * @param notificationName 被移除的通知的名字
 */
- (void)removeNotificationForName:(NSString *)notificationName;

/**
 * 发送通知
 * @param notificationName 通知名称
 * @param userInfo 通知传值
 */
- (void)postNotificationForName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
