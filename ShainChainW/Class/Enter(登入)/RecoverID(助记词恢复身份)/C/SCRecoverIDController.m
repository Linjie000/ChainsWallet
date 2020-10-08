//
//  SCRecoverIDController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/18.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCRecoverIDController.h"
#import "SCCustomPlaceHolderTextView.h"
#import "SCUnderLineTextField.h"
#import "SCUserClauseView.h"
#import "CreateWalletTool.h"
#import "AESCrypt.h"

#define marginX 25
#define view_width (SCREEN_WIDTH-2*marginX)

@interface SCRecoverIDController ()<UITextFieldDelegate>
{
    UILabel *_pwdtiplab;
}
@property(strong, nonatomic) SCCustomPlaceHolderTextView *textView;//助记词
@property(strong, nonatomic) UIImageView *questionImg;
@property(strong, nonatomic) SCUnderLineTextField *pwdTF;
@property(strong, nonatomic) SCUnderLineTextField *repwdTF;
@property(strong, nonatomic) SCUnderLineTextField *pwdtipTF;
@end

@implementation SCRecoverIDController

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
    tiplab.text = LocalizedString(@"使用助记词导入的同时可以修改钱包密码。");
    tiplab.font = kFont(14);
    tiplab.x = marginX;
    tiplab.y = 4;
    [self.view addSubview:tiplab];
    
    _textView = [SCCustomPlaceHolderTextView new];
    _textView.size = CGSizeMake(view_width, 89);
    _textView.backgroundColor = SCGray(245);
    _textView.placehoder=  LocalizedString(@"输入助记词，用空格分割");
    _textView.placehoderColor = SCGray(179);
    _textView.x = marginX;
    _textView.top = tiplab.bottom+25;
    _textView.placeholderFont = kFont(14);
    _textView.textContainerInset = UIEdgeInsetsMake(9, 9, 9, 9);
    _textView.placeholderTopMargin = 9;
    _textView.placeholderLeftMargin = 12;
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
    _pwdTF.secureTextEntry = YES;
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
    _repwdTF.secureTextEntry = YES;
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
    __block UILabel *ptlab = _pwdtiplab;
    if (_pwdtiplab.alpha) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.repwdTF.y = self.repwdTF.y+14;
        self.pwdtipTF.y = self.pwdtipTF.y+14;
        ptlab.alpha = 1;
    }];
}

#pragma mark - 恢复ID
- (void)createIDAction
{
    if (![Account isValidMnemonicPhrase:_textView.text]) {
        [TKCommonTools showToast:LocalizedString(@"助记词格式错误")];
        return;
    }
    if ([RewardHelper isBlankString:_pwdTF.text]) {
        [TKCommonTools showToast:LocalizedString(@"请输入密码")];
        return;
    }
    if (![self.repwdTF.text isEqualToString:_pwdTF.text]) {
        [TKCommonTools showToast:LocalizedString(@"两次输入密码不相同")];
        return;
    }
    if (![NSString validateStringCombineNumberWithEnChar:_pwdTF.text]||_pwdTF.text.length<=7) {
        [TKCommonTools showToast:LocalizedString(@"密码必须为8位以上字母数字组合")];
        return;
    }
 
    walletModel *wallet = [[walletModel alloc]init];
    wallet.password= _pwdTF.text;
    wallet.tips= _pwdtipTF.text;
    wallet.isHide=@"0";
    wallet.mnemonics = [AESCrypt encrypt:_textView.text password:_pwdTF.text];
    [UserinfoModel shareManage].wallet = wallet;
    
    [SVProgressHUD showWithStatus:LocalizedString(@"正在创建钱包")];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self creatFmdb];
    [self creatWallet];
}

//存储数据库
- (void)creatFmdb
{
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    
    wallet.ID = @(0);
    [wallet bg_save];
    
    wallet.ID = @(60);
    [wallet bg_save];
    
    wallet.ID = @(195);
    [wallet bg_save];
}

- (void)creatWallet
{
#pragma mark - 创建BTC钱包
    [CreateWalletTool creatBTCWallet:NO];
    
#pragma mark - 创建ETH钱包
    Account *account = [Account accountWithMnemonicPhrase:_textView.text];
    [CreateWalletTool creatETHWallet:account success:^(BOOL result) {
        if (result) {
            [SVProgressHUD dismiss];
            AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [appdelegate createAccountDone];
        }else
        {
            [SVProgressHUD dismiss];
            [TKCommonTools showToast:LocalizedString(@"创建失败")];
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [CreateWalletTool createTRXWallet];
    });
}

@end

