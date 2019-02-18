//
//  SCBackupTipController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/2.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//  生成记助词

#import "SCBackupTipController.h"
#import "SCAffirmBackupController.h"
#import "UILabel+SCString.h"
#import "SCCommonBtn.h"
#import "SCWarnView.h"
#import "SCMnemonicView.h"
#import "SCWalletObject.h"

@interface SCBackupTipController ()
@property (strong, nonatomic) SCMnemonicView *mnemonicView;
@property (strong, nonatomic) NSArray *mnemonicArray;
@end

@implementation SCBackupTipController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    SCWarnView *scv = [[SCWarnView alloc]initWithText:LocalizedString(@"如果有人获取你的助记词将直接获取你的资产！请抄写下助记词并存放在安全的地方。")];
//    [KeyWindow addSubview:scv];
}

- (void)subViews
{
    UIImageView *createImg = [UIImageView new];
    createImg.size = CGSizeMake(35, 30);
    createImg.image = IMAGENAME(@"1.11助记词");
    createImg.centerX = SCREEN_WIDTH/2;
    createImg.top = 30;
    [self.view addSubview:createImg];
    
    UILabel *lab = [UILabel new];
    lab.size = CGSizeMake(100, 40);
    lab.centerX = createImg.centerX;
    lab.top = createImg.bottom+3;
    lab.text = LocalizedString(@"备份记助词");
    lab.font = kFont(17);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = SCTEXTCOLOR;
    [self.view addSubview:lab];
    
    UIFont *font = kFont(14);
    CGFloat w = SCREEN_WIDTH - 45;
    NSString *str = LocalizedString(@"请仔细抄写下方的记助词，我们将在下一步验证。");
    
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
    
    UIView *bgView = [UIView new];
    bgView.size = CGSizeMake(SCREEN_WIDTH, 120);
    bgView.x = 0;
    bgView.y = textlab.bottom+SCREEN_ADJUST_HEIGHT(30);
    bgView.backgroundColor = SCGray(250);
    [self.view addSubview:bgView];
    
    _mnemonicView = [SCMnemonicView init:CGRectMake(0, 0, SCREEN_WIDTH - 20, bgView.height)];
    _mnemonicView.centerX = bgView.width/2;
    _mnemonicView.centerY = bgView.height/2;
    [bgView addSubview:_mnemonicView];
    
    _mnemonicArray = [[SCWalletObject generateMnemonicString:@128 language:@"english"] componentsSeparatedByString:@" "];
    _mnemonicView.mnemonicWord = _mnemonicArray;
    
    SCCommonBtn *commonBtn = [SCCommonBtn createCommonBtnText:LocalizedString(@"下一步")];
    commonBtn.bottom = self.view.bottom-NAVIBAR_HEIGHT;
    [self.view addSubview:commonBtn];
    
    SCAffirmBackupController *bc = [SCAffirmBackupController new];
    bc.mnemonicArray = _mnemonicArray;
    [commonBtn setTapActionWithBlock:^{
        [self.navigationController pushViewController:bc animated:YES];
    }];
}


@end
