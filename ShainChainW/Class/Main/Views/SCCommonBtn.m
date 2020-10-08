//
//  SCCommonBtn.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/2.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCCommonBtn.h"

@interface SCCommonBtn ()
{
    UILabel *_backupvo;
}
@end

@implementation SCCommonBtn

+ (instancetype)createCommonBtnText:(NSString *)str
{
    SCCommonBtn *btn = [[SCCommonBtn alloc]init];
    btn.text = str;
    [btn subViews];
    return btn;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.x = 0; 
        self.width = SCREEN_WIDTH;
        self.height = 50;
    }
    return self;
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    _backupvo.backgroundColor = _backColor;
}

- (void)subViews{
    _backupvo = [UILabel new];
    _backupvo.text = self.text;
    _backupvo.backgroundColor = SCOrangeColor;
    _backupvo.textAlignment = NSTextAlignmentCenter;
    _backupvo.textColor = [UIColor whiteColor];
    _backupvo.width = self.width;
    _backupvo.height = self.height;
    _backupvo.font = kFont(15);
    _backupvo.x = _backupvo.y = 0;
    [self addSubview:_backupvo];
}

@end
