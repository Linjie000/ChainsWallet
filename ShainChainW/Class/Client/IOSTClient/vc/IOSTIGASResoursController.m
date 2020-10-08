//
//  IOSTIGASResoursController.m
//  ShainChainW
//
//  Created by 闪链 on 2019/5/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "IOSTIGASResoursController.h"
#import "ProgressView.h"
#import "YUSegment.h"
#import "EOSRAMScrollView.h"
#import "SCWalletEnterView.h"
#import "SCRootTool.h"
#import "BuyRamAbiJsonToBinRequest.h"
#import "TransferService.h"
#import "ContractConstant.h"
#import "SellRamAbiJsonToBinRequest.h"
#import "SCAlertCreater.h"
#import "AESCrypt.h"
#import "IOSTRAMInfo.h"
#import "NSString+ValidateFormat.h"

@interface IOSTIGASResoursController ()
<EOSRAMScrollViewDelegaet>
@property(strong, nonatomic) ProgressView *freezeBPView;
@property(strong, nonatomic) walletModel *wallet;
@property(strong, nonatomic) UILabel *freezeENLab;
@property(strong, nonatomic) YUSegment *segment;
@property(strong, nonatomic) EOSRAMScrollView *freezeScrollView;
@property(strong, nonatomic) UIScrollView *scrollView;

@end

@implementation IOSTIGASResoursController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SCGray(253);
    self.title = LocalizedString(@"iGAS");
    [self setupview];
    self.wallet = [UserinfoModel shareManage].wallet;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)setIostAccount:(IOSTAccount *)iostAccount
{
    _iostAccount = iostAccount;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateData];
    });
}

- (void)setupview
{
    
    self.scrollView = [UIScrollView new];
    self.scrollView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.scrollView];
    
    _freezeBPView = [ProgressView new];
    _freezeBPView.centerX = SCREEN_WIDTH/2;
    _freezeBPView.top = 30;
    _freezeBPView.unit = @"M";
    _freezeBPView.limitCount = 0;
    _freezeBPView.usedCount = 0;
    _freezeBPView.limitTitleLab.text = LocalizedString(@"限额");
    _freezeBPView.usedTitleLab.text = LocalizedString(@"已使用");
    _freezeBPView.usedColor = SCColor(60, 143, 96);
    _freezeBPView.limitColor = SCColor(84, 171, 122);
    [_freezeBPView layout];
    [self.scrollView addSubview:_freezeBPView];
    
    _freezeENLab = [UILabel new];
    _freezeENLab.size = CGSizeMake(SCREEN_WIDTH, 30);
    _freezeENLab.top = _freezeBPView.bottom+5;
    _freezeENLab.textAlignment = NSTextAlignmentCenter;
    _freezeENLab.textColor = SCColor(84, 163, 171);
    _freezeENLab.font = kFont(13);
    _freezeENLab.text = @"已抵押 0.000 IOST";
    [self.scrollView addSubview:_freezeENLab];
    
    [self.scrollView addSubview:self.segment];
    self.segment.top = _freezeENLab.bottom+16;
    
    
    self.freezeScrollView = [[EOSRAMScrollView alloc]init];
    self.freezeScrollView.x = 0;
    self.freezeScrollView.top = self.segment.bottom;
    self.freezeScrollView.delegate = self;
    self.freezeScrollView.type = 0;
    self.freezeScrollView.coinNameLab.text = @"IOST";
    self.freezeScrollView.usedResourceLab.text = LocalizedString(@"可用余额 0.00 IOST");
    self.freezeScrollView.freezeTf.placeholder = LocalizedString(@"请输入抵押数量");
    [self.freezeScrollView.confirm setTitle:LocalizedString(@"抵押") forState:UIControlStateNormal];
    [self.scrollView addSubview:self.freezeScrollView];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.freezeScrollView.bottom+80);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}


