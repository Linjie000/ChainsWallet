//
//  SCWalletEnterView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/8.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCWalletEnterView.h"

#define marginX 25
#define HEIGHT 170

@interface SCWalletEnterView ()
{
    UITextField *_tf;
    UILabel *_titleLab;
}

@end

@implementation SCWalletEnterView

+ (instancetype)shareInstance
{
    static SCWalletEnterView *enterv = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        enterv = [[SCWalletEnterView alloc]init];
    });
    [KeyWindow addSubview:enterv];
    return enterv;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = SCREEN_HEIGHT;
        [self subViews];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLab.text = LocalizedString(title);
}

- (void)setPlaceholderStr:(NSString *)placeholderStr
{
    _placeholderStr = placeholderStr;
    _tf.placeholder = LocalizedString(placeholderStr);
    [_tf becomeFirstResponder];
}

- (void)subViews
{
    //透明图层
    UIView *opView = [UIView new];
    opView.frame = self.frame;
    opView.backgroundColor = [UIColor blackColor];
    opView.alpha = 0.5;
    [self addSubview:opView];
    [opView setTapActionWithBlock:^{
        [self endEditing:YES];
    }];
    
    UIView *bgView = [UIView new];
    bgView.width = SCREEN_WIDTH-2*marginX;
    bgView.height = HEIGHT;
    bgView.backgroundColor = SCGray(250);
    bgView.centerX = SCREEN_WIDTH/2;
    bgView.centerY = SCREEN_HEIGHT/2-30;
    bgView.layer.cornerRadius = 8;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    
    UILabel *lab = [UILabel new];
    lab.size = CGSizeMake(bgView.width, 25);
    lab.centerX = bgView.width/2;
    lab.top = 20;
    lab.font = kFont(16);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = SCTEXTCOLOR;
    [bgView addSubview:lab];
    _titleLab = lab;
    
    UITextField *tf = [UITextField new];
    tf.size = CGSizeMake(bgView.width-40, 35);
    tf.centerX = lab.centerX;
    tf.top = lab.bottom+20;
    tf.placeholder = LocalizedString(self.placeholderStr);
    [tf textRectForBounds:CGRectMake(10, 0, 0, 0)];
    tf.layer.borderColor = SCGray(220).CGColor;
    tf.layer.borderWidth = 0.6;
    tf.font = kFont(15);
    tf.tintColor = MainColor;
//    tf.secureTextEntry = YES;
    [bgView addSubview:tf];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 5)];
    tf.leftView = view;
    tf.leftViewMode = UITextFieldViewModeAlways;
    [tf becomeFirstResponder];
    _tf = tf;
    
    UILabel *lab1 = [UILabel new];
    lab1.size = CGSizeMake(bgView.width/2, 50);
    lab1.x = 0;
    lab1.bottom = bgView.height;
    lab1.text = LocalizedString(@"取消");
    lab1.font = kFont(15);
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.textColor = SCColor(101, 122, 227);
    [bgView addSubview:lab1];
    [lab1 setTapActionWithBlock:^{
        [self removeFromSuperview];
    }];
    
    UILabel *lab2 = [UILabel new];
    lab2.size = CGSizeMake(bgView.width/2, 50);
    lab2.x = bgView.width/2;
    lab2.bottom = lab1.bottom;
    lab2.text = LocalizedString(@"确认");
    lab2.font = kFont(15);
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.textColor = SCColor(101, 122, 227);
    [bgView addSubview:lab2];
    [lab2 setTapActionWithBlock:^{
        if (self.returnTextBlock) {
            self.returnTextBlock(tf.text);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
        }
    }];
    
    UIView *line1 = [RewardHelper addLine2];
    line1.x = 0;
    line1.bottom = lab1.top;
    [bgView addSubview:line1];
    
    UIView *line2 = [UIView new];
    line2.width = CGFloatFromPixel(1);
    line2.height = lab1.height;
    line2.backgroundColor = [UIColor colorWithWhite:0.823 alpha:0.84];
    line2.centerX = bgView.width/2;
    line2.centerY = lab1.centerY;
    [bgView addSubview:line2];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    self.title = @"";
    self.placeholderStr = @"";
    _tf.text = @"";
}
@end
