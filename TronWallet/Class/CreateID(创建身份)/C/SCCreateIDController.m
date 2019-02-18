//
//  SCCreateIDController.m
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/29.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import "SCCreateIDController.h"
#import "SCUnderLineTextField.h"
#import "SCCreateIDTipView.h"
#import "SCCommonBtn.h"
#import "SCBackupController.h"

#define marginX 22
#define TFHeight 55

@interface SCCreateIDController ()<UITextFieldDelegate>
@property(strong ,nonatomic) SCUnderLineTextField *unlt;
@property(strong ,nonatomic) SCUnderLineTextField *passw;
@property(strong ,nonatomic) SCUnderLineTextField *repassw;
@property(strong ,nonatomic) SCUnderLineTextField *passwtip;
@property(strong ,nonatomic) UILabel *tiplab;
@property(strong ,nonatomic) SCCreateIDTipView *idTipView;

@property(strong ,nonatomic) UIView *eyesView;
@property(strong ,nonatomic) UIImageView *eyesImg;
@end

@implementation SCCreateIDController

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
        _eyesImg.size = CGSizeMake(20, 10);
        _eyesImg.centerX = 20;
        _eyesImg.centerY = 20;
    }
    return _eyesImg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subViews];
}

- (void)subViews
{
    UIImageView *createImg = [UIImageView new];
    createImg.size = CGSizeMake(35, 30);
    createImg.image = IMAGENAME(@"1.4创建身份");
    createImg.centerX = SCREEN_WIDTH/2;
    createImg.top = 30;
    [self.view addSubview:createImg];
    
    UILabel *lab = [UILabel new];
    lab.size = CGSizeMake(100, 40);
    lab.centerX = createImg.centerX;
    lab.top = createImg.bottom+3;
    lab.text = LocalizedString(@"创建身份");
    lab.font = kFont(17);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = SCGray(40);
    [self.view addSubview:lab];
    
    UIColor *pcolor = SCGray(130);
    UIFont *pfont = kFont(14);
    SCUnderLineTextField *unlt = [SCUnderLineTextField new];
    unlt.width = SCREEN_WIDTH - marginX*2;
    unlt.height = TFHeight;
    unlt.centerX = SCREEN_WIDTH/2;
    unlt.top = lab.bottom + 20;
    unlt.backgroundColor = [UIColor clearColor];
    unlt.delegate = self;
    unlt.tag = 255;
    unlt.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:LocalizedString(@"身份名") attributes:@{NSForegroundColorAttributeName : pcolor,NSFontAttributeName:pfont}];
    [self.view addSubview:unlt];
    _unlt = unlt;
 
    SCUnderLineTextField *passw = [SCUnderLineTextField new];
    passw.width = SCREEN_WIDTH - marginX*2;
    passw.height = TFHeight;
    passw.centerX = SCREEN_WIDTH/2;
    passw.top = unlt.bottom ;
    passw.backgroundColor = [UIColor clearColor];
    passw.delegate = self;
    passw.tag = 256;
    passw.secureTextEntry = YES;
    passw.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:LocalizedString(@"密码") attributes:@{NSForegroundColorAttributeName : pcolor,NSFontAttributeName:pfont}];
    [self.view addSubview:passw];
    self.passw = passw;
