//
//  SCSubscribeEmailView.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/23.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCSubscribeEmailView.h"
#define marginX 15

@interface SCSubscribeEmailView ()
@property(strong, nonatomic) UIView *bgview;
@end

@implementation SCSubscribeEmailView

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
    emailLab.font = kPFFont(18);
    emailLab.text = LocalizedString(@"订阅邮件");
    [emailLab sizeToFit];
    emailLab.x = marginX;
    emailLab.top = 24;
    [emailView addSubview:emailLab];
    
    _emailTF = [SCEditNameTextField new];
    _emailTF.placeholder = LocalizedString(@"邮箱");
    _emailTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"邮箱") attributes:@{NSFontAttributeName:kPFFont(14)}]; 
    _emailTF.size = CGSizeMake(emailView.width-2*marginX, 32);
    _emailTF.layer.borderColor = SCGray(222).CGColor;
    _emailTF.layer.borderWidth = 0.4;
    _emailTF.x = marginX;
    _emailTF.font = kPFFont(14);
    _emailTF.y = emailLab.bottom + 23;
    [emailView addSubview:_emailTF];
    
    NSString *str = @"同意订阅即代表同意闪链钱包pet itd、及关联方式发送包括有关安全风险提示、产品使用帮助、产品最新信息、活动推广信息等内容及关联方式发送包括有关安全风险提示、产品使用帮助、产品最新信息、活动推广信息等内容";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
    att.attributes = @{NSForegroundColorAttributeName:SCGray(128),NSFontAttributeName:kPFFont(14)};
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:3];
    [att addAttribute:NSParagraphStyleAttributeName
                value:paragraphStyle
                range:NSMakeRange(0, [str length])];
    
    _detailTV = [SCCustomPlaceHolderTextView new];
    _detailTV.size = CGSizeMake(_emailTF.width, 95);
    _detailTV.x = marginX;
    _detailTV.top = _emailTF.bottom+10;
    _detailTV.font = kFont(14);
    _detailTV.attributedText = att;
    _detailTV.editable = NO;
    [emailView addSubview:_detailTV];
    
    UILabel *lab1 = [UILabel new];
    lab1.size = CGSizeMake(emailView.width/2, 40);
    lab1.x = 0;
    lab1.bottom = emailView.height;
    lab1.text = LocalizedString(@"以后再说");
    lab1.font = kFont(14);
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.textColor = SCGray(128);
    [emailView addSubview:lab1];
    [lab1 setTapActionWithBlock:^{
        if (self.block) {
            self.block(nil);
        }
        [self removeFromSuperview];
    }];
    
    UILabel *lab2 = [UILabel new];
    lab2.size = CGSizeMake(emailView.width/2, 40);
    lab2.x = emailView.width/2;
    lab2.bottom = lab1.bottom;
    lab2.text = LocalizedString(@"同意订阅");
    lab2.font = kFont(14);
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.textColor = SCGray(128);
    [emailView addSubview:lab2];
    [lab2 setTapActionWithBlock:^{
        if (self.block) {
            self.block(self->_emailTF.text);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
        }
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

@end
