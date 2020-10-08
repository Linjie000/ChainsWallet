//
//  SCImportETHColdController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/18.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCImportETHColdController.h"


@interface SCImportETHColdController ()

@property(strong, nonatomic) UIButton *recoverBtn;
@end

@implementation SCImportETHColdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subViews];
}

- (void)subViews
{
    UIFont *detailFont = kFont(13);
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"•目前仅限用户观察自己的钱包来配合离线钱包形成更加安全的冷钱包；导入需要一次签名。\n•存储大额资金建议使用冷钱包或购买硬件钱包") attributes:@{NSKernAttributeName:@(1)}];
    detailText.font = detailFont;
    detailText.color = SCGray(128);
    NSRange rang = [[detailText string] rangeOfString:@"•"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [detailText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailText length])];
    [detailText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rang];
    paragraphStyle.lineSpacing = 8;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;//防止文字存在中英文空出太多
    YYTextContainer *detailContainer = [YYTextContainer containerWithSize:CGSizeMake(SCREEN_WIDTH-30, CGFLOAT_MAX)];
    YYLabel *titlelab = [YYLabel new];
    YYTextLayout *detailLayout = [YYTextLayout layoutWithContainer:detailContainer text:detailText];
    titlelab.size = detailLayout.textBoundingSize;
    titlelab.textLayout = detailLayout;
    titlelab.x = 15;
    titlelab.y = 17;
    [self.view addSubview:titlelab];
    
    UIFont *font = kFont(14);
    _addressTF = [SCUnderLineTextField new];
    _addressTF.placeholder = LocalizedString(@"钱包地址");
    _addressTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"钱包地址") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
    _addressTF.size = CGSizeMake(SCREEN_WIDTH-30, 45);
    _addressTF.x = 15;
    _addressTF.tag = 256;
    _addressTF.y = titlelab.bottom+10;
    _addressTF.font = kFont(14);
    _addressTF.secureTextEntry = YES;
    [_addressTF addTarget:self action:@selector(_addressTFEdit:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_addressTF];
    
    //确认恢复身份
    UIButton *recoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recoverBtn setBackgroundImage:[UIImage imageWithColor:SCGray(128)] forState:UIControlStateNormal];
    recoverBtn.titleLabel.font = kFont(16);
    recoverBtn.size = CGSizeMake(SCREEN_WIDTH-70, 45);
    recoverBtn.top = _addressTF.bottom + 33;
    recoverBtn.centerX = SCREEN_WIDTH/2;
    [recoverBtn setTitle:LocalizedString(@"下一步") forState:UIControlStateNormal];
    recoverBtn.layer.cornerRadius = 5;
    recoverBtn.layer.masksToBounds = YES;
    //    [recoverBtn setTitleEdgeInsets:UIEdgeInsetsMake(-13, 0, 0, 0)];
    _recoverBtn = recoverBtn;
    _recoverBtn.enabled = NO;
    [recoverBtn addTarget:self action:@selector(createIDAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recoverBtn];
    
    //了解 Keystore
    UIButton *knowKeystore = [UIButton buttonWithType:UIButtonTypeCustom];
    knowKeystore.titleLabel.font = kFont(16);
    [knowKeystore setImage:IMAGENAME(@"了解-助记词") forState:UIControlStateNormal];
    knowKeystore.size = CGSizeMake(SCREEN_WIDTH, 49);
    knowKeystore.bottom = self.view.bottom-42-NAVIBAR_HEIGHT;
    knowKeystore.centerX = SCREEN_WIDTH/2;
    [knowKeystore setTitle:LocalizedString(@"为我介绍冷钱包的使用方法") forState:UIControlStateNormal];
    [knowKeystore setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [knowKeystore setTitleColor:MainColor forState:UIControlStateNormal];
    [knowKeystore addTarget:self action:@selector(knowKeystoreActoin) forControlEvents:UIControlEventTouchUpInside];
    knowKeystore.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:knowKeystore];
    
    UIView *line = [RewardHelper addLine2];
    line.top = 0;
    [knowKeystore addSubview:line];
}

- (void)_addressTFEdit:(SCUnderLineTextField *)tf
{
    if (_addressTF.text.length) {
        [_recoverBtn setBackgroundImage:[UIImage imageWithColor:SCColor(252, 174, 50)] forState:UIControlStateNormal];
        _recoverBtn.enabled = YES;
    }
    else
    {
        [_recoverBtn setBackgroundImage:[UIImage imageWithColor:SCGray(128)] forState:UIControlStateNormal];
        _recoverBtn.enabled = NO;
    }
}

- (void)knowKeystoreActoin
{
    
}

- (void)createIDAction
{
    
}

@end
