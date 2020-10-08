//
//  AccountAuthorizationView.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "AccountAuthorizationView.h"
#import "TextAuthorizationView.h"
#import "SCCommonBtn.h"

@interface AccountAuthorizationView ()<UITextFieldDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIView *opView;
@property (strong, nonatomic) UIView *passWorkView;
@end

@implementation AccountAuthorizationView

- (instancetype)init
{
    if (self = [super init]) {
        self.height = SCREEN_HEIGHT;
        self.width = SCREEN_WIDTH;
    }
    return self;
}

- (void)setModel:(SignatureForMessageModel *)model
{
    _model = model;
    [self subViews];
}

- (void)subViews
{
    UIView *bgView = [UIView new];
    bgView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    bgView.x = bgView.y = 0;
    [self addSubview:bgView];
    [bgView setTapActionWithBlock:^{
        [self removeFromSuperview];
    }];
 
    [self addSubview:self.opView];
 
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.size = CGSizeMake(150, 35);
        _titleLab.text = LocalizedString(@"EOS操作签名");
        _titleLab.font = kBoldFont(16.5);
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIView *)passWorkView
{
    if (!_passWorkView) {
        
        _passWorkView = [UIView new];
        _passWorkView.size = CGSizeMake(SCREEN_WIDTH, 360);
        _passWorkView.bottom = _opView.height;
        _passWorkView.backgroundColor = [UIColor whiteColor];
        
        _passwordtf = [SCUnderLineTextField new];
        _passwordtf.height = 40;
        _passwordtf.width = SCREEN_WIDTH - 30;
        _passwordtf.x = 15;
        _passwordtf.y = 15;
        _passwordtf.placeholder = LocalizedString(@"请输入钱包密码");
        _passwordtf.textColor = SCTEXTCOLOR;
        _passwordtf.font = kFont(14);
        _passwordtf.returnKeyType = UIReturnKeyDone;
        _passwordtf.secureTextEntry = YES;
        [_passWorkView addSubview:_passwordtf];
        _passwordtf.delegate = self;
        [_passwordtf becomeFirstResponder];
 
        SCCommonBtn *commentBtn = [SCCommonBtn createCommonBtnText:LocalizedString(@"确定")];
        commentBtn.bottom = _passWorkView.height;
        commentBtn.x = 0;
        [commentBtn setTapActionWithBlock:^{
            [self confirmAction];
        }];
        [_passWorkView addSubview:commentBtn];
    }
    return _passWorkView;
}

- (UIView *)opView
{
    if (!_opView) {
        NSArray *leftarr = @[@"whatfor",@"message"];
        NSArray *rightarr = @[_model.whatfor,_model.data];
        _opView = [UIView new];
        _opView.size = CGSizeMake(SCREEN_WIDTH, 400);
        _opView.bottom = self.height;
        _opView.backgroundColor = [UIColor whiteColor];
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.frame = CGRectMake(0, 0, 25, 25);
        back.x = 15;
        back.y = 10;
        [back setImage:IMAGENAME(@"account_chacha") forState:UIControlStateNormal];
        back.hitScale = 10;
        [_opView addSubview:back];
        [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_opView addSubview:self.titleLab];
        self.titleLab.centerX = SCREEN_WIDTH/2;
        self.titleLab.centerY = back.centerY;
        
        UILabel *tit = [UILabel new];
        tit.size = CGSizeMake(100, 50);
        tit.centerX = SCREEN_WIDTH/2;
        tit.y = self.titleLab.bottom+30;
        tit.textAlignment = NSTextAlignmentCenter;
        tit.font = kFont(25);
        tit.text = @"sign";
        [_opView addSubview:tit];
        
        for (int i=0; i<leftarr.count; i++) {
            TextAuthorizationView *tv = [TextAuthorizationView new];
            tv.leftStr = leftarr[i];
            tv.rightStr = rightarr[i];
            [_opView addSubview:tv];
            SCLog(@"---- %f",tv.authorheight);
            tv.y = 40*i+tit.bottom;
        }
        //下一步 密码
        SCCommonBtn *commentBtn = [SCCommonBtn createCommonBtnText:LocalizedString(@"下一步")];
        commentBtn.bottom = _opView.height;
        commentBtn.x = 0;
        [commentBtn setTapActionWithBlock:^{
            [self nextAction];
        }];
        [_opView addSubview:commentBtn];
    }
    return _opView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self confirmAction];
    return YES;
}

- (void)backAction
{
    [self removeFromSuperview];
}

- (void)nextAction
{
    [_opView addSubview:self.passWorkView];
}

- (void)confirmAction
{
    if (IsStrEmpty(self.passwordtf.text)) {
        [TKCommonTools showToast:LocalizedString(@"请输入密码")];
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(accountAuthorizationViewConfirmBtnDidClick:)]) {
        [self.delegate accountAuthorizationViewConfirmBtnDidClick:self];
    }
    [self removeFromSuperview];
}

@end
