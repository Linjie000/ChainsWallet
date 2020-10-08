//
//  SCAlertCreater.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/10.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCAlertCreater.h"

@implementation SCAlertCreater

#pragma mark - 普通的弹窗
+ (void)showAlertSingleWithController:(UIViewController *)controller title:(NSString *)title message:(NSString *)message successBtn:(NSString *)successBtn failBtn:(NSString *)failBtn{
    
    UIAlertController * my_alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (successBtn) {
        [my_alert addAction:[UIAlertAction actionWithTitle:successBtn style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
    }
    if (failBtn) {
        [my_alert addAction:[UIAlertAction actionWithTitle:failBtn style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
    }
    
    if (!successBtn && !failBtn) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //子线程内部(耗时代码写在这里)
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                //主线程内容
                [my_alert dismissViewControllerAnimated:YES completion:nil];
            });
        });
    }
    
    
    [controller presentViewController:my_alert animated:YES completion:nil];
    
}

#pragma mark - 带确定的弹窗
+ (void)showAlertWithController:(UIViewController *)controller title:(NSString *)title message:(NSString *)message successBtn:(NSString *)successBtn failBtn:(NSString *)failBtn successHandler:(void (^ __nullable)(UIAlertAction *action))successHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:successBtn style:UIAlertActionStyleDefault handler:successHandler];
    [alert addAction:action];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:failBtn style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alert addAction:action1];
    [controller presentViewController:alert animated:YES completion:nil];
    return;
}


+ (void)addCancelActionTarget:(UIAlertController*)alertController title:(NSString *)title
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [action setValue:[UIColor colorFromHexString:@"#676767"] forKey:@"_titleTextColor"];
    [alertController addAction:action];
}
+ (void)addCancelActionTarget1:(UIAlertController*)alertController msgColor:(UIColor *)color title:(NSString *)title
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [action setValue:color forKey:@"_titleTextColor"];
    [alertController addAction:action];
}


+ (void)addActionTarget:(UIAlertController *)alertController titles:(NSArray *)titles color:(UIColor *)color action:(void(^)(UIAlertAction *action))actionTarget
{
    for (NSString *title in titles) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            actionTarget(action);
        }];
        [action setValue:color forKey:@"_titleTextColor"];
        [alertController addAction:action];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:LocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        actionTarget(action);
    }];
    [action setValue:color forKey:@"_titleTextColor"];
    [alertController addAction:action];
}

//修改消息的颜色,2种样式
+ (void)setMessage1:(NSString *)msg1 color1:(UIColor *)color1 font1:(CGFloat)font1 message2:(NSString *)msg2 color2:(UIColor *)color2 font2:(CGFloat)font2 alertView:(UIAlertController *)alert row:(CGFloat)row{
    
    
    NSString *str3 = [NSString stringWithFormat:@"%@%@",msg1,msg2];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:str3];
    
    if (row > 0) {
        //设置了之后出现问题,文字不能左右居中显示
        //        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //        [paragraphStyle setLineSpacing:row];
        //        [alertControllerMessageStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str3 length])];
    }
    
    
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#555555"] range:NSMakeRange(0, msg1.length)];
    
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font1] range:NSMakeRange(0, msg1.length)];
    
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#555555"] range:NSMakeRange(msg1.length, msg2.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font2] range:NSMakeRange(msg1.length, msg2.length)];
    [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
}

@end
