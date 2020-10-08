//
//  PKRecoverIDController.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/14.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "PKRecoverIDController.h"
#import "SCCustomPlaceHolderTextView.h"
#import "SCUnderLineTextField.h"
#import "SCUserClauseView.h"
#import "SCRootTool.h"

#define marginX 25
#define view_width (SCREEN_WIDTH-2*marginX)

@interface PKRecoverIDController ()<UITextFieldDelegate>
{
    UILabel *_pwdtiplab;
}
@property(strong, nonatomic) SCCustomPlaceHolderTextView *textView;//私钥
@property(strong, nonatomic) UIImageView *questionImg;
@property(strong, nonatomic) SCUnderLineTextField *pwdTF;
@property(strong, nonatomic) SCUnderLineTextField *repwdTF;
@property(strong, nonatomic) SCUnderLineTextField *pwdtipTF;
@end

@implementation PKRecoverIDController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LocalizedString(@"恢复身份");
    
    [self subViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    SCUserClauseView *scv = [SCUserClauseView new];
    [KeyWindow addSubview:scv];
}

- (void)subViews
{
    UILabel *tiplab = [UILabel new];
    tiplab.width = SCREEN_WIDTH-2*marginX;
    tiplab.height = 30;
    tiplab.textColor = SCGray(128);
    tiplab.text = LocalizedString(@"使用私钥导入的同时可以修改钱包密码。");
    tiplab.font = kFont(14);
    tiplab.x = marginX;
    tiplab.y = 4;
    [self.view addSubview:tiplab];
    
    _textView = [SCCustomPlaceHolderTextView new];
    _textView.size = CGSizeMake(view_width, 89);
    _textView.backgroundColor = SCGray(240);
    _textView.placehoder=  LocalizedString(@"输入私钥");
    _textView.placehoderColor = SCGray(179);
    _textView.x = marginX;
    _textView.top = tiplab.bottom+25;
    _textView.placeholderFont = kFont(14);
    _textView.textContainerInset = UIEdgeInsetsMake(9, 9, 9, 9);
    _textView.placeholderTopMargin = 9;
    _textView.placeholderLeftMargin = 12;
    _textView.text = @"a4cf69022773611d375a7a139bee3e31551dca12c54df01082b5be1e21f39710";
    [self.view addSubview:_textView];
    
    UILabel *setpwdlab = [UILabel new];
    setpwdlab.font = kFont(14);
    setpwdlab.text = LocalizedString(@"设置密码");
    [setpwdlab sizeToFit];
    setpwdlab.x = marginX;
    setpwdlab.y = _textView.bottom+24;
    [self.view addSubview:setpwdlab];
    
    _questionImg = [UIImageView new];
    _questionImg.size = CGSizeMake(13, 13);
    _questionImg.centerY = setpwdlab.centerY;
    _questionImg.left = setpwdlab.right+5;
    _questionImg.image = IMAGENAME(@"设置密码");
    [self.view addSubview:_questionImg];
    [_questionImg setTapActionWithBlock:^{
        
    }];
    
    UIFont *font = kFont(14);
    _pwdTF = [SCUnderLineTextField new];
    _pwdTF.placeholder = LocalizedString(@"钱包密码");
    _pwdTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"钱包密码") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
    _pwdTF.size = CGSizeMake(view_width, 45);
    _pwdTF.x = marginX;
    _pwdTF.delegate = self;
    _pwdTF.tag = 256;
    _pwdTF.y = setpwdlab.bottom+20;
    [self.view addSubview:_pwdTF];
    
    UILabel *pwdtiplab = [UILabel new];
    pwdtiplab.size = CGSizeMake(SCREEN_WIDTH, 18);
    pwdtiplab.right = SCREEN_WIDTH - marginX;
    pwdtiplab.top = _pwdTF.bottom+5;
    pwdtiplab.textAlignment = NSTextAlignmentRight;
    pwdtiplab.font = kFont(12);
    pwdtiplab.textColor = SCPurpleColor;
    pwdtiplab.alpha = 0;
    pwdtiplab.text = LocalizedString(@"不少于8位字符，建议混合大小字母、数字、符号");
    [self.view addSubview:pwdtiplab];
    _pwdtiplab = pwdtiplab;
    
    _repwdTF = [SCUnderLineTextField new];
    _repwdTF.placeholder = LocalizedString(@"重复输入密码");
    _repwdTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"重复输入密码") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
    _repwdTF.size = CGSizeMake(view_width, 45);
    _repwdTF.x = marginX;
    _repwdTF.y = _pwdTF.bottom+5;
    [self.view addSubview:_repwdTF];
    
    _pwdtipTF = [SCUnderLineTextField new];
    _pwdtipTF.placeholder = LocalizedString(@"密码提示信息");
    _pwdtipTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"密码提示信息") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
    _pwdtipTF.size = CGSizeMake(view_width, 45);
    _pwdtipTF.x = marginX;
    _pwdtipTF.y = _repwdTF.bottom+5;
    [self.view addSubview:_pwdtipTF];
    
    //确认恢复身份
    UIButton *recoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recoverBtn setBackgroundImage:[UIImage imageWithColor:SCColor(252, 174, 50)] forState:UIControlStateNormal];
    [recoverBtn setBackgroundImage:[UIImage imageWithColor:SCColor(252, 160, 40)] forState:UIControlStateHighlighted];
    recoverBtn.titleLabel.font = kFont(16);
    recoverBtn.size = CGSizeMake(SCREEN_WIDTH-70, 45);
    recoverBtn.top = _pwdtipTF.bottom + 33;
    recoverBtn.centerX = SCREEN_WIDTH/2;
    [recoverBtn setTitle:LocalizedString(@"恢复身份") forState:UIControlStateNormal];
    recoverBtn.layer.cornerRadius = 5;
    //    recoverBtn.layer.masksToBounds = YES;
    recoverBtn.layer.shadowColor = [UIColor colorFromHexString:@"#fcae32"].CGColor;
    recoverBtn.layer.shadowOffset = CGSizeMake(0, 8);
    recoverBtn.layer.shadowOpacity = 0.16;
    //    [recoverBtn setTitleEdgeInsets:UIEdgeInsetsMake(-13, 0, 0, 0)];
    [recoverBtn addTarget:self action:@selector(createIDAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recoverBtn];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSInteger tag = textField.tag;
    if (tag == 256) {
        [self showPassWordTips];
    }
    return YES;
}

