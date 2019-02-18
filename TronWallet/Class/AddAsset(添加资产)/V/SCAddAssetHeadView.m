//
//  SCAddAssetHeadView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/14.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCAddAssetHeadView.h"

@interface SCAddAssetHeadView ()
@property(strong, nonatomic) UITextField *textField;
@property(strong, nonatomic) UIButton *opBtn;
@end

@implementation SCAddAssetHeadView

- (instancetype)init
{
    if (self = [super init]) {
        self.height = NAVIBAR_HEIGHT;
        self.width = SCREEN_WIDTH;
        self.x = self.y = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    UIView *line = [RewardHelper addLine2];
    line.bottom = self.height;
    [self addSubview:line];
    //返回
    UIView *backv = [UIView new];
    backv.width = 50;
    backv.height = 40;
    backv.centerY = (NAVIBAR_HEIGHT-Height_StatusBar)/2+Height_StatusBar;
    UIImageView *backimg = [UIImageView new];
    backimg.image = IMAGENAME(@"navi_back");
    backimg.size = CGSizeMake(10, 18);
    backimg.centerY = backv.height/2;
    backimg.centerX = backv.width/2;
    [backv addSubview:backimg];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
    [backv addGestureRecognizer:gesture];
    [self addSubview:backv];
    
    [self addSubview:self.textField];
    [self addSubview:self.opBtn];
    
    self.textField.centerY = backv.centerY;
    self.textField.x = backv.right;
    self.textField.width = self.width-backv.width-self.opBtn.width;
    
    self.opBtn.right = SCREEN_WIDTH;
    self.opBtn.centerY = backv.centerY;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.height = 29;
        _textField.placeholder = LocalizedString(@"输入 Token 名称或合约地址");
        _textField.backgroundColor = SCGray(242);
        _textField.layer.cornerRadius = 5.0;
        _textField.clipsToBounds = YES;
        [_textField setValue:SCGray(128) forKeyPath:@"_placeholderLabel.textColor"];
        [_textField setValue:kPFFont(15) forKeyPath:@"_placeholderLabel.font"];
        
        UIView *bgView = [UIView new];
        bgView.size = CGSizeMake(30, 20);
        UIImageView *img = [UIImageView new];
        img.image = IMAGENAME(@"搜索");
        img.size = CGSizeMake(14, 14);
        img.centerX = bgView.width/2;
        img.centerY = bgView.height/2;
        [bgView addSubview:img];
        _textField.leftView = bgView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (UIButton *)opBtn
{
    if (!_opBtn) {
        _opBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _opBtn.size = CGSizeMake(60, 40);
        [_opBtn setTitleColor:SCGray(200) forState:UIControlStateHighlighted];
        [_opBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_opBtn setTitle:LocalizedString(@"管理") forState:UIControlStateNormal];
        _opBtn.titleLabel.font = kFont(15);
        [_opBtn addTarget:self action:@selector(operation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _opBtn;
}

- (void)backAction:(UITapGestureRecognizer *)tap
{
    [[RewardHelper viewControllerWithView:self].navigationController popViewControllerAnimated:YES];
}

- (void)operation
{
    
}

@end
