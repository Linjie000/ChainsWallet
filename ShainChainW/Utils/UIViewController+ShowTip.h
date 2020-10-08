//
//  UIViewController+ShowTip.h
//  TronWallet
//
//  Created by chunhui on 2018/5/29.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ShowTip)

-(void)showAlert:(NSString *)title mssage:(NSString *)msg confrim:(NSString *)confirm cancel:(NSString *)cancel ;

-(void)showAlert:(NSString *)title mssage:(NSString *)msg confrim:(NSString *)confirm cancel:(NSString *)cancel confirmAction:(void(^)(void))confirmAction;

-(void)showPasswordAlert:(NSString *)title mssage:(NSString *)msg confrim:(NSString *)confirm cancel:(NSString *)cancel confirmAction:(void(^)(void))confirmAction;

-(MBProgressHUD *)showHud;

-(MBProgressHUD *)showHudTitle:(NSString *)title;

@end
