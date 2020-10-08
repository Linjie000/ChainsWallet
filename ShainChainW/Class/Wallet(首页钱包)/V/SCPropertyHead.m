//
//  SCPropertyHead.m
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/28.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import "SCPropertyHead.h"
#import "SCWalletView.h"
#import "SCWalletOperationView.h"
#import "SCTransferController.h"
#import "WalletNavViewController.h"
#import "EOSResourceController.h"
#import "TRXResourceController.h"
#import "IOSTResourceController.h"

#define HeadHeight 50
@interface SCPropertyHead()<SCWalletOperationViewDelegate>
@property (strong, nonatomic) SCWalletOperationView *opView;

@property (strong, nonatomic) NSNumber *ID;
@end

@implementation SCPropertyHead

+ (instancetype)shareInstance
{
    static SCPropertyHead *head;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        head = [SCPropertyHead new];
    });
    return head;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        [self subViews];
    }
    return self;
}

- (void)subViews{
    [self addSubview:self.walletView];
    [self addSubview:self.headView];

    self.height = self.opView.bottom+10;
}

- (void)setWallet:(walletModel *)wallet
{
    _wallet = wallet;
    self.ID = wallet.ID;
    self.walletView.wallet = wallet;
    if (self.wallet.resourceOP) {
        [self addSubview:self.opView];
        self.opView.hidden = NO;
    }else
    {
        self.opView.hidden = YES;
    }
}

- (UIView *)headView
{
    if (!_headView) {
        _headView = [UIView new];
        _headView.height = HeadHeight;
        _headView.width = SCREEN_WIDTH;
        _headView.backgroundColor = [UIColor whiteColor];
        _headView.x = 0;
        _headView.top = self.walletView.bottom+6;
        UILabel *lab = [UILabel new];
        lab.text = LocalizedString(@"资产");
        lab.font = kFont(18);
        lab.textColor = SCGray(40);
        lab.left = 15;
        [lab sizeToFit];
        lab.centerY = HeadHeight/2;
        [_headView addSubview:lab];
        
//        [_headView addSubview:self.addProperty];
//        WeakSelf(weakSelf);
//        self.addProperty.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
//            if (state==YYGestureRecognizerStateEnded) {
//                [weakSelf postNotificationForName:KEY_SCWALLET_ADDASSET userInfo:nil];
//            }
//        };
//        self.addProperty.centerY = HeadHeight/2;
//        self.addProperty.right = SCREEN_WIDTH - 17;
    }
    return _headView;
}

- (YYControl *)addProperty
{
    if (!_addProperty) {
        _addProperty = [YYControl new];
        _addProperty.size = CGSizeMake(25, 25);
        _addProperty.image = IMAGENAME(@"首页添加+");
    }
    return _addProperty;
}

- (SCWalletView *)walletView
{
    if (!_walletView) {
        _walletView = [[SCWalletView alloc]init];
        _walletView.width = SCREEN_WIDTH - 30;
        _walletView.height = 130;
        _walletView.centerX = SCREEN_WIDTH/2;
        _walletView.top = 15;
        [_walletView layout];
    }
    return _walletView;
}

- (SCWalletOperationView *)opView
{
    if (!_opView) {
        _opView = [[SCWalletOperationView alloc]init];
        _opView.centerX = SCREEN_WIDTH/2;
        _opView.top = self.walletView.bottom+12;
        _opView.delegate = self;
    }
    return _opView;
}

#pragma mark - SCWalletOperationViewDelegate
- (void)SCWalletOperationViewDelegateSelect:(NSInteger)tag
{
    if (!tag) {
#pragma mark --- 暂不了解代币概念 self.ID
        NSString *brand ;
        if ([self.ID isEqualToNumber:@(195)])brand = @"TRX";
        if ([self.ID isEqualToNumber:@(194)])brand = @"EOS";
        if ([self.ID isEqualToNumber:@(291)])brand = @"IOST";
        SCTransferController *sc = [SCTransferController new];
        sc.brand = brand;
        WalletNavViewController *wn = [[WalletNavViewController alloc]initWithRootViewController:sc];
        [[RewardHelper viewControllerWithView:self] presentViewController:wn animated:YES completion:nil];
    }
    else{
        if ([self.ID isEqualToNumber:@(195)])
        {
            TRXResourceController *rc = [[TRXResourceController alloc]init];
            [[RewardHelper viewControllerWithView:self].navigationController pushViewController:rc animated:YES];
        }
        if ([self.ID isEqualToNumber:@(194)])
        {
            EOSResourceController *rc = [[EOSResourceController alloc]init];
            [[RewardHelper viewControllerWithView:self].navigationController pushViewController:rc animated:YES];
        }
        if ([self.ID isEqualToNumber:@(291)])
        {
            IOSTResourceController *rc = [[IOSTResourceController alloc]init];
            [[RewardHelper viewControllerWithView:self].navigationController pushViewController:rc animated:YES];
        }
    }
}


@end
