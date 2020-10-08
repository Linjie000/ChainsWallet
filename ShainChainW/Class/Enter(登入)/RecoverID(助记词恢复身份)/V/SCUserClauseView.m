
//
//  SCUserClauseView.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/18.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCUserClauseView.h"
#define marginX 16

@interface SCUserClauseView ()
{
    UIImageView *_checkImg;
    UIButton *_sureBtn;;
    UIView *_whiteView;
}
@property(strong, nonatomic) UIView *sureClauseView;
@end

@implementation SCUserClauseView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = SCREEN_HEIGHT;
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    UIView *bgView = [UIView new];
    bgView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [self addSubview:bgView];
    
    UIView *whiteView = [UIView new];
    whiteView.size = CGSizeMake(275, 754/2);
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 11;
    whiteView.clipsToBounds = YES;
    whiteView.centerX = SCREEN_WIDTH/2;
    whiteView.top = SCREEN_HEIGHT;
    _whiteView = whiteView;
    [self addSubview:whiteView];
    
    UILabel *titlelab = [UILabel new];
    titlelab.text = LocalizedString(@"使用条款");
    [titlelab sizeToFit];
    titlelab.centerX = whiteView.width/2;
    titlelab.y = 20;
    titlelab.font = kFont(15);
    [whiteView addSubview:titlelab];
    
//    UIWebView *webv = [UIWebView new];
//    webv.size = CGSizeMake(whiteView.width-2*marginX, 255);
//    webv.x = marginX;
//    webv.top = titlelab.bottom+27;
    
    NSString *str = @"如果有人获取你的助记词将直接获取你的资产！请抄写下助记词并存放在安全的地方。如果有人获取你的助记如果有人获取你的助记词将直接获取你的资产！请抄写下助记词并存放在安全的地方。如果有人获取你的助记如果有人获取你的助记词将直接获取你的资产！请抄写下助记词并存放在安全的地方。如果有人获取你的助记如果有人获取你的助记词将直接获取你的资产！请抄写下助记词并存放在安全的地方。如果有人获取你的助记全的地方。如果有人获取你的助记如果有人获取你的助记词将直接获取你的资产！请抄写下助记词并存放在安全的地方。如果有人获取你的助记全的地方。如果有人获取你的助记如果有人获取你的助记词将直接获取你的资产！请抄写下助记词并存放在安全的地方。如果有人获取你的助记全的地方。如果有人获取你的助记如果有人获取你的助记词将直接获取你的资产！请抄写下助记词并存放在安全的地方。如果有人获取你的助记全的地方。如果有人获取你的助记如果有人获取你的助记词将直接获取你的资产！请抄写下助记词并存放在安全的地方。如果有人获取你的助记";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:str];
    att.attributes = @{NSForegroundColorAttributeName:SCGray(128)};
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:6];
    [att addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [str length])];
    
    UITextView *textView = [UITextView new];
    textView.size = CGSizeMake(whiteView.width-2*marginX, 200);
    textView.x = marginX;
    textView.top = titlelab.bottom+15;
    textView.font = kFont(13);
    textView.editable = NO;
    textView.attributedText = att;
    [whiteView addSubview:textView];
    
    [whiteView addSubview:self.sureClauseView];
    _sureClauseView.top = textView.bottom+10;
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setBackgroundImage:[UIImage imageWithColor:SCGray(183)] forState:UIControlStateNormal];
    sureBtn.enabled = NO;
    sureBtn.titleLabel.font = kFont(13);
    sureBtn.size = CGSizeMake(whiteView.width, 40);
    sureBtn.top = self.sureClauseView.bottom+12;
    sureBtn.x = 0;
    [sureBtn setTitle:LocalizedString(@"继续") forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn = sureBtn;
    [whiteView addSubview:sureBtn];
}

- (void)sureAction
{
    [UIView animateWithDuration:0.2 animations:^{
        self->_whiteView.top = SCREEN_HEIGHT-100;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIView *)sureClauseView
{
    if (!_sureClauseView) {
        _sureClauseView = [UIView new];
        _sureClauseView.height = 60;
        _sureClauseView.width = 275;
        
        _checkImg = [UIImageView new];
        _checkImg.image = IMAGENAME(@"7.3地址本-未选中");
        _checkImg.size = CGSizeMake(16, 16);
        _checkImg.x = marginX+3;
        _checkImg.centerY = _sureClauseView.height/2;
        [_sureClauseView addSubview:_checkImg];
        UIView *tapv = [UIView new];
        tapv.size = CGSizeMake(30, 30);
        tapv.center = _checkImg.center;
        [_sureClauseView addSubview:tapv];
        WeakSelf(weakSelf);
        [tapv setTapActionWithBlock:^{
            [weakSelf isReadingClause];
        }];
        
        UILabel *lab = [UILabel new];
        lab.size = CGSizeMake(_sureClauseView.width-tapv.right, 22);
        lab.text = LocalizedString(@"我已仔细阅读并同意以上条款以及");
        lab.font = kFont(13);
        lab.bottom = _sureClauseView.height/2;
        lab.x = tapv.right+3;
        [_sureClauseView addSubview:lab];
        
        UILabel *lab2 = [UILabel new];
        lab2.size = CGSizeMake(_sureClauseView.width-tapv.right, 22);
        lab2.text = LocalizedString(@"cookies 的使用说明");
        lab2.font = kFont(13);
        lab2.textColor = SCPurpleColor;
        lab2.top = _sureClauseView.height/2;
        lab2.x = lab.x;
        [_sureClauseView addSubview:lab2];
    }
    return _sureClauseView;
}

#pragma mark - 是否阅读
static BOOL isRead = NO;
- (void)isReadingClause
{
    isRead = !isRead;
    if (!isRead) {
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:SCGray(183)] forState:UIControlStateNormal];
        _sureBtn.enabled = NO;
        _checkImg.image = IMAGENAME(@"7.3地址本-未选中");
    }else
    {
        [_sureBtn setBackgroundImage:[UIImage imageWithColor:SCColor(252, 174, 50)] forState:UIControlStateNormal];
        _sureBtn.enabled = YES;
        _checkImg.image = IMAGENAME(@"10.4_Modified-successfully_icon");
    }
}

- (void)dealloc
{
    isRead = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];

    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->_whiteView.centerY = SCREEN_HEIGHT/2;
    } completion:^(BOOL finished) {
        
    }];
}

@end