- (void)showPassWordTips
{
    if (_pwdtiplab.alpha) {
        return;
    }
    __block UILabel *ptlab = _pwdtiplab;
    [UIView animateWithDuration:0.2 animations:^{
        self.repwdTF.y = self.repwdTF.y+14;
        self.pwdtipTF.y = self.pwdtipTF.y+14;
        ptlab.alpha = 1;
    }];
}

#pragma mark - 恢复ID
- (void)createIDAction
{
    if (![self.repwdTF.text isEqualToString:self.pwdTF.text]) {
        [self showHudTitle:LocalizedString(@"密码不一致")];
        return;
    }
    if ([self isBlankString:self.textView.text]) {
        [self showHudTitle:LocalizedString(@"请输入私钥")];
        return;
    }
    if ([self isBlankString:self.repwdTF.text]||[self isBlankString:self.pwdTF.text]) {
        [self showHudTitle:LocalizedString(@"请输入密码")];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在恢复钱包"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *prikey = self.textView.text;
        NSString *password = self.pwdTF.text;
        TWWalletType type = TWWalletDefault;
        TWWalletAccountClient *client = [[TWWalletAccountClient alloc]initWithPriKeyStr:prikey type:type];
        if (!client) {
            [self showHudTitle:LocalizedString(@"私钥格式不正确")];
            [SVProgressHUD dismiss];
            return;
        }
        [client store:password];
        [UserinfoModel shareManage].appDelegate.walletClient = client;
        //数据库加入钱包
        walletModel *wallet = [[walletModel alloc]init];
        wallet.name = @"Tron-Wallet"; //默认钱包名称
//        wallet.password= self.pwdTF.text;;
        wallet.tips=self.pwdtipTF.text;
        wallet.isHide=@"0";
        wallet.address = client.base58OwnerAddress;
        wallet.ID = @(195);
        wallet.portrait = @"葡萄";//默认头像
        
        BOOL success = [wallet bg_save];
        if (!success) {
            [self showHudTitle:LocalizedString(@"创建钱包失败")];
            [SVProgressHUD dismiss];
            return;
        }
        [SCRootTool creatWallet];
        [SVProgressHUD dismiss];
 
        [[UserinfoModel shareManage].appDelegate createAccountDone];
    });
    
}



@end

