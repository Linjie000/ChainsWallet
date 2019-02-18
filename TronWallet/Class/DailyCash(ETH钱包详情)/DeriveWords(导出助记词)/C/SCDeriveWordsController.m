//
//  SCDeriveWordsController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/9.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCDeriveWordsController.h"
#import "UILabel+SCString.h"
#import "SCCommonBtn.h"
#import "SCWarnView.h"

@interface SCDeriveWordsController ()

@end

@implementation SCDeriveWordsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)subViews
{
    UIImageView *createImg = [UIImageView new];
    createImg.size = CGSizeMake(35, 30);
    createImg.image = IMAGENAME(@"请勿截图");
    createImg.centerX = SCREEN_WIDTH/2;
    createImg.top = 30;
    [self.view addSubview:createImg];
    
    UILabel *lab = [UILabel new];
    lab.size = CGSizeMake(100, 40);
    lab.centerX = createImg.centerX;
    lab.top = createImg.bottom+3;
    lab.text = LocalizedString(@"请勿截图");
    lab.font = kFont(19);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = SCTEXTCOLOR;
    [self.view addSubview:lab];
    
    UIFont *font = kFont(16);
    CGFloat w = SCREEN_WIDTH - 45;
    NSString *str = LocalizedString(@"如果有人获取你的助记词将直接获取你的资产！请抄写下助记词并存放在安全的地方。");
    
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:str];
    nameText.font = font;
    nameText.color = SCGray(120);
    nameText.lineSpacing = 8;
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    YYTextContainer *nameContainer = [YYTextContainer containerWithSize:CGSizeMake(w, CGFLOAT_MAX)];
    YYTextLayout *nameTextLayout = [YYTextLayout layoutWithContainer:nameContainer text:nameText];
    
    YYLabel *textlab = [YYLabel new];
    textlab.textLayout = nameTextLayout;
    textlab.textAlignment = NSTextAlignmentCenter;
    textlab.size = nameTextLayout.textBoundingSize;
    textlab.centerX = createImg.centerX;
    textlab.top = lab.bottom+SCREEN_ADJUST_HEIGHT(30);
    textlab.numberOfLines = 0;
    [self.view addSubview:textlab];
    
    UITextView *textView = [UITextView new];
    textView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_ADJUST_HEIGHT(130));
    textView.x = 0;
    textView.y = textlab.bottom+SCREEN_ADJUST_HEIGHT(30);
    textView.editable = NO;
    textView.backgroundColor = SCGray(240);
    textView.textColor = SCTEXTCOLOR;
    textView.font = kFont(17);
    textView.text = @"meoasljf asdjf as dasfj asfop asjfoj  sjfo ojivc ie fijijid pqoei cvsfvf";
    [self.view addSubview:textView];
    
    SCCommonBtn *commonBtn = [SCCommonBtn createCommonBtnText:LocalizedString(@"完成")];
    commonBtn.bottom = self.view.bottom-NAVIBAR_HEIGHT;
    [self.view addSubview:commonBtn];
    [commonBtn setTapActionWithBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
