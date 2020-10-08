//
//  DappWithoutPasswordView.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "DappWithoutPasswordView.h"
#define marginX 15

@interface DappWithoutPasswordView ()
@property(strong, nonatomic) UIView *bgview;
@end

@implementation DappWithoutPasswordView

- (instancetype)init
{
    if (self = [super init]) {
        self.width  =SCREEN_WIDTH;
        self.height = SCREEN_HEIGHT;
        [self subViews];
    }
    return self;
}

- (void)setShowBgView:(BOOL)showBgView
{
    _showBgView = showBgView;
    if (_showBgView) {
        _bgview.backgroundColor = [UIColor blackColor];
        _bgview.alpha = 0.4;
    }
}

- (void)subViews
{
    UIView *bgview = [UIView new];
    bgview.frame = self.bounds;
    _bgview = bgview;
    [self addSubview:bgview];
    
    UIView *emailView = [UIView new];
    emailView.size = CGSizeMake(SCREEN_WIDTH-75, 265);
    emailView.layer.cornerRadius = 7l;
    emailView.clipsToBounds = YES;
    emailView.centerX = SCREEN_WIDTH/2;
    emailView.centerY = SCREEN_HEIGHT/2-10;
    emailView.backgroundColor = [UIColor whiteColor];
    [self addSubview:emailView];
    
    UILabel *emailLab = [UILabel new];
    emailLab.font = kPFFont(13);
    emailLab.text = LocalizedString(@"请输入密码");
    [emailLab sizeToFit];
    emailLab.x = marginX;
    emailLab.top = 15;
    [emailView addSubview:emailLab];
    
    _passwordTF = [SCEditNameTextField new];
    _passwordTF.placeholder = LocalizedString(@"密码");
    _passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"密码") attributes:@{NSFontAttributeName:kPFFont(14)}];
    
    
    _passwordTF.size = CGSizeMake(emailView.width-2*marginX, 32);
    _passwordTF.layer.borderColor = SCGray(222).CGColor;
    _passwordTF.layer.borderWidth = 0.4;
    _passwordTF.x = marginX;
    _passwordTF.secureTextEntry = YES;
    _passwordTF.tintColor = MainColor;
    _passwordTF.font = kPFFont(14);
    _passwordTF.y = emailLab.bottom + 15;
    [emailView addSubview:_passwordTF];
 
    _savePasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _savePasswordBtn.frame = CGRectMake(0, _passwordTF.bottom+3, 180, 35);
    _savePasswordBtn.backgroundColor = [UIColor clearColor];
    //设置button正常状态下的图片
    [_savePasswordBtn setImage:[UIImage imageNamed:@"使用条款-未选中"] forState:UIControlStateNormal];
    [_savePasswordBtn setImage:[UIImage imageNamed:@"使用条款-选中"] forState:UIControlStateSelected];
    //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
    _savePasswordBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 90);
    [_savePasswordBtn setTitle:LocalizedString(@"退出该DAPP前记住密码") forState:UIControlStateNormal];
    [_savePasswordBtn setTitleColor:SCGray(128) forState:UIControlStateNormal];
    //button标题的偏移量，这个偏移量是相对于图片的
    _savePasswordBtn.titleEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
    _savePasswordBtn.titleLabel.font = kFont(12.5);  
    [emailView addSubview:_savePasswordBtn];
    [_savePasswordBtn addTarget:self action:@selector(selectResource:) forControlEvents:UIControlEventTouchUpInside];
 
    
    NSString *str = NSLocalizedString(@"1. 使用免密功能将通过本地缓存为您自动填充密码；\n 2. 退出Dapp后免密功能自动失效，下次需要重新开启；\n 3. 钱包不会保存您的密码。\n", nil);
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
    att.attributes = @{NSForegroundColorAttributeName:SCGray(128),NSFontAttributeName:kFont(12)};
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:3];
    [att addAttribute:NSParagraphStyleAttributeName
                value:paragraphStyle
                range:NSMakeRange(0, [str length])];
    
    _detailTV = [SCCustomPlaceHolderTextView new];
    _detailTV.size = CGSizeMake(_passwordTF.width, 88);
    _detailTV.x = marginX;
    _detailTV.top = _savePasswordBtn.bottom;
    _detailTV.font = kFont(14);
    _detailTV.attributedText = att;
    _detailTV.editable = NO;
    [emailView addSubview:_detailTV];
    
    UILabel *lab1 = [UILabel new];
    lab1.size = CGSizeMake(emailView.width/2, 40);
    lab1.x = 0;
    lab1.bottom = emailView.height;
    lab1.text = LocalizedString(@"取消");
    lab1.font = kFont(14);
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.textColor = SCGray(128);
    [emailView addSubview:lab1];
    [lab1 setTapActionWithBlock:^{
        if (self.delegate&&[self.delegate respondsToSelector:@selector(dappWithoutPasswordViewCancleDidClick)]) {
            [self.delegate dappWithoutPasswordViewCancleDidClick];
        }
    }];
    
    UILabel *lab2 = [UILabel new];
    lab2.size = CGSizeMake(emailView.width/2, 40);
    lab2.x = emailView.width/2;
    lab2.bottom = lab1.bottom;
    lab2.text = LocalizedString(@"确定");
    lab2.font = kFont(14);
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.textColor = SCGray(128);
    [emailView addSubview:lab2];
    [lab2 setTapActionWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate&&[self.delegate respondsToSelector:@selector(dappWithoutPasswordViewConfirmBtnDidClick)]) {
                [self.delegate dappWithoutPasswordViewConfirmBtnDidClick];
            }
        });
    }];
    
    UIView *line1 = [RewardHelper addLine2];
    line1.x = 0;
    line1.bottom = lab1.top;
    [emailView addSubview:line1];
    
    UIView *line2 = [UIView new];
    line2.width = CGFloatFromPixel(1);
    line2.height = lab1.height;
    line2.backgroundColor = [UIColor colorWithWhite:0.823 alpha:0.84];
    line2.centerX = emailView.width/2;
    line2.centerY = lab1.centerY;
    [emailView addSubview:line2];
}

- (void)selectResource:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

@end
