//
//  TRXResourceController.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/6.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "TRXResourceController.h"
#import "ProgressView.h"
#import "YUSegment.h"
#import "TRXFreezeScrollView.h"
#import "SCWalletEnterView.h"
#import "SCRootTool.h"
#import "TRXClient.h"

@interface TRXResourceController ()
<TRXFreezeScrollViewDelegaet>
@property(strong, nonatomic) ProgressView *freezeBPView;
@property(strong, nonatomic) ProgressView *freezeENView;

@property(strong, nonatomic) UILabel *freezeBPLab;
@property(strong, nonatomic) UILabel *freezeENLab;

@property(strong, nonatomic) YUSegment *segment;
@property(strong, nonatomic) TRXFreezeScrollView *freezeScrollView;

@property(strong, nonatomic) UIScrollView *scrollView;
//@property(strong, nonatomic) AccountNetMessage *netMessage;
@property(strong, nonatomic) AccountResourceMessage *resourceMessage;
@property(strong, nonatomic) TWWalletAccountClient *walletClient;

@end

@implementation TRXResourceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SCGray(253);
    self.title = LocalizedString(@"资源");
    [self setupview];
 
    [self getData];
    
    WeakSelf(weakSelf);
    [self addNotificationForName:kAccountUpdateNotification response:^(NSDictionary * _Nonnull userInfo) {
        TronAccount *account = [userInfo objectForKey:@"Account"];
        if (!account) {
            return ;
        }
        [UserinfoModel shareManage].appDelegate.walletClient.account = account;
        
        [weakSelf updateData];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getData];
}

- (void)getData
{
    WeakSelf(weakSelf);
    _walletClient = [[TWWalletAccountClient bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]] lastObject];
    [_walletClient refreshAccount:^(TronAccount *account, NSError *error) {
        
    }];
//    [_walletClient getAccountNetWithRequest:^(AccountNetMessage *netMessage, NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (!netMessage) {
//                return ;
//            }
//            weakSelf.netMessage = netMessage;
//
//            [weakSelf updateData];
//        });
//    }];

    [_walletClient getAccountResourceWithRequest:^(AccountResourceMessage *netMessage, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!netMessage) {
                return ;
            }
            weakSelf.resourceMessage = netMessage;
            
            [weakSelf updateData];
        });
    }];
}

- (void)setupview
{
    
    self.scrollView = [UIScrollView new];
    self.scrollView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.scrollView];
    
    _freezeBPView = [ProgressView new];
    _freezeBPView.centerX = SCREEN_WIDTH/2;
    _freezeBPView.top = 20;
    _freezeBPView.unit = @"BP";
    _freezeBPView.limitCount = 0;
    _freezeBPView.usedCount = 0;
    _freezeBPView.usedColor = SCColor(60, 143, 96);
    _freezeBPView.limitColor = SCColor(84, 171, 122);
    [_freezeBPView layout];
    [self.scrollView addSubview:_freezeBPView];
    
    _freezeBPLab = [UILabel new];
    _freezeBPLab.size = CGSizeMake(SCREEN_WIDTH, 30);
    _freezeBPLab.top = _freezeBPView.bottom+5;
    _freezeBPLab.textAlignment = NSTextAlignmentCenter;
    _freezeBPLab.textColor = SCColor(84, 171, 122);
    _freezeBPLab.font = kFont(14);
    [self.scrollView addSubview:_freezeBPLab];
    
    _freezeENView = [ProgressView new];
    _freezeENView.centerX = SCREEN_WIDTH/2;
    _freezeENView.top = _freezeBPLab.bottom+16;
    _freezeENView.unit = @"Energy";
    _freezeENView.limitCount = 0;
    _freezeENView.usedCount = 0;
    _freezeENView.usedColor = SCColor(66, 142, 150);
    _freezeENView.limitColor = SCColor(84, 163, 171);
    [_freezeENView layout];
    _freezeBPLab.text = @"已冻结宽带 0.0 TRX";
    [self.scrollView addSubview:_freezeENView];
    
    _freezeENLab = [UILabel new];
    _freezeENLab.size = CGSizeMake(SCREEN_WIDTH, 30);
    _freezeENLab.top = _freezeENView.bottom+5;
    _freezeENLab.textAlignment = NSTextAlignmentCenter;
    _freezeENLab.textColor = SCColor(84, 163, 171);
    _freezeENLab.font = kFont(14);
    _freezeENLab.text = @"已冻结能量 0.0 TRX";
    [self.scrollView addSubview:_freezeENLab];
    
    [self.scrollView addSubview:self.segment];
    self.segment.top = _freezeENLab.bottom+16;
    
    self.freezeScrollView = [TRXFreezeScrollView new];
    self.freezeScrollView.x = 0;
    self.freezeScrollView.top = self.segment.bottom;
    self.freezeScrollView.delegate = self;
    [self.scrollView addSubview:self.freezeScrollView];

    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.freezeScrollView.bottom);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)updateData
{
    _freezeBPView.limitCount = self.resourceMessage.freeNetLimit+self.resourceMessage.NetLimit;
    _freezeBPView.usedCount = self.resourceMessage.freeNetUsed;
 
    [_freezeBPView layout];
    
    _freezeENView.limitCount = self.resourceMessage.EnergyLimit;
    _freezeENView.usedCount = self.resourceMessage.energyUsed;
 
    [_freezeENView layout];
    
    
    NSArray *arr = [UserinfoModel shareManage].appDelegate.walletClient.account.frozen;
    if (arr.count) {
        Account_Frozen *accountfrozen = arr[0];
        _freezeBPLab.text = [NSString stringWithFormat:@"已冻结宽带 %.1f TRX",accountfrozen.frozen_balance/kDense];
    }

    _freezeENLab.text = @"已冻结能量 0 TRX";
  
    //冻结获取能量
    if ([UserinfoModel shareManage].appDelegate.walletClient.account.account_resource) {
        AccountResource *account_resource = [UserinfoModel shareManage].appDelegate.walletClient.account.account_resource;
        NSInteger seng = account_resource.frozen_balance_for_energy.frozen_balance;
       _freezeENLab.text = [NSString stringWithFormat:@"已冻结能量 %.1f TRX", seng/kDense];
    }
 
    self.freezeScrollView.usedResourceLab.text = [NSString stringWithFormat:@"可用余额 %.4f TRX",[UserinfoModel shareManage].appDelegate.walletClient.account.balance/kDense];
}

