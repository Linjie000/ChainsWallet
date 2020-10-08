//
//  EOSBandWidthScrollView.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/28.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSBandWidthScrollView.h"
#import "NSString+ValidateFormat.h"

#define marginX 15

@interface EOSBandWidthScrollView()
@property(strong, nonatomic) UIView *freezeView;
@property(strong, nonatomic) UIView *redeemView;
@property(strong, nonatomic) UITextField *freezeTf;
@property(strong, nonatomic) UITextField *cpufreezeTf;
@property(strong, nonatomic) UIButton *confirm;

@property(strong, nonatomic) UITextField *rfreezeTf;
@property(strong, nonatomic) UITextField *rcpufreezeTf;
@property(strong, nonatomic) UIButton *rconfirm;
@property(strong, nonatomic) UILabel *usednetResourceLab;
@property(strong, nonatomic) UILabel *usedcpuResourceLab;
@end

@implementation EOSBandWidthScrollView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = 320;
        
        [self setupview];
    }
    return self;
}

- (void)setType:(NSInteger)type
{
    _type = type;
}

- (void)setEosAccount:(EOSAccount *)eosAccount
{
    _eosAccount = eosAccount;
    _usednetResourceLab.text = [NSString stringWithFormat:LocalizedString(@"可用 %.4f EOS"),[self.eosAccount.net_weight floatValue]/kEOSDense];
    _usedcpuResourceLab.text = [NSString stringWithFormat:LocalizedString(@"可用 %.4f EOS"),[self.eosAccount.cpu_weight floatValue]/kEOSDense];
    _usedResourceLab.text = [NSString stringWithFormat:LocalizedString(@"可用余额 %@ "),self.eosAccount.core_liquid_balance];
}

- (void)setupview
{
    self.freezeScrollView = [UIScrollView new];
    self.freezeScrollView.size = CGSizeMake(SCREEN_WIDTH, self.height);
    self.freezeScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, self.height);
    self.freezeScrollView.showsVerticalScrollIndicator = NO;
    self.freezeScrollView.showsHorizontalScrollIndicator = NO;
    self.freezeScrollView.scrollEnabled = NO;
    [self addSubview:self.freezeScrollView];
    
    [self.freezeScrollView addSubview:self.freezeView];
    [self.freezeScrollView addSubview:self.redeemView];
}

