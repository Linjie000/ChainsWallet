//
//  ImportTronPriKeyController.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/25.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "ImportTronPriKeyController.h"
#import "SCCustomPlaceHolderTextView.h"
#import "SCUnderLineTextField.h"
#import "SCAlertCreater.h"
#import "HSEther.h"
#import "PortraitChoose.h"
#import "AESCrypt.h"
#import "SCRootTool.h"

#define marginX 15
#define view_width (SCREEN_WIDTH-2*marginX)
@interface ImportTronPriKeyController ()
<SCCustomPlaceHolderTextViewDelegate,UITextFieldDelegate>
@property(strong, nonatomic) SCCustomPlaceHolderTextView *keystoreTF;
@property(strong, nonatomic) UIButton *recoverBtn;
@property(strong, nonatomic) UIImageView *questionImg;
@property(strong, nonatomic) SCUnderLineTextField *pwdTF;
@property(strong, nonatomic) SCUnderLineTextField *repwdTF;
@property(strong, nonatomic) SCUnderLineTextField *pwdtipTF;

@property(strong ,nonatomic) UIView *eyesView;
@property(strong ,nonatomic) UIImageView *eyesImg;

@property(strong ,nonatomic) UIScrollView *scrollView;//适配 5s
@end

@implementation ImportTronPriKeyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subViews];
}

