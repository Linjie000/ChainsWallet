//
//  EOSRAMResourceController.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/28.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSRAMResourceController.h"
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

@interface EOSRAMResourceController ()
<EOSRAMScrollViewDelegaet,TransferServiceDelegate>
@property(strong, nonatomic) ProgressView *freezeBPView;
@property(strong, nonatomic) walletModel *wallet;
@property(strong, nonatomic) UILabel *freezeBPLab;

@property(strong, nonatomic) YUSegment *segment;
@property(strong, nonatomic) EOSRAMScrollView *freezeScrollView;
@property(strong, nonatomic) TransferService *transferService;
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) BuyRamAbiJsonToBinRequest *buyRamAbiJsonToBinRequest;
@property(strong, nonatomic) SellRamAbiJsonToBinRequest *sellRamAbiJsonToBinRequest;
@end

@implementation EOSRAMResourceController

- (BuyRamAbiJsonToBinRequest *)buyRamAbiJsonToBinRequest
{
    if (!_buyRamAbiJsonToBinRequest) {
        _buyRamAbiJsonToBinRequest = [[BuyRamAbiJsonToBinRequest alloc]init];
    }
    return _buyRamAbiJsonToBinRequest;
}

- (SellRamAbiJsonToBinRequest *)sellRamAbiJsonToBinRequest
{
    if (!_sellRamAbiJsonToBinRequest) {
        _sellRamAbiJsonToBinRequest = [[SellRamAbiJsonToBinRequest alloc]init];
    }
    return _sellRamAbiJsonToBinRequest;
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
    self.title = LocalizedString(@"内存");
    [self setupview];
 
    self.wallet = [UserinfoModel shareManage].wallet;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    WeakSelf(weakSelf);
    [EOSClient getRamPricehandle:^(double price) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.freezeScrollView.priceLab.text = [NSString stringWithFormat:@"RAM 价格 %.4f EOS/KB",price];
        }); 
    }];
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
    _freezeBPView.top = 30;
    _freezeBPView.unit = @"KB";
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
    _freezeBPLab.text = [NSString stringWithFormat:@"可用内存 ≈ 0.0000 EOS"];
    [self.scrollView addSubview:_freezeBPLab];
    
    [self.scrollView addSubview:self.segment];
    self.segment.top = _freezeBPLab.bottom+16;
    
    
    self.freezeScrollView = [[EOSRAMScrollView alloc]init];
    self.freezeScrollView.x = 0;
    self.freezeScrollView.top = self.segment.bottom;
    self.freezeScrollView.delegate = self;
    self.freezeScrollView.type = 0;
    self.freezeScrollView.coinNameLab.text = @"EOS";
    self.freezeScrollView.usedResourceLab.text = LocalizedString(@"可用余额 0.00 EOS");
    [self.scrollView addSubview:self.freezeScrollView];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.freezeScrollView.bottom+80);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)updateData
{

    _freezeBPView.usedCount = [self.eosAccount.ram_usage floatValue]/kUnit;
    _freezeBPView.limitCount = [self.eosAccount.ram_quota floatValue]/kUnit;
    [_freezeBPView layout];
    
    _freezeBPLab.text = [NSString stringWithFormat:LocalizedString(@"可用内存 ≈ 0.0000 EOS")];
    
    if (self.segment.selectedIndex) {
        self.freezeScrollView.usedResourceLab.text = [NSString stringWithFormat:LocalizedString(@"可用 %.4f KB"),[self.eosAccount.ram_quota floatValue]/kUnit-[self.eosAccount.ram_usage floatValue]/kUnit];
    }
    else
    {
        _freezeScrollView.usedResourceLab.text = [NSString stringWithFormat:LocalizedString(@"可用余额 %@ EOS"),self.eosAccount.core_liquid_balance];
    }
}

