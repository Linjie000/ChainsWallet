//
//  TKCommonTools+Toast.m
//  ToolKit
//
//  Created by iwm on 2017/9/24.
//  Copyright © 2017年 chunhui. All rights reserved.
//

#import "TKCommonTools.h"
#import "MBProgressHUD.h"

@implementation TKCommonTools (Toast)

+ (UIWindow *)keyWindow {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!window) {
        window = [[[UIApplication sharedApplication] windows] firstObject];
    }
    return window;
}

+ (void)showToast:(NSString *)toast {
    [self showToast:toast time:1];
}

+ (void)showLongToast:(NSString *)toast {
    [self showToast:toast time:2];
}

+ (void)showToast:(NSString *)toast time:(float)time {
    if (!toast.length) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self keyWindow] animated:YES];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.8];
        
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.label.text = toast;
        hud.label.textColor = [UIColor whiteColor];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hideAnimated:YES afterDelay:time];
        
    });
}

+ (void)showLoadingOnView:(UIView *)view {
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color =[UIColor colorWithWhite:0.2 alpha:0.8];
}

+ (void)hideLoadingOnView:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
