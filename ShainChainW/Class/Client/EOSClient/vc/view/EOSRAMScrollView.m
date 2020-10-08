//
//  EOSRAMScrollView.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/28.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRAMScrollView.h"
#import "NSString+ValidateFormat.h"

#define marginX 15

@interface EOSRAMScrollView()

@end

@implementation EOSRAMScrollView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = 300;
        
        [self setupview];
    }
    return self;
}

- (void)setupview
{
    self.freezeScrollView = [UIScrollView new];
    self.freezeScrollView.size = CGSizeMake(SCREEN_WIDTH, self.height);
    self.freezeScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.height);
    self.freezeScrollView.showsVerticalScrollIndicator = NO;
    self.freezeScrollView.showsHorizontalScrollIndicator = NO;
    self.freezeScrollView.scrollEnabled = NO;
    [self addSubview:self.freezeScrollView];
    
    [self.freezeScrollView addSubview:self.freezeView];
}

- (void)setType:(NSInteger)type
{
    _type = type;
    if (!_type) {
        _freezeTf.placeholder = LocalizedString(@"请输入买入数量");
        [_confirm setTitle:LocalizedString(@"购买") forState:UIControlStateNormal];
        _coinNameLab.text = @"EOS";
    }else{
        _freezeTf.placeholder = LocalizedString(@"请输入卖出数量");
        [_confirm setTitle:LocalizedString(@"卖出") forState:UIControlStateNormal];
        _coinNameLab.text = @"KB";
    }
}

- (UIView *)freezeView
{
    if (!_freezeView) {
        _freezeView = [UIView new];
        _freezeView.size = CGSizeMake(SCREEN_WIDTH, self.height);
        
        UILabel *pricelab = [UILabel new];
        pricelab.width = SCREEN_WIDTH;
        pricelab.height = 20;
        pricelab.textColor = SCGray(20);
        pricelab.x = marginX;
        pricelab.y = 26;
        pricelab.font = kPFFont(12);
        [_freezeView addSubview:pricelab];
        _priceLab = pricelab;
        _priceLab.text = @"RAM 价格 ";
        
        UIView *bor1 = [UIView new];
        bor1.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 45);
        bor1.layer.borderColor = SCGray(245).CGColor;
        bor1.layer.borderWidth = 1;
        bor1.x = marginX;
        bor1.y = pricelab.bottom+4;
        [_freezeView addSubview:bor1];
        
        UITextField *tf = [UITextField new];
        tf.size = CGSizeMake(bor1.width-50, bor1.height);
        tf.x = 12;
        tf.placeholder = LocalizedString(@"请输入买入数量"); 
        tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"请输入买入数量") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
        tf.tintColor = MainColor;
        tf.font = kFont(14);
        tf.keyboardType = UIKeyboardTypeDecimalPad;
        [bor1 addSubview:tf];
        _freezeTf = tf;
        
        UILabel *tiplab = [UILabel new];
        tiplab.width = 38;
        tiplab.height = bor1.height;
        tiplab.textColor = SCGray(20);
        tiplab.text = @"EOS";
        tiplab.right = bor1.width;
        tiplab.textAlignment = NSTextAlignmentCenter;
        tiplab.y = 0;
        tiplab.font = kPFFont(14.5);
        [bor1 addSubview:tiplab];
        _coinNameLab = tiplab;
        
        UILabel *usable = [UILabel new];
        usable.width = SCREEN_WIDTH;
        usable.height = 28;
        usable.textColor = SCGray(128);
        usable.text = @"可用余额 0.00 EOS";
        usable.right = bor1.right;
        usable.y = bor1.bottom;
        usable.font = kPFFont(13.5);
        usable.textAlignment = NSTextAlignmentRight;
        _usedResourceLab = usable;
        [_freezeView addSubview:usable];
 
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm setTitle:LocalizedString(@"购买") forState:UIControlStateNormal];
        [confirm setTitle:LocalizedString(@"购买") forState:UIControlStateHighlighted];
        confirm.titleLabel.font = kPFFont(14);
        confirm.size = CGSizeMake(150, 45);
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        confirm.backgroundColor = MainColor;
        [confirm setBackgroundImage:[UIImage imageWithColor:DE_MainColor] forState:UIControlStateHighlighted];
        [confirm setTintColor:[UIColor whiteColor]];
        confirm.centerX = SCREEN_WIDTH/2;
        confirm.top = _usedResourceLab.bottom+50;
        [confirm setAdjustsImageWhenHighlighted:NO];
        confirm.layer.cornerRadius = 4;
        confirm.clipsToBounds = YES;
        [confirm addTarget:self action:@selector(confirmFreeze) forControlEvents:UIControlEventTouchUpInside];
        _confirm = confirm;
        [_freezeView addSubview:confirm];
        
    }
    return _freezeView;
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

- (void)confirmFreeze
{
    if ([RewardHelper isBlankString:_freezeTf.text]) {
        [TKCommonTools showToast:LocalizedString(@"请输入数量")];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(EOSRAMScrollViewFreeze:freezeType:)]) {
        [self.delegate EOSRAMScrollViewFreeze:[_freezeTf.text floatValue] freezeType:self.type];
    }
}
 
@end
