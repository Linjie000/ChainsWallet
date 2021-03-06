//
//  SCImportEOSPKeyController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/19.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCImportEOSPKeyController.h"
#import "SCUnderLineTextField.h"
#import "SCAlertCreater.h"
#import "HSEther.h"
#import "PortraitChoose.h"
#import "AESCrypt.h"
#import "SCRootTool.h"
#import "EOS_Key_Encode.h"
#import "Get_key_accounts_request.h"
#import "Get_account_permission_service.h"
#import "EOSAccountModel.h"

#define marginX 15
#define view_width (SCREEN_WIDTH-2*marginX)
@interface SCImportEOSPKeyController ()
<SCCustomPlaceHolderTextViewDelegate,UITextFieldDelegate>
{
    NSString *public_key_1_from_local; 
}

@property(strong, nonatomic) UIButton *recoverBtn;
@property(strong, nonatomic) UIImageView *questionImg;
@property(strong, nonatomic) SCUnderLineTextField *pwdTF;
@property(strong, nonatomic) SCUnderLineTextField *repwdTF;
@property(strong, nonatomic) SCUnderLineTextField *pwdtipTF;
@property(strong ,nonatomic) UIView *eyesView;
@property(strong ,nonatomic) UIImageView *eyesImg;
@property(strong ,nonatomic) UIScrollView *scrollView;//适配 5s
@property(strong ,nonatomic) Get_key_accounts_request *getAccountService;
@property(strong ,nonatomic) Get_account_permission_service *get_account_permission_service;
@property(strong ,nonatomic) EOSAccountModel *importAccountModel;
@end

@implementation SCImportEOSPKeyController

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
    _pwdTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"钱包密码(8位以上字母数字组合)") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
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
    [recoverBtn addTarget:self action:@selector(createPublicKeys) forControlEvents:UIControlEventTouchUpInside];
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

- (Get_key_accounts_request *)getAccountService
{
    if (!_getAccountService) {
        _getAccountService = [[Get_key_accounts_request alloc]init];
    }
    return _getAccountService;
}

- (Get_account_permission_service *)get_account_permission_service
{
    if (!_get_account_permission_service) {
        _get_account_permission_service = [[Get_account_permission_service alloc]init];
    }
    return _get_account_permission_service;
}

- (void)knowKeystoreActoin
{
    
}