- (void)subViews
{
    WeakSelf(weakSelf);
    UILabel *titleLab = [UILabel new];
    titleLab.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 66);
    titleLab.x = marginX;
    titleLab.numberOfLines = 0;
    titleLab.font = kFont(13);
    titleLab.textColor = SCGray(128);
    titleLab.text = LocalizedString(@"输入 Private 文件内容至输入框。或通过扫描PrivateKey内容生成的二维码录入。请留意字符大小写。");
    [self.scrollView addSubview:titleLab];
    
    _keystoreTF = [SCCustomPlaceHolderTextView new];
    [self.scrollView addSubview:_keystoreTF];
    _keystoreTF.placeholderFont = kFont(14);
    _keystoreTF.font = kFont(14);
    _keystoreTF.del = self;
    _keystoreTF.x = marginX;
    _keystoreTF.y = titleLab.bottom+5;
    _keystoreTF.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 74);
    _keystoreTF.layer.borderColor = SCGray(220).CGColor;
    _keystoreTF.layer.borderWidth = 0.4;
    _keystoreTF.placehoder = LocalizedString(@"输入明文私钥");
    _keystoreTF.placehoderColor = SCGray(128);
    _keystoreTF.textContainerInset = UIEdgeInsetsMake(8, 4, 4, 4);
    _keystoreTF.placeholderTopMargin = 8;
    _keystoreTF.placeholderLeftMargin = 8;
    
    UILabel *setpwdlab = [UILabel new];
    setpwdlab.font = kFont(14);
    setpwdlab.text = LocalizedString(@"设置密码");
    [setpwdlab sizeToFit];
    setpwdlab.x = marginX;
    setpwdlab.y = _keystoreTF.bottom+15;
    [self.scrollView addSubview:setpwdlab];
    
    _questionImg = [UIImageView new];
    _questionImg.size = CGSizeMake(13, 13);
    _questionImg.centerY = setpwdlab.centerY;
    _questionImg.left = setpwdlab.right+5;
    _questionImg.image = IMAGENAME(@"设置密码");
    [self.scrollView addSubview:_questionImg];
    [_questionImg setTapActionWithBlock:^{
        //MARK: - 设置问题
    }];
    
    UIFont *font = kFont(14);
    _pwdTF = [SCUnderLineTextField new];
    _pwdTF.placeholder = LocalizedString(@"钱包密码(8位以上字母数字组合)");
    _pwdtipTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"钱包密码(8位以上字母数字组合)") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
    _pwdTF.size = CGSizeMake(view_width, 45);
    _pwdTF.x = marginX;
    _pwdTF.delegate = self;
    _pwdTF.tag = 256;
    _pwdTF.y = setpwdlab.bottom+4;
    _pwdTF.font = kFont(14);
    _pwdTF.secureTextEntry = YES;
    [_pwdTF addTarget:self action:@selector(passWoreEdit:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:_pwdTF];
    
    _repwdTF = [SCUnderLineTextField new];
    _repwdTF.placeholder = LocalizedString(@"重复输入密码");
    _repwdTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"重复输入密码") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
    _repwdTF.size = CGSizeMake(view_width, 45);
    _repwdTF.x = marginX;
    _repwdTF.tag = 257;
    _repwdTF.y = _pwdTF.bottom;
    _repwdTF.delegate = self;
    _repwdTF.font = kFont(14);
    _repwdTF.secureTextEntry = YES;
    [_repwdTF addTarget:self action:@selector(passWoreEdit:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:_repwdTF];
    
    _pwdtipTF = [SCUnderLineTextField new];
    _pwdtipTF.placeholder = LocalizedString(@"密码提示信息");
    _pwdtipTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"密码提示信息") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
    _pwdtipTF.size = CGSizeMake(view_width, 45);
    _pwdtipTF.x = marginX;
    _pwdtipTF.font = kFont(14);
    _pwdtipTF.y = _repwdTF.bottom;
    //    [_pwdtipTF addTarget:self action:@selector(passWoreEdit:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:_pwdtipTF];
    
    //确认恢复身份
    UIButton *recoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recoverBtn setBackgroundImage:[UIImage imageWithColor:SCGray(128)] forState:UIControlStateNormal];
    recoverBtn.titleLabel.font = kFont(16);
    recoverBtn.size = CGSizeMake(SCREEN_WIDTH-70, 45);
    recoverBtn.top = _pwdtipTF.bottom + 33;
    recoverBtn.centerX = SCREEN_WIDTH/2;
    [recoverBtn setTitle:LocalizedString(@"开始导入") forState:UIControlStateNormal];
    recoverBtn.layer.cornerRadius = 5;
    recoverBtn.layer.masksToBounds = YES;
    //    [recoverBtn setTitleEdgeInsets:UIEdgeInsetsMake(-13, 0, 0, 0)];
    _recoverBtn = recoverBtn;
    _recoverBtn.enabled = NO;
    [recoverBtn addTarget:self action:@selector(createIDAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:recoverBtn];
    
    //了解 Keystore
    UIButton *knowKeystore = [UIButton buttonWithType:UIButtonTypeCustom];
    knowKeystore.titleLabel.font = kFont(16);
    [knowKeystore setImage:IMAGENAME(@"了解-助记词") forState:UIControlStateNormal];
    knowKeystore.size = CGSizeMake(SCREEN_WIDTH, 49);
    knowKeystore.bottom = self.view.bottom-NAVIBAR_HEIGHT;
    knowKeystore.centerX = SCREEN_WIDTH/2;
    [knowKeystore setTitle:LocalizedString(@"了解 明文私钥") forState:UIControlStateNormal];
    [knowKeystore setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [knowKeystore setTitleColor:MainColor forState:UIControlStateNormal];
    [knowKeystore addTarget:self action:@selector(knowKeystoreActoin) forControlEvents:UIControlEventTouchUpInside];
    knowKeystore.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:knowKeystore];
    
    UIView *line = [RewardHelper addLine2];
    line.top = 0;
    [knowKeystore addSubview:line];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, recoverBtn.bottom+30);
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
    if (_keystoreTF.text.length&&_pwdTF.text.length&&_repwdTF.text.length) {
        [_recoverBtn setBackgroundImage:[UIImage imageWithColor:SCColor(252, 174, 50)] forState:UIControlStateNormal];
        _recoverBtn.enabled = YES;
    }
    else
    {
        [_recoverBtn setBackgroundImage:[UIImage imageWithColor:SCGray(128)] forState:UIControlStateNormal];
        _recoverBtn.enabled = NO;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSInteger tag = textField.tag;
    if (tag == 256) {
        [self showEyesToView:textField];
    }
    if (tag == 257) {
        [self showEyesToView:textField];
    }
    return YES;
}

#pragma mark - 是否显示密码
- (void)showEyesToView:(UITextField *)textField
{
    
    [self.scrollView addSubview:self.eyesView]; 
    self.eyesView.right = textField.right;
    self.eyesView.centerY = textField.centerY;
    __block BOOL show = NO;
    WeakSelf(weakSelf);
    [self.eyesView setTapActionWithBlock:^{
        show = !show;
        if (show) {
            weakSelf.eyesImg.image = IMAGENAME(@"密码-显示");
            _pwdTF.secureTextEntry = NO;
            _repwdTF.secureTextEntry = NO;
        }else{
            weakSelf.eyesImg.image = IMAGENAME(@"密码-不显示");
            _pwdTF.secureTextEntry = YES;
            _repwdTF.secureTextEntry = YES;
        }
    }];
}