- (UIView *)freezeView
{
    if (!_freezeView) {
        _freezeView = [UIView new];
        _freezeView.size = CGSizeMake(SCREEN_WIDTH, self.height);
        
        UILabel *diyalab = [UILabel new];
        diyalab.width = SCREEN_WIDTH;
        diyalab.height = 20;
        diyalab.text = LocalizedString(@"网络抵押");
        diyalab.x = marginX;
        diyalab.font = kFont(13);
        diyalab.y = 25;
        [_freezeView addSubview:diyalab];
        
        UIView *bor1 = [UIView new];
        bor1.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 45);
        bor1.layer.borderColor = SCGray(245).CGColor;
        bor1.layer.borderWidth = 1;
        bor1.x = marginX;
        bor1.y = diyalab.bottom;
        [_freezeView addSubview:bor1];
        
        UITextField *tf = [UITextField new];
        tf.size = CGSizeMake(bor1.width-50, bor1.height);
        tf.x = 12;
        tf.placeholder = LocalizedString(@"请输入抵押数量"); 
        tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"请输入抵押数量") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor redColor]}];
        tf.tintColor = MainColor;
        tf.font = kFont(14);
        tf.keyboardType = UIKeyboardTypeNumberPad;
        [bor1 addSubview:tf];
        _freezeTf = tf;
        
        UILabel *tiplab = [UILabel new];
        tiplab.width = 38;
        tiplab.height = bor1.height;
        tiplab.textColor = SCGray(40);
        tiplab.text = @"EOS";
        tiplab.right = bor1.width;
        tiplab.textAlignment = NSTextAlignmentCenter;
        tiplab.y = 0;
        tiplab.font = kPFFont(14.5);
        [bor1 addSubview:tiplab];
        _coinNameLab = tiplab;
        
        UILabel *cpudiyalab = [UILabel new];
        cpudiyalab.width = SCREEN_WIDTH;
        cpudiyalab.height = 20;
        cpudiyalab.text = LocalizedString(@"CPU 抵押");
        cpudiyalab.x = marginX;
        cpudiyalab.font = kFont(13);
        cpudiyalab.y = bor1.bottom + 25;
        [_freezeView addSubview:cpudiyalab];
 
        UIView *bor2 = [UIView new];
        bor2.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 45);
        bor2.layer.borderColor = SCGray(245).CGColor;
        bor2.layer.borderWidth = 1;
        bor2.x = marginX;
        bor2.y = cpudiyalab.bottom;
        [_freezeView addSubview:bor2];
        
        UITextField *cputf = [UITextField new];
        cputf.size = CGSizeMake(bor1.width-50, bor1.height);
        cputf.x = 12;
        cputf.placeholder = LocalizedString(@"请输入抵押数量");
        cputf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"请输入抵押数量") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
        cputf.tintColor = MainColor;
        cputf.font = kFont(14);
        cputf.keyboardType = UIKeyboardTypeNumberPad;
        [bor2 addSubview:cputf];
        _cpufreezeTf = cputf;
        
        UILabel *usable = [UILabel new];
        usable.width = SCREEN_WIDTH;
        usable.height = 28;
        usable.textColor = SCGray(128);
        usable.text = LocalizedString(@"可用 0.0000 EOS") ;
        usable.right = bor1.right;
        usable.y = bor2.bottom;
        usable.font = kPFFont(13.5);
        usable.textAlignment = NSTextAlignmentRight;
        _usedResourceLab = usable;
        
        [_freezeView addSubview:usable];
        
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm setTitle:LocalizedString(@"抵押") forState:UIControlStateNormal];
        [confirm setTitle:LocalizedString(@"抵押") forState:UIControlStateHighlighted];
        confirm.titleLabel.font = kPFFont(14);
        confirm.size = CGSizeMake(150, 45);
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        confirm.backgroundColor = MainColor;
        [confirm setBackgroundImage:[UIImage imageWithColor:DE_MainColor] forState:UIControlStateHighlighted];
        [confirm setTintColor:[UIColor whiteColor]];
        confirm.centerX = SCREEN_WIDTH/2;
        confirm.top = _usedResourceLab.bottom+30;
        [confirm setAdjustsImageWhenHighlighted:NO];
        confirm.layer.cornerRadius = 4;
        confirm.clipsToBounds = YES;
        [confirm addTarget:self action:@selector(confirmFreeze) forControlEvents:UIControlEventTouchUpInside];
        _confirm = confirm;
        [_freezeView addSubview:confirm];
        
    }
    return _freezeView;
}

