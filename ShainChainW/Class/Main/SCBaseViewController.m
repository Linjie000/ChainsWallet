//
//  SCBaseViewController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/2.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCBaseViewController.h"

@interface SCBaseViewController ()

@end

@implementation SCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setHideNavigaionBarLine:(BOOL)hideNavigaionBarLine
{
    if(hideNavigaionBarLine)
        [self hideNavigaionBarLineAction];
}

- (void)hideNavigaionBarLineAction
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

@end
