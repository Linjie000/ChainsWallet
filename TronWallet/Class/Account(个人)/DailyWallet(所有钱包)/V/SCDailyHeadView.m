//
//  SCDailyHeadView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/11.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCDailyHeadView.h"

@interface SCDailyHeadView ()

@end

@implementation SCDailyHeadView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = NAVIBAR_HEIGHT;
        self.x = 0;
        self.y = 0;
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    UIView *borView = [UIView new];
    borView.size = CGSizeMake(60, 23);
    borView.centerX = SCREEN_WIDTH/2;
    borView.bottom = self.height - 9;
    borView.layer.borderWidth = 0.6;
    borView.layer.borderColor = [UIColor blackColor].CGColor;
    borView.layer.cornerRadius = borView.height/2;
    borView.clipsToBounds = YES;
    [self addSubview:borView];
    
    UIImageView *img = [UIImageView new];
    img.size = CGSizeMake(12, 12);
    img.centerX = borView.width/2;
    img.centerY = borView.height/2;
    img.image = IMAGENAME(@"icon_drop_down");
    [borView addSubview:img];
    
    UIView *view = [UIView new];
    view.size = CGSizeMake(60, self.height);
    view.centerX = SCREEN_WIDTH/2;
    view.bottom = self.height;
    [self addSubview:view];
    WeakSelf(weakSelf);
    [view setTapActionWithBlock:^{
        [[RewardHelper viewControllerWithView:weakSelf] dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
