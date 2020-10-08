//
//  IOSTRAMResourceController.m
//  ShainChainW
//
//  Created by 闪链 on 2019/5/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "IOSTRAMResourceController.h"
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

@interface IOSTRAMResourceController ()
<EOSRAMScrollViewDelegaet>
@property(strong, nonatomic) ProgressView *freezeBPView;
@property(strong, nonatomic) walletModel *wallet;
@property(strong, nonatomic) IOSTRAMInfo *ramInfo;
@property(strong, nonatomic) UILabel *freezeBPLab;
@property(strong, nonatomic) YUSegment *segment;
@property(strong, nonatomic) EOSRAMScrollView *freezeScrollView;

@property(strong, nonatomic) UIScrollView *scrollView;

@end

@implementation IOSTRAMResourceController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SCGray(253);
    self.title = LocalizedString(@"内存");
    [self setupview];
    [self getRamInfo];
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
    _freezeBPView.unit = @"byte";
    _freezeBPView.limitCount = 0;
    _freezeBPView.usedCount = 0;
    _freezeBPView.limitTitleLab.text = LocalizedString(@"限额");
    _freezeBPView.usedTitleLab.text = LocalizedString(@"已使用");
    _freezeBPView.usedColor = SCColor(222, 128, 1);
    _freezeBPView.limitColor = SCColor(255, 156, 5);
    [_freezeBPView layout];
    [self.scrollView addSubview:_freezeBPView];
    
    _freezeBPLab = [UILabel new];
    _freezeBPLab.size = CGSizeMake(SCREEN_WIDTH, 30);
    _freezeBPLab.top = _freezeBPView.bottom+5;
    _freezeBPLab.textAlignment = NSTextAlignmentCenter;
    _freezeBPLab.textColor = _freezeBPView.limitColor;
    _freezeBPLab.font = kFont(14);
    _freezeBPLab.text = [NSString stringWithFormat:@"可用内存 ≈ 0.0000 IOST"];
    [self.scrollView addSubview:_freezeBPLab];
    
    [self.scrollView addSubview:self.segment];
    self.segment.top = _freezeBPLab.bottom+16;
    
    
    self.freezeScrollView = [[EOSRAMScrollView alloc]init];
    self.freezeScrollView.x = 0;
    self.freezeScrollView.top = self.segment.bottom;
    self.freezeScrollView.delegate = self;
    self.freezeScrollView.type = 0;
    self.freezeScrollView.coinNameLab.text = @"KB";
    self.freezeScrollView.usedResourceLab.text = LocalizedString(@"可用余额 0.00 IOST");
    [self.scrollView addSubview:self.freezeScrollView];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.freezeScrollView.bottom+80);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)getRamInfo
{
    [IOSTClient iost_getRamInfoHandle:^(IOSTRAMInfo *ramInfo) {
        self.ramInfo = ramInfo;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateData];
        });
    }];
}

- (void)updateData
{
    Ram_Info *iost_ram = self.iostAccount.ram_info;
    _freezeBPView.usedCount = [iost_ram.used floatValue];
    _freezeBPView.limitCount = [iost_ram.total floatValue];
    [_freezeBPView layout];
    
    
    _freezeBPLab.text = [NSString stringWithFormat:LocalizedString(@"可用内存 ≈ %.5f IOST"),[iost_ram.available floatValue]*[self.ramInfo.buy_price doubleValue]];
    _freezeScrollView.priceLab.text = [NSString stringWithFormat:@"RAM 价格 %.5f IOST/KB ",[self.ramInfo.buy_price doubleValue]*1024 ] ;
    if (self.segment.selectedIndex) {
        self.freezeScrollView.usedResourceLab.text = [NSString stringWithFormat:LocalizedString(@"可用 %.4f KB"),[self.ramInfo.available_ram doubleValue]*1024];
    }
    else
    {
        _freezeScrollView.usedResourceLab.text = [NSString stringWithFormat:LocalizedString(@"可用余额 %@ IOST"),self.iostAccount.balance];
    }
}

//监听segment的变化
- (void)onSegmentChange {
    self.freezeScrollView.type = self.segment.selectedIndex;
    self.freezeScrollView.coinNameLab.text = @"KB";
    if (self.segment.selectedIndex) {
        self.freezeScrollView.usedResourceLab.text = [NSString stringWithFormat:LocalizedString(@"可用 %.4f KB"),[self.iostAccount.ram_info.available doubleValue]/1024];
    }
    else
    {
        _freezeScrollView.usedResourceLab.text = [NSString stringWithFormat:LocalizedString(@"可用余额 %@ IOST"),_iostAccount.balance];
    }
}

-(YUSegment *)segment
{
    if (!_segment) {
        _segment = [[YUSegment alloc] initWithTitles:@[LocalizedString(@"买内存"),LocalizedString(@"卖内存")]];
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
        if (Count>[_iostAccount.balance floatValue]) {
            [TKCommonTools showToast:LocalizedString(@"余额不足")];
            return;
        }
    }else{
        if (Count>[self.ramInfo.available_ram doubleValue]*1024) {
            [TKCommonTools showToast:LocalizedString(@"余额不足")];
            return;
        }
    }
    WeakSelf(weakSelf);
    SCWalletEnterView *se = [SCWalletEnterView shareInstance];
    se.title = LocalizedString(@"请输入密码");
    se.placeholderStr = @"密码";
    se.isOperation = NO;
    [se setReturnTextBlock:^(NSString *showText) {
        [SVProgressHUD show];
        if (!type) {
            [weakSelf buyRam:Count passWord:showText];
        }
        else{
            [weakSelf sellRam:Count passWord:showText];
        }
    }];
}

- (void)buyRam:(CGFloat)count passWord:(NSString *)pwd
{
    NSString *ram_byte = [NSString stringWithFormat:@"%.f",count*1024];
    [IOSTClient iost_sendToAssress:self.wallet.address fromAddress:self.wallet.address money:ram_byte token:@"" memo:@"" transactionType:IOSTTransactionBuyRam walletPassword:pwd block:^(IOSTTransResult *result) {
        [SVProgressHUD dismiss];
    }];
}

- (void)sellRam:(CGFloat)count passWord:(NSString *)pwd
{
    NSString *ram_byte = [NSString stringWithFormat:@"%.f",count*1024];
    [IOSTClient iost_sendToAssress:self.wallet.address fromAddress:self.wallet.address money:ram_byte token:@"" memo:@"" transactionType:IOSTTransactionSellRam walletPassword:pwd block:^(IOSTTransResult *result) {
        [SVProgressHUD dismiss];
    }];
}


@end
