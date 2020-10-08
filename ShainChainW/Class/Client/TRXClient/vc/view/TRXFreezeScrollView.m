//
//  TRXFreezeScrollView.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/6.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "TRXFreezeScrollView.h"
#import "NSString+ValidateFormat.h"

#define marginX 15

@interface TRXFreezeScrollView()
@property(strong, nonatomic) UIView *freezeView;
@property(strong, nonatomic) UIView *unFreezeView;
@property(strong, nonatomic) UITextField *freezeTf;

@property(assign, nonatomic) NSInteger type;
@property(assign, nonatomic) NSInteger untype;
@end

@implementation TRXFreezeScrollView

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
    self.freezeScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, self.height);
    self.freezeScrollView.showsVerticalScrollIndicator = NO;
    self.freezeScrollView.showsHorizontalScrollIndicator = NO;
    self.freezeScrollView.scrollEnabled = NO;
    [self addSubview:self.freezeScrollView];
    
    [self.freezeScrollView addSubview:self.freezeView];
    [self.freezeScrollView addSubview:self.unFreezeView];
    self.unFreezeView.x = SCREEN_WIDTH;
    
}

- (UIView *)freezeView
{
    if (!_freezeView) {
        _freezeView = [UIView new];
        _freezeView.size = CGSizeMake(SCREEN_WIDTH, self.height);
        
        UIView *bor1 = [UIView new];
        bor1.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 45);
        bor1.layer.borderColor = SCGray(245).CGColor;
        bor1.layer.borderWidth = 1;
        bor1.x = marginX;
        bor1.y = 25;
        [_freezeView addSubview:bor1];
        
        UITextField *tf = [UITextField new];
        tf.size = CGSizeMake(bor1.width-50, bor1.height);
        tf.x = 12;
        tf.placeholder = LocalizedString(@"请输入冻结资源数量");
        tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"请输入冻结资源数量") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
        tf.tintColor = MainColor;
        tf.font = kFont(14);
        tf.keyboardType = UIKeyboardTypeNumberPad;
        [bor1 addSubview:tf];
        _freezeTf = tf;
        
        UILabel *tiplab = [UILabel new];
        tiplab.width = 38;
        tiplab.height = bor1.height;
        tiplab.textColor = SCGray(40);
        tiplab.text = @"TRX";
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
        usable.text = @"可用余额 0.00 TRX";
        usable.right = bor1.right;
        usable.y = bor1.bottom;
        usable.font = kPFFont(13.5);
        usable.textAlignment = NSTextAlignmentRight;
        _usedResourceLab = usable;
        [_freezeView addSubview:usable];
        
        UIView *bor2 = [UIView new];
        bor2.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 45);
        bor2.layer.borderColor = SCGray(245).CGColor;
        bor2.layer.borderWidth = 1;
        bor2.x = marginX;
        bor2.y = usable.bottom+20;
        [_freezeView addSubview:bor2];
        
        NSArray *textarr = @[@"宽带",@"能量"];
        for (int i =0; i<textarr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(11+(93)*i, 0, 100, bor2.height);
            button.centerY = bor2.height/2;
            button.backgroundColor = [UIColor clearColor];
            //设置button正常状态下的图片
            [button setImage:[UIImage imageNamed:@"使用条款-未选中"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"使用条款-选中"] forState:UIControlStateSelected];
            //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
            button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 60);
            [button setTitle:textarr[i] forState:UIControlStateNormal];
            //button标题的偏移量，这个偏移量是相对于图片的
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
            //设置button正常状态下的标题颜色
            [button setTitleColor:SCGray(128) forState:UIControlStateNormal];
            button.tag = i+99;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [bor2 addSubview:button];
            [button addTarget:self action:@selector(selectResource:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                button.selected = YES;
            }
        }
        
        UILabel *tiptext = [UILabel new];
        tiptext.width = SCREEN_WIDTH;
        tiptext.height = 28;
        tiptext.textColor = SCGray(128);
        tiptext.text = @"冻结时间至少3天";
        tiptext.right = bor2.right;
        tiptext.y = bor2.bottom;
        tiptext.font = kPFFont(13.5);
        tiptext.textAlignment = NSTextAlignmentRight;
        [_freezeView addSubview:tiptext];
        
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm setTitle:LocalizedString(@"冻结") forState:UIControlStateNormal];
        [confirm setTitle:LocalizedString(@"冻结") forState:UIControlStateHighlighted];
        confirm.titleLabel.font = kPFFont(14);
        confirm.size = CGSizeMake(150, 45);
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        confirm.backgroundColor = MainColor;
        [confirm setBackgroundImage:[UIImage imageWithColor:DE_MainColor] forState:UIControlStateHighlighted];
        [confirm setTintColor:[UIColor whiteColor]];
        confirm.centerX = SCREEN_WIDTH/2;
        confirm.top = tiptext.bottom+50;
        [confirm setAdjustsImageWhenHighlighted:NO];
        confirm.layer.cornerRadius = 4;
        confirm.clipsToBounds = YES;
        [confirm addTarget:self action:@selector(confirmFreeze) forControlEvents:UIControlEventTouchUpInside];
        [_freezeView addSubview:confirm];

    }
    return _freezeView;
}