//监听segment的变化
- (void)onSegmentChange {
    [self.freezeScrollView.freezeScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(self.segment.selectedIndex), 0) animated:NO];
}

-(YUSegment *)segment
{
    if (!_segment) {
        _segment = [[YUSegment alloc] initWithTitles:@[LocalizedString(@"冻结"),LocalizedString(@"解冻")]];
        _segment.frame = CGRectMake(0, 0, self.view.frame.size.width, 37);
        _segment.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
        _segment.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00];
        _segment.selectedTextColor = MainColor;
        _segment.indicator.backgroundColor = MainColor;
        _segment.font = kPFFont(14);
        _segment.selectedFont = kPFFont(14);
        [_segment addTarget:self action:@selector(onSegmentChange) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

#pragma mark - TRXFreezeScrollViewDelegaet
- (void)TRXFreezeScrollViewFreeze:(NSInteger)trxCount freezeType:(NSInteger)type
{
    WeakSelf(weakSelf);
    if ([UserinfoModel shareManage].appDelegate.walletClient.account.balance/kDense <= trxCount) {
        [TKCommonTools showToast:@"余额不足"];
        return;
    }
    SCWalletEnterView *se = [SCWalletEnterView shareInstance];
    se.title = LocalizedString(@"请输入密码");
    se.placeholderStr = @"密码";
    se.isOperation = NO;
    [se setReturnTextBlock:^(NSString *showText) {
        [SVProgressHUD show];
        [TRXClient freezeBalance:trxCount freezeType:type success:^(id  _Nonnull responseObject) {
            [SVProgressHUD dismiss];
            if (![responseObject[@"result"] integerValue]) {
                return ;
            }
            [_walletClient refreshAccount:nil];
            [weakSelf getData];
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }];
}

- (void)TRXFreezeScrollViewUnFreezeType:(NSInteger)type
{
    WeakSelf(weakSelf);
    SCWalletEnterView *se = [SCWalletEnterView shareInstance];
    se.title = LocalizedString(@"请输入密码");
    se.placeholderStr = @"密码";
    [se setReturnTextBlock:^(NSString *showText) {
        [SVProgressHUD show];
        [TRXClient unfreezeType:type success:^(id  _Nonnull responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"result"] integerValue]) {
                [_walletClient refreshAccount:nil];
                [weakSelf getData];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"冻结时间少于3天，不可解冻"];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
        }];
    }];
 
}

@end
