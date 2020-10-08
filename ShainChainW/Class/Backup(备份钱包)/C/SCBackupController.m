//
//  SCBackupController.m
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/29.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import "SCBackupController.h"
#import "UILabel+SCString.h"
#import "SCCommonBtn.h"

#import "SCBackupTipController.h"  //备份助记词
#import "BackupPriKeyController.h" //备份私钥


@interface SCBackupController ()

@end

@implementation SCBackupController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subViews];
}

- (void)subViews
{
    UIImageView *createImg = [UIImageView new];
    createImg.size = CGSizeMake(35, 30);
    createImg.image = IMAGENAME(@"1.8备份钱包");
    createImg.centerX = SCREEN_WIDTH/2;
    createImg.top = SCREEN_ADJUST_HEIGHT(30);
    [self.view addSubview:createImg];
    
    UILabel *lab = [UILabel new];
    lab.size = CGSizeMake(100, 40);
    lab.centerX = createImg.centerX;
    lab.top = createImg.bottom+3;
    lab.text = LocalizedString(@"备份钱包");
    lab.font = kFont(17);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = SCTEXTCOLOR;
    [self.view addSubview:lab];
    
    UIFont *font = kFont(15);
    CGFloat w = SCREEN_WIDTH - 30;
    NSString *str = LocalizedString(@"没有妥善备份就无法保障资产安全。删除系统或钱包后，你需要备份文件来恢复钱包。");

    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:str];
    nameText.font = font;
    nameText.color = SCTEXTCOLOR;
    nameText.lineSpacing = 8;
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    YYTextContainer *nameContainer = [YYTextContainer containerWithSize:CGSizeMake(w, CGFLOAT_MAX)];
    YYTextLayout *nameTextLayout = [YYTextLayout layoutWithContainer:nameContainer text:nameText];
 
    YYLabel *textlab = [YYLabel new];
    textlab.textLayout = nameTextLayout;
    textlab.size = nameTextLayout.textBoundingSize;
    textlab.centerX = createImg.centerX;
    textlab.top = lab.bottom+30;
    textlab.numberOfLines = 0;
    [self.view addSubview:textlab];
    
    SCCommonBtn *commonBtn = [SCCommonBtn createCommonBtnText:LocalizedString(@"备份钱包")];
    commonBtn.bottom = self.view.bottom-NAVIBAR_HEIGHT;
    [self.view addSubview:commonBtn];
    [commonBtn setTapActionWithBlock:^{
        SCBackupTipController *vc = [SCBackupTipController new];
//        BackupPriKeyController *vc = [BackupPriKeyController new];
        
        vc.wallet = self.wallet;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UILabel *backupvo = [UILabel new];
    backupvo.text = LocalizedString(@".请在四周无人、确保没有摄像头的安全环境进行备份.");
    backupvo.font = kFont(14);
    backupvo.textAlignment = NSTextAlignmentCenter;
    backupvo.textColor = SCTEXTCOLOR;
    CGFloat h = [RewardHelper textHeight:backupvo.text width:SCREEN_WIDTH - 30 font:backupvo.font];
    backupvo.size = CGSizeMake(SCREEN_WIDTH - 30, h);
    backupvo.centerX = SCREEN_WIDTH/2;
    backupvo.bottom = commonBtn.top - 28;
    backupvo.numberOfLines = 0;
    [self.view addSubview:backupvo];
    
}




@end
