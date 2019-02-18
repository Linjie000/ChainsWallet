//
//  SCImportETHKeyController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/18.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCImportETHKeyController.h"
#import "SCCustomPlaceHolderTextView.h"
#import "SCUnderLineTextField.h"

#define marginX 15

@interface SCImportETHKeyController ()
<SCCustomPlaceHolderTextViewDelegate>
@property(strong, nonatomic) SCCustomPlaceHolderTextView *keystoreTF;
@property(strong, nonatomic) SCUnderLineTextField *passWordTF;
@property(strong, nonatomic) UIButton *recoverBtn;
@end

@implementation SCImportETHKeyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subViews];
}

- (void)subViews
{
    UILabel *titleLab = [UILabel new];
    titleLab.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 66);
    titleLab.x = marginX;
    titleLab.numberOfLines = 0;
    titleLab.font = kFont(13);
    titleLab.textColor = SCGray(128);
    titleLab.text = LocalizedString(@"复制粘贴以太坊官方钱包Keystore文件内容至输入框，或通过扫描Keystore内容生成二维码录入。");
    [self.view addSubview:titleLab];
    
    _keystoreTF = [SCCustomPlaceHolderTextView new];
    [self.view addSubview:_keystoreTF];
    _keystoreTF.placeholderFont = kFont(14);
    _keystoreTF.font = kFont(14);
    _keystoreTF.del = self;
    _keystoreTF.x = marginX;
    _keystoreTF.y = titleLab.bottom+10;
    _keystoreTF.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 150);
    _keystoreTF.layer.borderColor = SCGray(220).CGColor;
    _keystoreTF.layer.borderWidth = 0.4;
    _keystoreTF.placehoder = LocalizedString(@"Keystore文件内容");
    _keystoreTF.placehoderColor = SCGray(128);
    _keystoreTF.textContainerInset = UIEdgeInsetsMake(8, 4, 4, 4);
    _keystoreTF.placeholderTopMargin = 8;
    _keystoreTF.placeholderLeftMargin = 8;
    
    SCUnderLineTextField *passw = [SCUnderLineTextField new];
    passw.width = SCREEN_WIDTH - marginX*2;
    passw.height = 44;
    passw.centerX = SCREEN_WIDTH/2;
    passw.top = _keystoreTF.bottom+20;
    passw.tag = 256;
    passw.font = kFont(14);
    passw.secureTextEntry = YES;
    passw.backgroundColor = [UIColor clearColor];
    passw.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:LocalizedString(@"钱包密码") attributes:@{NSForegroundColorAttributeName : SCGray(128),NSFontAttributeName:kFont(14)}];
    [self.view addSubview:passw];
    [passw addTarget:self action:@selector(passWoreEdit:) forControlEvents:UIControlEventEditingChanged];
    self.passWordTF = passw;
    
    UIButton *recoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recoverBtn setBackgroundImage:[UIImage imageWithColor:SCGray(128)] forState:UIControlStateNormal];
    recoverBtn.titleLabel.font = kFont(16);
    recoverBtn.size = CGSizeMake(SCREEN_WIDTH-70, 45);
    recoverBtn.top = passw.bottom + 33;
    recoverBtn.centerX = SCREEN_WIDTH/2;
    [recoverBtn setTitle:LocalizedString(@"开始导入") forState:UIControlStateNormal];
    recoverBtn.layer.cornerRadius = 5;
    recoverBtn.layer.masksToBounds = YES;
    //    [recoverBtn setTitleEdgeInsets:UIEdgeInsetsMake(-13, 0, 0, 0)];
    [recoverBtn addTarget:self action:@selector(createIDAction) forControlEvents:UIControlEventTouchUpInside];
    _recoverBtn = recoverBtn;
    _recoverBtn.enabled = NO;
    [self.view addSubview:recoverBtn];
    
    //了解 Keystore
    UIButton *knowKeystore = [UIButton buttonWithType:UIButtonTypeCustom];
    knowKeystore.titleLabel.font = kFont(16);
    [knowKeystore setImage:IMAGENAME(@"了解-助记词") forState:UIControlStateNormal];
    knowKeystore.size = CGSizeMake(SCREEN_WIDTH, 49);
    knowKeystore.bottom = self.view.bottom-49-NAVIBAR_HEIGHT;
    knowKeystore.centerX = SCREEN_WIDTH/2;
    [knowKeystore setTitle:LocalizedString(@"了解Keystore") forState:UIControlStateNormal];
    [knowKeystore setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [knowKeystore setTitleColor:MainColor forState:UIControlStateNormal];
    [knowKeystore addTarget:self action:@selector(knowKeystoreActoin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:knowKeystore];
    
    UIView *line = [RewardHelper addLine2];
    line.bottom = knowKeystore.top;
    [self.view addSubview:line];
}

- (void)passWoreEdit:(SCUnderLineTextField *)tf
{
    [self btnHightlight];
}

- (void)customPlaceHolderTextViewTextDidChange:(SCCustomPlaceHolderTextView *)textView
{
    [self btnHightlight];
}

- (void)btnHightlight
{
    if (_keystoreTF.text.length&&_passWordTF.text.length) {
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

#pragma mark - 导入
- (void)createIDAction
{
    
}

@end
