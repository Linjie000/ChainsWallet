//
//  SCEditNameTextField.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/8.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCEditNameTextField.h"

@implementation SCEditNameTextField

- (instancetype)init
{
    if (self = [super init]) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
        self.leftView = view;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

//-(CGRect)editingRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(20, 0, SCREEN_WIDTH -60, self.height);
//}
//
//-(CGRect)placeholderRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(20, 0, SCREEN_WIDTH -60, self.height);
//}


@end