- (UIView *)redeemView
{
    if (!_redeemView) {
        _redeemView = [UIView new];
        _redeemView.size = CGSizeMake(SCREEN_WIDTH, self.height);
        _redeemView.x = SCREEN_WIDTH;
        UILabel *diyalab = [UILabel new];
        diyalab.width = SCREEN_WIDTH;
        diyalab.height = 20;
        diyalab.text = LocalizedString(@"网络赎回");
        diyalab.x = marginX;
        diyalab.font = kFont(13);
        diyalab.y = 25;
        [_redeemView addSubview:diyalab];
        
        UIView *bor1 = [UIView new];
        bor1.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 45);
        bor1.layer.borderColor = SCGray(245).CGColor;
        bor1.layer.borderWidth = 1;
        bor1.x = marginX;
        bor1.y = diyalab.bottom;
        [_redeemView addSubview:bor1];
        
        UITextField *tf = [UITextField new];
        tf.size = CGSizeMake(bor1.width-50, bor1.height);
        tf.x = 12;
        tf.placeholder = LocalizedString(@"请输入赎回数量");
        tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"请输入赎回数量") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
        tf.tintColor = MainColor;
        tf.font = kFont(14);
        tf.keyboardType = UIKeyboardTypeNumberPad;
        [bor1 addSubview:tf];
        _rfreezeTf = tf;
        
        UILabel *usacpuble = [UILabel new];
        usacpuble.width = SCREEN_WIDTH;
        usacpuble.height = 28;
        usacpuble.textColor = SCGray(128);
        usacpuble.text = @"可用 0.0000 EOS";
        usacpuble.right = bor1.right;
        usacpuble.y = bor1.bottom;
        usacpuble.font = kPFFont(13.5);
        usacpuble.textAlignment = NSTextAlignmentRight;
        _usednetResourceLab = usacpuble;
        [_redeemView addSubview:usacpuble];
        
        UILabel *tiplab = [UILabel new];
        tiplab.width = 38;
        tiplab.height = bor1.height;
        tiplab.textColor = SCGray(40);
        tiplab.text = @"EOS";
        tiplab.right = bor1.width;
        tiplab.textAlignment = NSTextAlignmentCenter;
        tiplab.y = 0;
        tiplab.font = kPFFont(14.5);
        [bor1 addSubview:tiplab];
        _coinNameLab = tiplab;
        
        UILabel *cpudiyalab = [UILabel new];
        cpudiyalab.width = SCREEN_WIDTH;
        cpudiyalab.height = 20;
        cpudiyalab.text = LocalizedString(@"CPU 赎回");
        cpudiyalab.x = marginX;
        cpudiyalab.font = kFont(13);
        cpudiyalab.y = bor1.bottom + 25;
        [_redeemView addSubview:cpudiyalab];
        
        UIView *bor2 = [UIView new];
        bor2.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 45);
        bor2.layer.borderColor = SCGray(245).CGColor;
        bor2.layer.borderWidth = 1;
        bor2.x = marginX;
        bor2.y = cpudiyalab.bottom;
        [_redeemView addSubview:bor2];
        
        UITextField *cputf = [UITextField new];
        cputf.size = CGSizeMake(bor1.width-50, bor1.height);
        cputf.x = 12;
        cputf.placeholder = LocalizedString(@"请输入赎回数量");
        cputf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"请输入赎回数量") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
        cputf.tintColor = MainColor;
        cputf.font = kFont(14);
        cputf.keyboardType = UIKeyboardTypeNumberPad;
        [bor2 addSubview:cputf];
        _rcpufreezeTf = cputf;
        
        UILabel *usable = [UILabel new];
        usable.width = SCREEN_WIDTH;
        usable.height = 28;
        usable.textColor = SCGray(128);
        usable.text = @"可用 0.0000 EOS";
        usable.right = bor1.right;
        usable.y = bor2.bottom;
        usable.font = kPFFont(13.5);
        usable.textAlignment = NSTextAlignmentRight;
        _usedcpuResourceLab = usable;
        [_redeemView addSubview:usable];
        
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm setTitle:LocalizedString(@"赎回") forState:UIControlStateNormal];
        [confirm setTitle:LocalizedString(@"赎回") forState:UIControlStateHighlighted];
        confirm.titleLabel.font = kPFFont(14);
        confirm.size = CGSizeMake(150, 45);
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        confirm.backgroundColor = MainColor;
        [confirm setBackgroundImage:[UIImage imageWithColor:DE_MainColor] forState:UIControlStateHighlighted];
        [confirm setTintColor:[UIColor whiteColor]];
        confirm.centerX = SCREEN_WIDTH/2;
        confirm.top = _usedResourceLab.bottom+30;
        [confirm setAdjustsImageWhenHighlighted:NO];
        confirm.layer.cornerRadius = 4;
        confirm.clipsToBounds = YES;
        [confirm addTarget:self action:@selector(confirmFreeze) forControlEvents:UIControlEventTouchUpInside];
        _rconfirm = confirm;
        [_redeemView addSubview:confirm];
    }
    return _redeemView;
}

- (void)selectResource:(UIButton *)btn
{
    if (btn.tag==99) {
        UIButton *otherbtn = (UIButton *)[self viewWithTag:100];
        otherbtn.selected = NO;
        self.type = 0;
    }
    else
    {
        UIButton *otherbtn = (UIButton *)[self viewWithTag:99];
        otherbtn.selected = NO;
        self.type = 1;
    }
    btn.selected = YES;
}

//冻结
- (void)confirmFreeze
{
    NSString *net = @"0";
    NSString *cpu = @"0";
    if (!self.type) {
        net = _freezeTf.text;
        cpu = _cpufreezeTf.text;
    }else{
        net = _rfreezeTf.text;
        cpu = _rcpufreezeTf.text;
    }
    if (![net floatValue]&&![cpu floatValue]) {
        [TKCommonTools showToast:LocalizedString(@"请输入数量")];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(EOSBandWidthScrollViewNet:Cpu:freezeType:)]) {
        [self.delegate EOSBandWidthScrollViewNet:[net floatValue] Cpu:[cpu floatValue] freezeType:self.type];
    }
}

@end

