//
//  SCChooseWalletView.m
//  ShainChainW
//
//  Created by 闪链 on 2019/6/6.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCChooseWalletView.h"
#import "SCChooseWalletTableView.h"

@interface SCChooseWalletView ()
<SCChooseWalletTableViewDelegagte>
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) SCChooseWalletTableView *walletTableView;
@end

@implementation SCChooseWalletView

+ (instancetype)shareInstance
{
    SCChooseWalletView *enterv = [[SCChooseWalletView alloc]init];
    [KeyWindow addSubview:enterv];
    return enterv;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = SCREEN_HEIGHT;
        [self subViews];
        [KeyWindow addSubview:self];
    }
    return self;
}


- (void)getData
{
    NSArray *walletArr= [walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"ID"],[NSObject bg_sqlValue:@(194)]]];
    _walletTableView.dataArray = walletArr;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self getData];
    [UIView animateWithDuration:0.20 animations:^{
        _walletTableView.bottom = SCREEN_HEIGHT;
        _bgView.alpha = 0.4;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.1 animations:^{
        _walletTableView.top = SCREEN_HEIGHT;
        _bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)subViews
{
    WeakSelf(weakSelf);
    _bgView = [UIView new];
    _bgView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    _bgView.x = _bgView.y = 0;
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.0;
    [self addSubview:_bgView];
    [_bgView setTapActionWithBlock:^{
        [weakSelf hide];
    }];
    
    _walletTableView = [SCChooseWalletTableView new];
    _walletTableView.x = 0;
    _walletTableView.top = SCREEN_HEIGHT;
    _walletTableView.delegate = self;
    [self addSubview:_walletTableView];
    
}

- (void)SCChooseWalletTableViewSelectWallet:(walletModel *)walletModel
{
    if (_delegate&&[_delegate respondsToSelector:@selector(SCChooseWalletViewSelectWallet:)]) {
        [self.delegate SCChooseWalletViewSelectWallet:walletModel];
        [self hide];
    }
}

@end