- (void)updateData
{
    Gas_Info *iost_gas = self.iostAccount.gas_info;
    _freezeBPView.usedCount = ([iost_gas.limit floatValue]-[iost_gas.current_total floatValue])/1000000;
    _freezeBPView.limitCount = [iost_gas.limit floatValue]/1000000;
    [_freezeBPView layout];
    
    _freezeENLab.text = [NSString stringWithFormat:@"已抵押 %@ IOST",iost_gas.pledgedCount];
    self.freezeScrollView.priceLab.text = [NSString stringWithFormat:LocalizedString(@"正在赎回 %@ IOST"),self.iostAccount.unpledgedCount];
    if (self.segment.selectedIndex) {
        
    }
    else
    {
        _freezeScrollView.usedResourceLab.text = [NSString stringWithFormat:LocalizedString(@"可用余额 %@ IOST"),self.iostAccount.balance];
    }
}

//监听segment的变化
- (void)onSegmentChange {
    self.freezeScrollView.type = self.segment.selectedIndex;
    if (!self.segment.selectedIndex) {
        self.freezeScrollView.freezeTf.placeholder = LocalizedString(@"请输入抵押数量");
        [self.freezeScrollView.confirm setTitle:LocalizedString(@"抵押") forState:UIControlStateNormal];
        _freezeScrollView.usedResourceLab.text = [NSString stringWithFormat:LocalizedString(@"可用余额 %@ IOST"),self.iostAccount.balance];
    }
    else
    {
        _freezeScrollView.usedResourceLab.text = @"";
        self.freezeScrollView.freezeTf.placeholder = LocalizedString(@"请输入赎回数量");
        [self.freezeScrollView.confirm setTitle:LocalizedString(@"赎回") forState:UIControlStateNormal];
    }
    _freezeScrollView.coinNameLab.text = @"IOST";
}

-(YUSegment *)segment
{
    if (!_segment) {
        _segment = [[YUSegment alloc] initWithTitles:@[LocalizedString(@"抵押"),LocalizedString(@"赎回")]];
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

#pragma mark - EOSRAMScrollViewDelegaet
- (void)EOSRAMScrollViewFreeze:(CGFloat)Count freezeType:(NSInteger)type
{
    if (!type) {
        if (Count>[self.iostAccount.balance floatValue]) {
            [TKCommonTools showToast:LocalizedString(@"余额不足")];
            return;
        }
    }else{
        if (Count>[self.iostAccount.gas_info.pledgedCount floatValue]) {
            [TKCommonTools showToast:LocalizedString(@"余额不足")];
            return;
        }
    }
    if (![@"" isPositivePureInt:self.freezeScrollView.freezeTf.text]) {
        [TKCommonTools showToast:LocalizedString(@"输入数量必须为整数!")];
        return;
    }
    WeakSelf(weakSelf);
    SCWalletEnterView *se = [SCWalletEnterView shareInstance];
    se.title = LocalizedString(@"请输入密码");
    se.placeholderStr = @"密码";
    se.isOperation = NO;
    [se setReturnTextBlock:^(NSString *showText) {
        [SVProgressHUD show];
        if (!type) {
            [weakSelf buyGAS:Count passWord:showText];
        }
        else{
            [weakSelf sellGAS:Count passWord:showText];
        }
    }];
}

- (void)buyGAS:(CGFloat)count passWord:(NSString *)pwd
{
    NSString *money = [NSString stringWithFormat:@"%.f",count];
    [IOSTClient iost_sendToAssress:self.wallet.address fromAddress:self.wallet.address money:money token:@"" memo:@"" transactionType:IOSTTransactionPledge walletPassword:pwd block:^(IOSTTransResult *result) {
        [SVProgressHUD dismiss];
    }];
}

- (void)sellGAS:(CGFloat)count passWord:(NSString *)pwd
{
    NSString *money = [NSString stringWithFormat:@"%.f",count];
    [IOSTClient iost_sendToAssress:self.wallet.address fromAddress:self.wallet.address money:money token:@"" memo:@"" transactionType:IOSTTransactionUnpledge walletPassword:pwd block:^(IOSTTransResult *result) {
        [SVProgressHUD dismiss];
    }];
}


@end
