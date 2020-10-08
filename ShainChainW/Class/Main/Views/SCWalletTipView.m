//
//  SCWalletTipView.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/15.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCWalletTipView.h"

#define marginX 25
#define HEIGHT 155

@interface SCWalletTipView ()
{
    UILabel *_titleLab;
    UILabel *_detailLab;
    UIView *_bgView;
    UIView *_opView;
}

@end

@implementation SCWalletTipView
static SCWalletTipView *enterv = nil;
+ (instancetype)shareInstance
{
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        enterv = [[SCWalletTipView alloc]init];
//    });
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat h = [RewardHelper textHeight:_detailStr width:SCREEN_WIDTH-2*marginX-60 font:kFont(15)];
    _detailLab.height = h;
//    _bgView.height = (_titleLab.bottom + 50)+h+20;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLab.text = LocalizedString(title);
}

- (void)setDetailStr:(NSString *)detailStr
{
    _detailStr = detailStr;
    _detailLab.text = detailStr;
     [self layoutIfNeeded];
}

- (void)subViews
{
    //透明图层
    UIView *opView = [UIView new];
    opView.frame = self.frame;
    opView.backgroundColor = [UIColor blackColor];
    opView.alpha = 0.0;
    [self addSubview:opView];
    [opView setTapActionWithBlock:^{
        [self endEditing:YES];
    }];
    _opView = opView;
    
    UIView *bgView = [UIView new];
    bgView.width = SCREEN_WIDTH-2*marginX;
    bgView.height = HEIGHT;
    bgView.backgroundColor = SCGray(250);
    bgView.centerX = SCREEN_WIDTH/2;
    bgView.centerY = SCREEN_HEIGHT/2+30;
    bgView.layer.cornerRadius = 8;
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    _bgView = bgView;
    
    UILabel *lab = [UILabel new];
    lab.size = CGSizeMake(bgView.width, 25);
    lab.centerX = bgView.width/2;
    lab.top = 20;
    lab.font = kFont(17);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = SCTEXTCOLOR;
    [bgView addSubview:lab];
    _titleLab = lab;
    
    _detailLab = [UILabel new];
    _detailLab.size = CGSizeMake(bgView.width-60, 0);
    _detailLab.centerX = bgView.width/2;
    _detailLab.top = lab.bottom+5;
    _detailLab.font = kFont(15);
    _detailLab.textAlignment = NSTextAlignmentCenter;
    _detailLab.textColor = SCGray(128);
    _detailLab.numberOfLines = 0;
    [bgView addSubview:_detailLab];
    
    UILabel *lab1 = [UILabel new];
    lab1.size = CGSizeMake(bgView.width/2, 50);
    lab1.x = 0;
    lab1.bottom = bgView.height;
    lab1.text = LocalizedString(@"取消");
    lab1.font = kFont(16);
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
    lab2.font = kFont(16);
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.textColor = SCColor(101, 122, 227);
    [bgView addSubview:lab2];
    [lab2 setTapActionWithBlock:^{
        if (self.returnBlock) {
            self.returnBlock();
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

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
 
    [UIView animateWithDuration:0.2 animations:^{
        self->_opView.alpha = 0.4;
    }];
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->_bgView.centerY = SCREEN_HEIGHT/2-30;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    self.title = @"";
    self.detailStr = @"";
    enterv = nil;
}
@end