//    [passw addSubview:self.eyesImg];
    
    
    SCUnderLineTextField *repassw = [SCUnderLineTextField new];
    repassw.width = SCREEN_WIDTH - marginX*2;
    repassw.height = TFHeight;
    repassw.centerX = SCREEN_WIDTH/2;
    repassw.top = passw.bottom ;
    repassw.backgroundColor = [UIColor clearColor];
    repassw.delegate = self;
    repassw.tag = 257;
    repassw.secureTextEntry = YES;
    repassw.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:LocalizedString(@"重复输入密码") attributes:@{NSForegroundColorAttributeName : pcolor,NSFontAttributeName:pfont}];
    [self.view addSubview:repassw];
    _repassw = repassw;
    
    SCUnderLineTextField *passwtip = [SCUnderLineTextField new];
    passwtip.width = SCREEN_WIDTH - marginX*2;
    passwtip.height = TFHeight;
    passwtip.centerX = SCREEN_WIDTH/2;
    passwtip.top = repassw.bottom ;
    passwtip.backgroundColor = [UIColor clearColor];
    passwtip.delegate = self;
    passwtip.tag = 258;
    passwtip.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:LocalizedString(@"密码提示信息") attributes:@{NSForegroundColorAttributeName : pcolor,NSFontAttributeName:pfont}];
    [self.view addSubview:passwtip];
    _passwtip = passwtip;
    
    UILabel *tiplab = [UILabel new];
    tiplab.size = CGSizeMake(SCREEN_WIDTH, 18);
    tiplab.right = SCREEN_WIDTH - marginX;
    tiplab.top = passw.bottom-3;
    tiplab.textAlignment = NSTextAlignmentRight;
    tiplab.font = kFont(12);
    tiplab.textColor = SCColor(83, 144, 247);
    tiplab.alpha = 0;
    tiplab.text = LocalizedString(@"不少于8位字符，建议混合大小字母、数字、符号");
    [self.view addSubview:tiplab];
    _tiplab = tiplab;
    
    SCCreateIDTipView *tipv = [[SCCreateIDTipView alloc]init];
    tipv.alpha = 0;
    _idTipView = tipv;
    tipv.bottom = passw.top;
    tipv.centerX = SCREEN_WIDTH/2;
    [self.view addSubview:tipv];

    SCCommonBtn *btn = [SCCommonBtn createCommonBtnText:LocalizedString(@"创建")];
    btn.bottom = self.view.bottom-NAVIBAR_HEIGHT;
    [self.view addSubview:btn];
    [btn setTapActionWithBlock:^{
        [self createAccount];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSInteger tag = textField.tag;
    if (tag == 256) {
        [self showPassWordTips:YES];
        [self showEyesToView:textField];
    }
    else
    {
        [self showPassWordTips:NO];
    }
    if (tag == 257) {
        [self showEyesToView:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField.tag==256||textField.tag==257)
        textField.secureTextEntry = YES;
    return YES;
}

static BOOL isChange = NO;
- (void)showPassWordTips:(BOOL)show
{
    if (show&&!isChange) {
        _idTipView.bottom = _idTipView.bottom-13;
        [UIView animateWithDuration:0.2 animations:^{
            self.repassw.y = self.repassw.y+10;
            self.passwtip.y = self.passwtip.y+10;
            self.tiplab.alpha = 1;
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.idTipView.alpha = 1;
            self.idTipView.bottom = self.idTipView.bottom+13;
        }];
        isChange = YES;
    }
    else if(isChange){
        if (show) {
            return;
        }
        //复原
//        [UIView animateWithDuration:0.2 animations:^{
//            self.repassw.y = self.repassw.y-10;
//            self.passwtip.y = self.passwtip.y-10;
//            self.tiplab.alpha = 0;
//        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.idTipView.alpha = 0;
            self.idTipView.bottom = self.idTipView.bottom-13;
        } completion:^(BOOL finished) {
            self.idTipView.bottom = self.idTipView.bottom+13;
        }];
//        isChange = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self showPassWordTips:NO];
}

#pragma mark - 是否显示密码
- (void)showEyesToView:(UITextField *)textField
{
 
    [self.view addSubview:self.eyesView];
    self.eyesImg.image = IMAGENAME(@"密码-不显示");
    self.eyesView.right = textField.right;
    self.eyesView.centerY = textField.centerY;
    __block BOOL show = NO;
    WeakSelf(weakSelf);
    [self.eyesView setTapActionWithBlock:^{
        show = !show;
        if (show) {
            weakSelf.eyesImg.image = IMAGENAME(@"密码-显示");
            textField.secureTextEntry = NO;
        }else{
            weakSelf.eyesImg.image = IMAGENAME(@"密码-不显示");
            textField.secureTextEntry = YES;
        }
    }];
}

-(void)dealloc
{
    isChange = nil;
}

#pragma mark - 创建
- (void)createAccount
{
    //数据库加入钱包
    walletModel *wallet = [[walletModel alloc]init];
    wallet.name = self.unlt.text;
    wallet.password= self.passw.text;
    wallet.tips=self.passwtip.text;
    wallet.isHide=@"0";
  
    SCBackupController *sc = [SCBackupController new];
    sc.wallet = wallet;
    [self.navigationController pushViewController:sc animated:YES];
}

@end
