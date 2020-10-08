//
//  EOSBandWidthController.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/28.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSBandWidthController.h"
#import "ProgressView.h"
#import "YUSegment.h"
#import "EOSBandWidthScrollView.h"
#import "SCWalletEnterView.h"
#import "SCRootTool.h"
#import "TRXClient.h"
#import "ApproveAbiJsonToBinRequest.h"
#import "TransferService.h"
#import "AESCrypt.h"
#import "UnstakeEosAbiJsonTobinRequest.h"
#import "SCAlertCreater.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface EOSBandWidthController ()
<EOSBandWidthScrollViewDelegaet,TransferServiceDelegate>
@property(strong, nonatomic) ProgressView *freezeBPView;
@property(strong, nonatomic) ProgressView *freezeENView;
@property(strong, nonatomic) walletModel *wallet;
@property(strong, nonatomic) UILabel *freezeBPLab;
@property(strong, nonatomic) UILabel *freezeENLab;

@property(strong, nonatomic) YUSegment *segment;
@property(strong, nonatomic) EOSBandWidthScrollView *freezeScrollView;

@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) ApproveAbiJsonToBinRequest *approveAbiJsonToBinRequest;
@property(strong, nonatomic) TransferService *transferService;
@property(strong, nonatomic) UnstakeEosAbiJsonTobinRequest *unstakeEosAbiJsonTobinRequest;
@end

@implementation EOSBandWidthController

- (UnstakeEosAbiJsonTobinRequest *)unstakeEosAbiJsonTobinRequest{
    if (!_unstakeEosAbiJsonTobinRequest) {
        _unstakeEosAbiJsonTobinRequest = [[UnstakeEosAbiJsonTobinRequest alloc] init];
    }
    return _unstakeEosAbiJsonTobinRequest;
}

- (ApproveAbiJsonToBinRequest *)approveAbiJsonToBinRequest
{
    if (!_approveAbiJsonToBinRequest) {
        _approveAbiJsonToBinRequest = [[ApproveAbiJsonToBinRequest alloc]init];
    }
    return _approveAbiJsonToBinRequest;
}

- (TransferService *)transferService{
    if (!_transferService) {
        _transferService = [[TransferService alloc] init];
        _transferService.delegate = self;
    }
    return _transferService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SCGray(253);
    self.title = LocalizedString(@"资源");
    [self setupview];
    self.wallet = [UserinfoModel shareManage].wallet;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
}

- (void)setEosAccount:(EOSAccount *)eosAccount
{
    _eosAccount = eosAccount;
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
    _freezeBPView.top = 20;
    _freezeBPView.unit = @"KB";
    _freezeBPView.limitCount = 0;
    _freezeBPView.usedCount = 0;
    _freezeBPView.usedColor = SCColor(60, 143, 96);
    _freezeBPView.limitColor = SCColor(84, 171, 122);
    _freezeBPView.limitTitleLab.text = LocalizedString(@"限度");
    _freezeBPView.usedTitleLab.text = LocalizedString(@"已使用");
    [_freezeBPView layout];
    [self.scrollView addSubview:_freezeBPView];
    
    _freezeBPLab = [UILabel new];
    _freezeBPLab.size = CGSizeMake(SCREEN_WIDTH, 30);
    _freezeBPLab.top = _freezeBPView.bottom+5;
    _freezeBPLab.textAlignment = NSTextAlignmentCenter;
    _freezeBPLab.textColor = SCColor(84, 171, 122);
    _freezeBPLab.font = kFont(13);
    [self.scrollView addSubview:_freezeBPLab];
    
    _freezeENView = [ProgressView new];
    _freezeENView.centerX = SCREEN_WIDTH/2;
    _freezeENView.top = _freezeBPLab.bottom+16;
    _freezeENView.unit = @"ms";
    _freezeENView.limitCount = 0;
    _freezeENView.usedCount = 0;
    _freezeENView.limitTitleLab.text = LocalizedString(@"限度");
    _freezeENView.usedTitleLab.text = LocalizedString(@"已使用");
    _freezeENView.usedColor = SCColor(66, 142, 150);
    _freezeENView.limitColor = SCColor(84, 163, 171);
    [_freezeENView layout];
    _freezeBPLab.text = @"已抵押网络 0.0000 EOS";
    [self.scrollView addSubview:_freezeENView];
    
    _freezeENLab = [UILabel new];
    _freezeENLab.size = CGSizeMake(SCREEN_WIDTH, 30);
    _freezeENLab.top = _freezeENView.bottom+5;
    _freezeENLab.textAlignment = NSTextAlignmentCenter;
    _freezeENLab.textColor = SCColor(84, 163, 171);
    _freezeENLab.font = kFont(13);
    _freezeENLab.text = @"已抵押 CPU 0.0000 EOS";
    [self.scrollView addSubview:_freezeENLab];
    
    [self.scrollView addSubview:self.segment];
    self.segment.top = _freezeENLab.bottom+16;
    
    self.freezeScrollView = [EOSBandWidthScrollView new];
    self.freezeScrollView.x = 0;
    self.freezeScrollView.top = self.segment.bottom;
    self.freezeScrollView.delegate = self;
    self.freezeScrollView.coinNameLab.text = @"EOS";
    [self.scrollView addSubview:self.freezeScrollView];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.freezeScrollView.bottom+150);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)updateData
{

    _freezeBPView.usedCount = [self.eosAccount.net_limit.used floatValue]/kUnit;
    _freezeBPView.limitCount = [self.eosAccount.net_limit.max floatValue]/kUnit;
    [_freezeBPView layout];
    
    _freezeENView.usedCount = [self.eosAccount.cpu_limit.used floatValue]/1000;
    _freezeENView.limitCount = [self.eosAccount.cpu_limit.max floatValue]/1000;
    [_freezeENView layout];
    
    
    _freezeBPLab.text = [NSString stringWithFormat:LocalizedString(@"已抵押网络 %.4f EOS"),[self.eosAccount.net_weight floatValue]/kEOSDense];
    _freezeENLab.text = [NSString stringWithFormat:LocalizedString(@"已抵押 CPU %.4f EOS"),[self.eosAccount.cpu_weight floatValue]/kEOSDense];
    self.freezeScrollView.eosAccount = self.eosAccount;
}

