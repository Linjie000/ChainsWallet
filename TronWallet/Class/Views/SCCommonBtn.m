//
//  SCCommonBtn.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/2.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCCommonBtn.h"

@interface SCCommonBtn ()

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

- (void)subViews{
    UILabel *backupvo = [UILabel new];
    backupvo.text = self.text;
    backupvo.backgroundColor = SCOrangeColor;
    backupvo.textAlignment = NSTextAlignmentCenter;
    backupvo.textColor = [UIColor whiteColor];
    backupvo.width = self.width;
    backupvo.height = self.height;
    backupvo.font = kFont(15);
    backupvo.x = backupvo.y = 0;
    [self addSubview:backupvo];
}

@end