- (UIView *)unFreezeView
{
    if (!_unFreezeView) {
        _unFreezeView = [UIView new];
        _unFreezeView.size = CGSizeMake(SCREEN_WIDTH, self.height);
        
        UIView *bor2 = [UIView new];
        bor2.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 45);
        bor2.layer.borderColor = SCGray(245).CGColor;
        bor2.layer.borderWidth = 1;
        bor2.x = marginX;
        bor2.y = 25;
        [_unFreezeView addSubview:bor2];
        
        NSArray *textarr = @[@"宽带",@"能量"];
        for (int i =0; i<textarr.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(11+(93)*i, 0, 100, bor2.height);
            button.centerY = bor2.height/2;
            button.backgroundColor = [UIColor clearColor];
            //设置button正常状态下的图片
            [button setImage:[UIImage imageNamed:@"使用条款-未选中"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"使用条款-选中"] forState:UIControlStateSelected];
            //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
            button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 60);
            [button setTitle:textarr[i] forState:UIControlStateNormal];
            //button标题的偏移量，这个偏移量是相对于图片的
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
            //设置button正常状态下的标题颜色
            [button setTitleColor:SCGray(128) forState:UIControlStateNormal];
            button.tag = i+111;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [bor2 addSubview:button];
            [button addTarget:self action:@selector(selectResource2:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                button.selected = YES;
            }
        }
        
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirm setTitle:LocalizedString(@"解冻") forState:UIControlStateNormal];
        [confirm setTitle:LocalizedString(@"解冻") forState:UIControlStateHighlighted];
        confirm.titleLabel.font = kPFFont(14);
        confirm.size = CGSizeMake(150, 45);
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        confirm.backgroundColor = MainColor;
        [confirm setBackgroundImage:[UIImage imageWithColor:DE_MainColor] forState:UIControlStateHighlighted];
        [confirm setTintColor:[UIColor whiteColor]];
        confirm.centerX = SCREEN_WIDTH/2;
        confirm.top = bor2.bottom+50;
        [confirm setAdjustsImageWhenHighlighted:NO];
        confirm.layer.cornerRadius = 4;
        confirm.clipsToBounds = YES;
        [confirm addTarget:self action:@selector(confirmUnFreeze) forControlEvents:UIControlEventTouchUpInside];
        [_unFreezeView addSubview:confirm];
    }
    return _unFreezeView;
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

- (void)selectResource2:(UIButton *)btn
{
    if (btn.tag==111) {
        UIButton *otherbtn = (UIButton *)[self viewWithTag:112];
        otherbtn.selected = NO;
        self.untype = 0;
    }
    else
    {
        UIButton *otherbtn = (UIButton *)[self viewWithTag:111];
        otherbtn.selected = NO;
        self.untype = 1;
    }
    btn.selected = YES;
}

//冻结
- (void)confirmFreeze
{
    if (![_freezeTf.text isPositivePureInt:_freezeTf.text]) {
        [TKCommonTools showToast:@"冻结资源数量必须为整数"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(TRXFreezeScrollViewFreeze:freezeType:)]) {
        [self.delegate TRXFreezeScrollViewFreeze:[_freezeTf.text integerValue] freezeType:self.type];
    }
}

//解冻
- (void)confirmUnFreeze
{
    if ([self.delegate respondsToSelector:@selector(TRXFreezeScrollViewUnFreezeType:)]) {
        [self.delegate TRXFreezeScrollViewUnFreezeType:self.untype];
    }
}

@end
