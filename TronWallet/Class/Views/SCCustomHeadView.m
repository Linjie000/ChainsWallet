//
//  SCCustomHeadView.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCCustomHeadView.h"

#define LEFTBTNW 20

@interface SCCustomHeadView()
{
    
}
@end

@implementation SCCustomHeadView

-(instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = NAVIBAR_HEIGHT;
        
        self.x = self.y = 0;
        self.backgroundColor = [UIColor whiteColor];
        [self setUpView];
    }
    return self;
}

-(void)setUpView
{
    WeakSelf(weakSelf);
    _leftBtnImg = [UIImageView new];
    _leftBtnImg.image = [UIImage imageNamed:@"navi_back"];
//    _leftBtnImg.size = CGSizeMake(LEFTBTNW, LEFTBTNW);
    _leftBtnImg.size = CGSizeMake(8, 14);
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
    titlel.centerX = SCREEN_WIDTH/2;
    titlel.bottom = self.height;
    titlel.font = kFont(17);
    titlel.textAlignment = NSTextAlignmentCenter;
    _titleLab = titlel;
    [self addSubview:titlel];
    
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