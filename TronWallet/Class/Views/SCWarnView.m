//
//  SCWarnView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/2.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCWarnView.h"

@interface SCWarnView ()
{
    UIView *_opView;
    UIView *_bgView;
    UILabel *_noScreenshot;
    UILabel *_textLab;
    UILabel *_commitBtn;
    NSString *_text;
}


@end

@implementation SCWarnView
 
- (instancetype)initWithText:(NSString *)text
{
    if (self = [super init]) {
        _text = text;
        self.width = SCREEN_WIDTH;
        self.height = SCREEN_HEIGHT;
        [self subViews];
    }
    return self;
}

- (void)subViews{
    
    //透明图层
    UIView *opView = [UIView new];
    opView.frame = self.frame;
    opView.backgroundColor = [UIColor blackColor];
    opView.alpha = 0.5;
    _opView = opView;
    [self addSubview:opView];
    
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 4;
    bgView.clipsToBounds = YES;
    bgView.width = SCREEN_WIDTH - 70;
    _bgView = bgView;
    [self addSubview:bgView];
    
    //请勿截图
    UIImageView *createImg = [UIImageView new];
    createImg.size = CGSizeMake(28, 27);
    createImg.image = IMAGENAME(@"请勿截图");
    createImg.centerX = _bgView.width/2;
    createImg.top = 25;
    [_bgView addSubview:createImg];
    
    UILabel *lab = [UILabel new];
    lab.size = CGSizeMake(_bgView.width, 25);
    lab.centerX = createImg.centerX;
    lab.top = createImg.bottom+3;
    lab.text = LocalizedString(@"请勿截图");
    lab.font = kFont(15);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = SCTEXTCOLOR;
    _noScreenshot = lab;
    [_bgView addSubview:lab];
    
    UILabel *textlab = [UILabel new];
    textlab.text = _text;
    textlab.font = kFont(14);
    textlab.textColor = SCGray(140);
    textlab.numberOfLines = 0;
    _textLab = textlab;
    [_bgView addSubview:textlab];
    
    UILabel *commitBtn = [UILabel new];
    commitBtn.text = LocalizedString(@"知道了");
    commitBtn.backgroundColor = SCOrangeColor;
    commitBtn.textAlignment = NSTextAlignmentCenter;
    commitBtn.textColor = [UIColor whiteColor];
    commitBtn.width = _bgView.width;
    commitBtn.height = SCREEN_ADJUST_HEIGHT(44);
    commitBtn.x = 0;
    commitBtn.font = kFont(14);
    _commitBtn = commitBtn;
    [commitBtn setTapActionWithBlock:^{
        [self hideSelf];
    }];
    [_bgView addSubview:commitBtn];
    
    CGFloat w = _bgView.width-SCREEN_ADJUST_WIDTH(37);
    CGFloat h = [RewardHelper textHeight:_text width:w font:kFont(16)];
    _textLab.size = CGSizeMake(w, h);
    _textLab.centerX = _bgView.width/2;
    _textLab.top = _noScreenshot.bottom+10;
    
    _commitBtn.top = _textLab.bottom+20;
    
    _bgView.height = _commitBtn.bottom;
    _bgView.centerX = self.width/2;
    _bgView.centerY = self.height/2;
}

- (void)hideSelf{
    CGAffineTransform t = _bgView.transform;
    [UIView animateWithDuration:0.1 animations:^{
        self->_bgView.transform = CGAffineTransformScale(t, 0.95, 0.95);
        self->_opView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
 
}


@end