//监听segment的变化
- (void)onSegmentChange {
    self.freezeScrollView.type = self.segment.selectedIndex;
    if (self.segment.selectedIndex) {
        self.freezeScrollView.usedResourceLab.text = [NSString stringWithFormat:LocalizedString(@"可用 %.4f KB"),[self.eosAccount.ram_quota floatValue]/kUnit-[self.eosAccount.ram_usage floatValue]/kUnit];
    }
    else
    {
        _freezeScrollView.usedResourceLab.text = [NSString stringWithFormat:LocalizedString(@"可用余额 %@ EOS"),self.eosAccount.core_liquid_balance];
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
        if (Count>[self.eosAccount.core_liquid_balance floatValue]) {
            [TKCommonTools showToast:LocalizedString(@"余额不足")];
            return;
        }
    }else{
        if (Count>[self.eosAccount.ram_quota floatValue]/kUnit-[self.eosAccount.ram_usage floatValue]/kUnit) {
            [TKCommonTools showToast:LocalizedString(@"余额不足")];
            return;
        }
    }
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
            [weakSelf buyRam:Count passWord:showText];
        }
        else{
            [weakSelf sellRam:Count passWord:showText];
        }
    }];
}
 
- (void)buyRam:(CGFloat)count passWord:(NSString *)pwd
{
    self.buyRamAbiJsonToBinRequest.action = ContractAction_BUYRAM;
    self.buyRamAbiJsonToBinRequest.code = @"eosio";
    self.buyRamAbiJsonToBinRequest.payer = self.wallet.address;
    self.buyRamAbiJsonToBinRequest.receiver = self.wallet.address;
    self.buyRamAbiJsonToBinRequest.quant = [NSString stringWithFormat:@"%.4f %@",count, @"EOS"];
    WeakSelf(weakSelf);
    [self.buyRamAbiJsonToBinRequest postRequestDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"binargs"] );
//        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:weakSelf.eosResourceResult.data.account_name];
//        if (!accountInfo) {
//            [TOASTVIEW showWithText: NSLocalizedString(@"本地无此账号!", nil) ];
//            return ;
//        }
//        weakSelf.transferService.available_keys = @[VALIDATE_STRING(accountInfo.account_owner_public_key) , VALIDATE_STRING(accountInfo.account_active_public_key)];
//        weakSelf.transferService.action = ContractAction_BUYRAM;
//        weakSelf.transferService.sender = weakSelf.eosResourceResult.data.account_name;
//        weakSelf.transferService.code = ContractName_EOSIO;
//#pragma mark -- [@"data"]
//        weakSelf.transferService.binargs = data[@"data"][@"binargs"];
//        weakSelf.transferService.pushTransactionType = PushTransactionTypeTransfer;
//        weakSelf.transferService.password = weakSelf.loginPasswordView.inputPasswordTF.text;
//        [weakSelf.transferService pushTransaction];
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(self.wallet.account_owner_public_key) , VALIDATE_STRING(self.wallet.account_active_public_key)];
        
        weakSelf.transferService.action = ContractAction_BUYRAM;
        weakSelf.transferService.code = @"eosio";
        weakSelf.transferService.sender = self.wallet.address;
#pragma mark -- [@"data"]
        weakSelf.transferService.binargs = data[@"binargs"];
        weakSelf.transferService.pushTransactionType = PushTransactionTypeTransfer;
        weakSelf.transferService.password = pwd;
        [weakSelf.transferService pushTransaction];
    } failure:^(id DAO, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)sellRam:(CGFloat)count passWord:(NSString *)pwd
{
    self.sellRamAbiJsonToBinRequest.action = ContractAction_SELLRAM;
    self.sellRamAbiJsonToBinRequest.code = @"eosio";
    self.sellRamAbiJsonToBinRequest.account = self.wallet.address;
    double bytes;
    bytes = count * 1024;
    self.sellRamAbiJsonToBinRequest.bytes = [NSNumber numberWithDouble:bytes];
    WeakSelf(weakSelf);
    [self.sellRamAbiJsonToBinRequest postRequestDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        NSLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"binargs"] );
   
        weakSelf.transferService.available_keys = @[VALIDATE_STRING(self.wallet.account_owner_public_key) , VALIDATE_STRING(self.wallet.account_active_public_key)];
        weakSelf.transferService.action = ContractAction_SELLRAM;
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