//监听segment的变化
- (void)onSegmentChange {
    self.freezeScrollView.type = self.segment.selectedIndex;
    [self.freezeScrollView.freezeScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(self.segment.selectedIndex), 0) animated:NO];
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

#pragma mark - EOSBandWidthScrollViewDelegaet
- (void)EOSBandWidthScrollViewNet:(CGFloat)count Cpu:(CGFloat)cpu freezeType:(NSInteger)type
{
    WeakSelf(weakSelf);
    SCWalletEnterView *se = [SCWalletEnterView shareInstance];
    se.title = LocalizedString(@"请输入密码");
    se.placeholderStr = @"密码";
    se.callBack = YES;
    [se setReturnTextBlock:^(NSString *showText) {
        NSString *password = [AESCrypt decrypt:self.wallet.password password:showText];
        if (IsStrEmpty(password)) {
            [TKCommonTools showToast:LocalizedString(@"密码错误")];
            return ;
        }
        if (!type) {
            [weakSelf EOSBandWidthPledgeNet:count Cpu:cpu passWord:password];
        }
        else{
            [weakSelf EOSBandWidthRedeemNet:count Cpu:cpu passWord:password];
        }
    }];
}

//抵押
- (void)EOSBandWidthPledgeNet:(CGFloat)count Cpu:(CGFloat)cpu passWord:(NSString *)pwd
{
    self.approveAbiJsonToBinRequest.action = @"delegatebw";
    self.approveAbiJsonToBinRequest.code = @"eosio";
    self.approveAbiJsonToBinRequest.from = self.wallet.address;
    self.approveAbiJsonToBinRequest.receiver = self.wallet.address;
    self.approveAbiJsonToBinRequest.transfer = @"0";
    
    self.approveAbiJsonToBinRequest.stake_cpu_quantity = [NSString stringWithFormat:@"%.4f EOS", cpu];
    self.approveAbiJsonToBinRequest.stake_net_quantity = [NSString stringWithFormat:@"%.4f EOS", count];
    
    WeakSelf(weakSelf);
    [self.approveAbiJsonToBinRequest postRequestDataSuccess:^(id DAO, id data) {
        
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(self.wallet.account_owner_public_key) , VALIDATE_STRING(self.wallet.account_active_public_key)];
        weakSelf.transferService.action = @"delegatebw";
        weakSelf.transferService.sender = self.wallet.address;
        weakSelf.transferService.code = @"eosio";
#pragma mark -- [@"data"]
        weakSelf.transferService.binargs = data[@"binargs"];
        weakSelf.transferService.pushTransactionType = PushTransactionTypeTransfer;
        weakSelf.transferService.password = pwd;
        [weakSelf.transferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

//赎回
- (void)EOSBandWidthRedeemNet:(CGFloat)count Cpu:(CGFloat)cpu passWord:(NSString *)pwd
{
    self.unstakeEosAbiJsonTobinRequest.action = @"undelegatebw";
    self.unstakeEosAbiJsonTobinRequest.code = @"eosio";
    self.unstakeEosAbiJsonTobinRequest.from = self.wallet.address;
    self.unstakeEosAbiJsonTobinRequest.receiver = self.wallet.address;
 
    self.unstakeEosAbiJsonTobinRequest.unstake_net_quantity = [NSString stringWithFormat:@"%.4f EOS", count];
    self.unstakeEosAbiJsonTobinRequest.unstake_cpu_quantity = [NSString stringWithFormat:@"%.4f EOS", cpu];
    
    WeakSelf(weakSelf);
    [self.unstakeEosAbiJsonTobinRequest postRequestDataSuccess:^(id DAO, id data) {
        
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(self.wallet.account_owner_public_key) , VALIDATE_STRING(self.wallet.account_active_public_key)];
        weakSelf.transferService.action = @"undelegatebw";
        weakSelf.transferService.sender = self.wallet.address;
        weakSelf.transferService.code = @"eosio";
#pragma mark -- [@"data"]
        weakSelf.transferService.binargs = data[@"binargs"];
        weakSelf.transferService.pushTransactionType = PushTransactionTypeTransfer;
        weakSelf.transferService.password = pwd;
        [weakSelf.transferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)pushTransactionDidFinish:(TransactionResult *)result
{
    if (![RewardHelper isBlankString:result.transaction_id]) {
        [TKCommonTools showToast:LocalizedString(@"操作成功")];
        [self postNotificationForName:kSCEOSResourceupdateNotification userInfo:@{}];
    }else
    {
        NSMutableString *message = [NSMutableString new];
        for (NSDictionary *dic in result.details) {
            [message appendString:dic[@"message"]];
            [message appendString:@"\n"];
        }
        [SCAlertCreater showAlertSingleWithController:self title:result.code.stringValue message:message successBtn:LocalizedString(@"确定") failBtn:nil];
    }
}

@end