- (void)createPublicKeys{
    
    NSString *private = _keystoreTF.text;
    NSString *pwd = _pwdTF.text;
    NSString *repwd = _repwdTF.text;
    NSString *tip = _pwdtipTF.text;
    if ([self isBlankString:_keystoreTF.text]) {
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
    // 将用户导入的私钥生成公钥
    [SVProgressHUD showWithStatus:LocalizedString(@"正在导入")];
    public_key_1_from_local = [EOS_Key_Encode eos_publicKey_with_wif:self.keystoreTF.text];
    [self requestAccountsAccordingPublicKey];
}

- (void)requestAccountsAccordingPublicKey{
    WeakSelf(weakSelf);
    self.getAccountService.public_key = (public_key_1_from_local);
    [self.getAccountService get_key_accounts:^(NSArray *importAccountModelArray, BOOL isSuccess) {
        if (isSuccess&&importAccountModelArray.count) {
            [self importAccount_AccounsNameDataSourceViewTableViewCellDidClick:importAccountModelArray[0]];
        }else{
            [TKCommonTools showToast:NSLocalizedString(@"查询账号失败", nil)];
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)importAccount_AccounsNameDataSourceViewTableViewCellDidClick:(EOSAccountModel *)model{
//     请求该账号的公钥
    WeakSelf(weakSelf);
    self.importAccountModel = model;
    self.get_account_permission_service.name = (model.accountName) ;
    [self.get_account_permission_service getAccountPermission:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            [self createIDAction];
        }
        else
        {
            [SVProgressHUD dismiss];
        }
    }];
 
}

#pragma mark - 导入
- (void)createIDAction
{

    NSString *private = _keystoreTF.text;
    NSString *pwd = _pwdTF.text;
    NSString *repwd = _repwdTF.text;
    NSString *tip = _pwdtipTF.text;
    
    NSString *privateKey_text = [AESCrypt encrypt:private password:pwd];
 
    NSArray *walletArr= [walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"ID"],[NSObject bg_sqlValue:@(194)]]];
    walletModel *wallet = [walletModel new];
    wallet.isHide=@"0";
    wallet.ID = @(194);
    wallet.portrait = [PortraitChoose getRandomPortraitName];
    wallet.isSystem = @(0);
    wallet.resourceOP = YES;
    wallet.mnemonics = @"";
    wallet.balance = @"";
    wallet.tips = tip;
    wallet.address = self.importAccountModel.accountName;
    wallet.privateKey = privateKey_text;
    wallet.password = [AESCrypt encrypt:pwd password:pwd];
    if (!walletArr.count) {
        wallet.name = @"EOS-Wallet";
    }else
    {
        wallet.name = [NSString stringWithFormat:@"EOS-Wallet-%ld",walletArr.count];
    }
    
    if ([self.get_account_permission_service.chainAccountOwnerPublicKeyArray containsObject:public_key_1_from_local] && ![self.get_account_permission_service.chainAccountActivePublicKeyArray containsObject:public_key_1_from_local]) {//只owner匹配
        wallet.account_owner_public_key = public_key_1_from_local;
        wallet.account_owner_private_key = privateKey_text;
        wallet.account_active_public_key = @"";
        wallet.account_active_private_key = @"";
 
    }else if (![self.get_account_permission_service.chainAccountOwnerPublicKeyArray containsObject:public_key_1_from_local] && [self.get_account_permission_service.chainAccountActivePublicKeyArray containsObject:public_key_1_from_local]){// //只active匹配
        wallet.account_owner_public_key = @"";
        wallet.account_owner_private_key = @"";
        wallet.account_active_public_key = public_key_1_from_local;
        wallet.account_active_private_key = privateKey_text;
    
    }else if ([self.get_account_permission_service.chainAccountOwnerPublicKeyArray containsObject:public_key_1_from_local] && [self.get_account_permission_service.chainAccountActivePublicKeyArray containsObject:public_key_1_from_local]){//owner和active全部匹配
        wallet.account_owner_public_key = public_key_1_from_local;
        wallet.account_owner_private_key = privateKey_text;
        wallet.account_active_public_key = public_key_1_from_local;
        wallet.account_active_private_key = privateKey_text;
 
    }else{//不匹配 导入失败
        [TKCommonTools showToast:NSLocalizedString(@"权限错误", nil)];
        [SVProgressHUD dismiss];
        return;
    }
    bool success = [wallet bg_save];
    
    walletModel *newWall = [[walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"name"],[NSObject bg_sqlValue:wallet.name]]] lastObject];
    
    [UserinfoModel shareManage].walletType = EOS_WALLET_TYPE;
    NSArray *Namearray=[UserinfoModel shareManage].Namearray;
    NSArray *typeArray=[UserinfoModel shareManage].coinTypeArray;
    NSArray *recordTypeArray=[UserinfoModel shareManage].recordTypeArray;
    NSArray *AddressprefixArray=[UserinfoModel shareManage].AddressprefixTypeArray;
    NSArray *PriveprefixArray=[UserinfoModel shareManage].PriveprefixTypeArray;
    NSArray *englishNameArray=[UserinfoModel shareManage].englishNameArray;
    for (int i=0; i<Namearray.count; i++) {
        [SCRootTool creatCoins:Namearray[i] withEnglishName:englishNameArray[i] withCointype:[typeArray[i] intValue] withAddressprefix:[AddressprefixArray[i] intValue] withPriveprefix:[PriveprefixArray[i] intValue]  withRecordtype:recordTypeArray[i] withID:newWall.bg_id totalAmount:@"0.00" withWallet:newWall contractAddress:@""];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        if (!success) return ;
        [TKCommonTools showToast:LocalizedString(@"导入成功")];
        [[RewardHelper viewControllerWithView:self.view].navigationController popViewControllerAnimated:YES];
        [self postNotificationForName:KEY_SCWALLET_EDITED userInfo:@{}];
        if (self.isChoose) {
            [self postNotificationForName:KEY_SCWALLET_TYPE userInfo:@{@"wallet":newWall}];
        }
    });
}

@end