- (UIView *)eyesView
{
    if (!_eyesView) {
        _eyesView = [UIView new];
        _eyesView.size = CGSizeMake(40, 40);
        [_eyesView addSubview:self.eyesImg];
    }
    return _eyesView;
}

- (UIImageView *)eyesImg
{
    if (!_eyesImg) {
        _eyesImg = [UIImageView new];
        _eyesImg.size = CGSizeMake(17, 7);
        _eyesImg.centerX = 20;
        _eyesImg.centerY = 20;
    }
    return _eyesImg;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-42-NAVIBAR_HEIGHT-49);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.x = _scrollView.y = 0;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)knowKeystoreActoin
{
    
}

#pragma mark - 导入
- (void)createIDAction
{
    NSString *private = _keystoreTF.text;
    NSString *pwd = _pwdTF.text;
    NSString *repwd = _repwdTF.text;
    NSString *tip = _pwdtipTF.text;
    if ([RewardHelper isBlankString:private]) {
        [TKCommonTools showToast:LocalizedString(@"请输入私钥")];
        return;
    }
    if ([RewardHelper isBlankString:pwd]||[RewardHelper isBlankString:repwd]) {
        [TKCommonTools showToast:LocalizedString(@"请输入密码")];
        return;
    }
    if (![repwd isEqualToString:pwd]) {
        [TKCommonTools showToast:LocalizedString(@"两次输入密码不相同")];
        return;
    }
    if (![NSString validateStringCombineNumberWithEnChar:pwd]||pwd.length<=7) {
        [TKCommonTools showToast:LocalizedString(@"密码必须为8位以上字母数字组合")];
        return;
    }
 
    TWWalletType type = TWWalletDefault;
    TWWalletAccountClient *client = [[TWWalletAccountClient alloc] initWithPriKeyStr:private type:type];
    if (!client) {
        [TKCommonTools showToast:LocalizedString(@"导入失败，请确保密钥正确")];
        return;
    }
 
    [SVProgressHUD showWithStatus:LocalizedString(@"正在导入")];
    NSArray *walletArr= [walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"ID"],[NSObject bg_sqlValue:@(195)]]];
    walletModel *wallet = [walletModel new];
    wallet.password=[AESCrypt encrypt:pwd password:pwd];;
    wallet.isHide=@"0";
    wallet.ID = @(195);
    wallet.resourceOP = YES;
    wallet.portrait = [PortraitChoose getRandomPortraitName];
    wallet.name = [NSString stringWithFormat:@"Tron-Wallet-%ld",walletArr.count];
    wallet.isSystem = @(0);
    wallet.mnemonics = @"";
    wallet.balance = @"";
    wallet.tips = tip;
    [wallet bg_save];
    walletModel *newWall = [[walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"name"],[NSObject bg_sqlValue:wallet.name]]] lastObject];
    
    [UserinfoModel shareManage].walletType = TRON_WALLET_TYPE;
    NSArray *Namearray3=[UserinfoModel shareManage].Namearray;
    NSArray *typeArray3=[UserinfoModel shareManage].coinTypeArray;
    NSArray *recordTypeArray3=[UserinfoModel shareManage].recordTypeArray;
    NSArray *AddressprefixArray3=[UserinfoModel shareManage].AddressprefixTypeArray;
    NSArray *PriveprefixArray3=[UserinfoModel shareManage].PriveprefixTypeArray;
    NSArray *englishNameArray3=[UserinfoModel shareManage].englishNameArray;
    
    
    [client store:pwd];
    client.own_id = newWall.bg_id;
    [client bg_save];
    
    for (int i=0; i<Namearray3.count; i++) {
        [SCRootTool creatCoins:Namearray3[i] withEnglishName:englishNameArray3[i] withCointype:[typeArray3[i] intValue] withAddressprefix:[AddressprefixArray3[i] intValue] withPriveprefix:[PriveprefixArray3[i] intValue]  withRecordtype:recordTypeArray3[i] withID:newWall.bg_id totalAmount:@"0.00" withWallet:newWall contractAddress:@""];
    }
    newWall.address = client.base58OwnerAddress;
    newWall.privateKey = [AESCrypt encrypt:private password:pwd];
 
    BOOL success = [newWall bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:newWall.bg_id]]];
    if (success) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [TKCommonTools showToast:LocalizedString(@"导入成功")];
            [self.navigationController popViewControllerAnimated:YES];
            [self postNotificationForName:KEY_SCWALLET_EDITED userInfo:@{}];
        });
    }else
    {
        [TKCommonTools showToast:LocalizedString(@"导入失败，请重新尝试")];
    }
}

@end
