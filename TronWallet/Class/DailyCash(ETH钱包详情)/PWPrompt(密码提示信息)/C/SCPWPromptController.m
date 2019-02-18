//
//  SCPWPromptController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/8.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCPWPromptController.h"
#import "SCEditNameTextField.h"
#import "UIView+Tap.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#define marinX 14

@interface SCPWPromptController ()<UITextFieldDelegate>
{
    SCEditNameTextField *textfield;
    UILabel *text;
    
    NSString *lastTextContent;
}
@property(strong, nonatomic) UIView *eyesView;
@property(strong, nonatomic) UIImageView *eyesImg;
@end

@implementation SCPWPromptController

-(instancetype)init
{
    if (self = [super init]) {
        //注册通知，textfield内容改变调用
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textfield];
        [self initView];
        [IQKeyboardManager sharedManager].enable = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SCGray(244);
    self.title = LocalizedString(@"密码提示信息");
}

-(void)initView
{
    textfield = [SCEditNameTextField new];
    [textfield becomeFirstResponder];
    textfield.width = SCREEN_WIDTH;
    textfield.height = 48;
    textfield.x = 0;
    textfield.y = 20;
    textfield.backgroundColor = [UIColor whiteColor];
    textfield.tintColor = SCGray(180);
    textfield.secureTextEntry = YES;
    textfield.placeholder = LocalizedString(@"密码提示信息");
    textfield.font = [UIFont systemFontOfSize:15.5];
    textfield.delegate = self;
    [self.view addSubview:textfield];
    
    [self.view addSubview:self.eyesView];
    self.eyesImg.image = IMAGENAME(@"密码-不显示");
    self.eyesView.right = textfield.right;
    self.eyesView.centerY = textfield.centerY;
    __block SCEditNameTextField *tf = textfield;
    __block BOOL show = NO;
    WeakSelf(weakSelf);
    [self.eyesView setTapActionWithBlock:^{
        show = !show;
        if (show) {
            weakSelf.eyesImg.image = IMAGENAME(@"密码-显示");
            tf.secureTextEntry = NO;
        }else{
            weakSelf.eyesImg.image = IMAGENAME(@"密码-不显示");
            tf.secureTextEntry = YES;
        }
    }];
    
    text = [UILabel new];
    text.font = [UIFont systemFontOfSize:12];
    text.size = CGSizeMake(SCREEN_WIDTH - marinX*2, 20);
    text.x = marinX;
    text.top = textfield.bottom;
    text.text = @"";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [IQKeyboardManager sharedManager].enable = YES;
}


#pragma mark --  UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    lastTextContent = textField.text;
    return YES;
}

- (void)textFieldDidChange:(NSNotification *)note{
    UITextField *textF = note.object;
    //获取文本框内容的字节数
    int bytes = [self stringConvertToInt:textfield.text];
    
    //    UBLog(@"bytes ::  %d",bytes);
    //设置不能超过32个字节，因为不能有半个汉字，所以以字符串长度为单位。
    if (bytes > 20)
    {
        //超出字节数，还是原来的内容
        textF.text = lastTextContent;
    }
    else
    {
        lastTextContent = textF.text;
    }
}
//得到字节数函数
-  (int)stringConvertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (UIView *)eyesView
{
    if (!_eyesView) {
        _eyesView = [UIView new];
        _eyesView.size = CGSizeMake(40, 40);
        [_eyesView addSubview:self.eyesImg];
    }
    return _eyesView;
}

- (UIImageView *)eyesImg
{
    if (!_eyesImg) {
        _eyesImg = [UIImageView new];
        _eyesImg.size = CGSizeMake(20, 10);
        _eyesImg.centerX = 20;
        _eyesImg.centerY = 20;
    }
    return _eyesImg;
}


@end
