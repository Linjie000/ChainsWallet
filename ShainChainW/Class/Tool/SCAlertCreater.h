//
//  SCAlertCreater.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/10.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCAlertCreater : NSObject

/**
 普通的弹窗
 
 @param controller 控制器
 @param title 标题
 @param message 消息
 @param successBtn 确认按钮
 @param failBtn 取消按钮
 */
+(void)showAlertSingleWithController:(UIViewController *)controller title:(NSString *)title message:(NSString *)message successBtn:(NSString *)successBtn failBtn:(NSString *)failBtn;

#pragma mark - 带确定的弹窗
+(void)showAlertWithController:(UIViewController *)controller title:(NSString *)title message:(NSString *)message successBtn:(NSString *)successBtn failBtn:(NSString *)failBtn successHandler:(void (^ __nullable)(UIAlertAction *action))successHandler;

+(void)addCancelActionTarget:(UIAlertController*)alertController title:(NSString *)title;
+(void)addCancelActionTarget1:(UIAlertController*)alertController msgColor:(UIColor *)color title:(NSString *)title;

+ (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles color:(UIColor *)color action:(void(^)(UIAlertAction *action))actionTarget;


//修改消息的颜色,2种样式
+(void)setMessage1:(NSString *)msg1 color1:(UIColor *)color1 font1:(CGFloat)font1 message2:(NSString *)msg2 color2:(UIColor *)color2 font2:(CGFloat)font2 alertView:(UIAlertController *)alert row:(CGFloat)row;

@end

NS_ASSUME_NONNULL_END
