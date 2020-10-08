//
//  PropertyDetailNaviView.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/10.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "PropertyDetailNaviView.h"

#define LEFTBTNW 20

@interface PropertyDetailNaviView()
{
 
}
@end

@implementation PropertyDetailNaviView

-(instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = NAVIBAR_HEIGHT; 
        self.x = self.y = 0;
        [self setUpView];
       
    }
    return self;
}

-(void)setUpView
{
    WeakSelf(weakSelf);
    _leftBtnImg = [UIImageView new];
    _leftBtnImg.image = [UIImage imageNamed:@"white_navi_backimg"];
    _leftBtnImg.size = CGSizeMake(16, 16);
    _leftBtnImg.left = SCREEN_ADJUST_WIDTH(17);
    _leftBtnImg.bottom = self.height - 12;
    [self addSubview:_leftBtnImg];
    
    UIView *tapv = [UIView new];
    tapv.size = CGSizeMake(80, 60);
    tapv.centerY = _leftBtnImg.centerY;
    tapv.x = 10;
    [self addSubview:tapv];
    [tapv setTapActionWithBlock:^{
        [[RewardHelper viewControllerWithView:self].navigationController popViewControllerAnimated:YES];
        if ([self.deleagte respondsToSelector:@selector(SCCustomHeadViewBackBtnAction)]) {
            [self.deleagte SCCustomHeadViewBackBtnAction];
        }
    }];
    
    UILabel *titlel = [UILabel new];
    titlel.size = CGSizeMake(100, 44);
    titlel.left = SCREEN_WIDTH/2+5;
    titlel.bottom = self.height;
    titlel.font = kFont(17);
    titlel.textColor = [UIColor whiteColor];
    _titleLab = titlel;
    [self addSubview:titlel];
    
    _coinImg = [UIImageView new];
    _coinImg.size = CGSizeMake(34, 34);
    _coinImg.right = SCREEN_WIDTH/2-5;
    _coinImg.centerY = titlel.centerY;
//    _coinImg.layer.cornerRadius = _coinImg.width/2;
//    _coinImg.clipsToBounds = YES;
    [self addSubview:_coinImg];
    
    UILabel *righttitlel = [UILabel new];
    righttitlel.size = CGSizeMake(60, 44);
    righttitlel.right = SCREEN_WIDTH;
    righttitlel.bottom = self.height;
    righttitlel.font = kFont(15);
    righttitlel.textAlignment = NSTextAlignmentCenter;
    _rightTitleLab = righttitlel;
    [_rightTitleLab setTapActionWithBlock:^{
        if ([weakSelf.deleagte respondsToSelector:@selector(SCCustomHeadViewRightBtnAction)]) {
            [weakSelf.deleagte SCCustomHeadViewRightBtnAction];
        }
    }];
    [self addSubview:righttitlel];
}

@end
