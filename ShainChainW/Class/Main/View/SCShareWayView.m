//
//  SCShareWayView.m
//  ShainChainW
//
//  Created by 闪链 on 2019/8/2.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCShareWayView.h"
#import "SCOutShareView.h"

@interface SCShareWayView ()
@property (strong, nonatomic) NSArray *iconArray;
@property (strong, nonatomic) NSArray *textArray;

@end

@implementation SCShareWayView
 
- (NSArray *)iconArray
{
    if (!_iconArray) {
        _iconArray = @[@"share_img",@"share_wx",@"share_pyq"];
    }
    return _iconArray;
}

- (NSArray *)textArray
{
    if (!_textArray) {
        _textArray = @[LocalizedString(@"保存图片"),LocalizedString(@"微信好友"),LocalizedString(@"微信朋友圈")];
    }
    return _textArray;
}

- (instancetype)init
{
    if (self=[super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.width = SCREEN_WIDTH;
        self.height = SCREEN_ADJUST_HEIGHT(200)+50;
        [self __loadUI];
    }
    return self;
}

- (void)__loadUI
{
    for (int i=0; i<self.iconArray.count; i++) {
        UIImageView *img = [UIImageView new];
        img.size = CGSizeMake(50, 50);
        img.image = IMAGENAME(self.iconArray[i]);
        img.x = i*(35+50)+16;
        img.y = 13;
        img.tag = 1024+i;
        [self addSubview:img];
        __block UIImageView *imagev = img;
        [img setTapActionWithBlock:^{
            if (self.delegate&&[self.delegate respondsToSelector:@selector(SCShareWayViewClick:)]) {
                [self.delegate SCShareWayViewClick:imagev.tag];
            }
        }];
        
        UILabel *lab = [UILabel new];
        lab.size = CGSizeMake(100, 30);
        lab.centerX = img.centerX;
        lab.y = img.bottom;
        lab.textColor = SCColor(129, 149, 164);
        lab.font = kHelBoldFont(13);
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = self.textArray[i];
        [self addSubview:lab];
    }
}
 
@end
