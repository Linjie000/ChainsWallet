//
//  SCTransferController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCTransferController.h"
#import "SCTransferTypeCell.h"
#import "SCTransferAddressCell.h"
#import "SCTransferFootView.h"
#import "SCCommonBtn.h"
#import "SCWalletEnterView.h"
#import "SCScanController.h"
#import "SCRootTool.h"
#import "UIBarButtonItem+SetUpBarButtonItem.h"
#import "SCProcessingController.h"
#import "SCAddressBookController.h"
#import "SCTransferBtcFootView.h"
#import "AESCrypt.h"
#import "SCWalletTipView.h"
#import "Get_token_info_service.h"
#import "TransferAbi_json_to_bin_request.h"
#import "ContractConstant.h"
#import "EOSBaseResult.h"
#import "TransferService.h"
#import "AESCrypt.h"

#import "TRXClient.h"
#import "BTCClient.h"
#import "ETHClient.h"


@interface SCTransferController ()
<UITableViewDelegate,UITableViewDataSource,SCTransferAddressDelegate>
{
    SCTransferTypeCell *_transferTypeCell;
    SCTransferAddressCell *_transferAddressCell;
    SCTransferFootView    *_transferEthFootView;
    SCTransferBtcFootView *_transferBtcFootView;
}
@property(strong ,nonatomic) UITableView *tableView;
@property(strong ,nonatomic) coinModel *model;
@property(strong ,nonatomic) Get_token_info_service *get_token_info_service;
@property(strong ,nonatomic) TransferAbi_json_to_bin_request *transferAbi_json_to_bin_request;
@property(nonatomic, strong) TransferService *mainService;
@property(strong ,nonatomic) NSMutableArray *get_token_info_service_data_array;

@end

@implementation SCTransferController

- (Get_token_info_service *)get_token_info_service{
    if (!_get_token_info_service) {
        _get_token_info_service = [[Get_token_info_service alloc] init];
    }
    return _get_token_info_service;
}

- (TransferService *)mainService{
    if (!_mainService) {
        _mainService = [[TransferService alloc] init];
        _mainService.delegate = self;
    }
    return _mainService;
}

- (TransferAbi_json_to_bin_request *)transferAbi_json_to_bin_request{
    if (!_transferAbi_json_to_bin_request) {
        _transferAbi_json_to_bin_request = [[TransferAbi_json_to_bin_request alloc] init];
    }
    return _transferAbi_json_to_bin_request;
}

- (NSMutableArray *)get_token_info_service_data_array{
    if (!_get_token_info_service_data_array) {
        _get_token_info_service_data_array = [[NSMutableArray alloc] init];
    }
    return _get_token_info_service_data_array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"转账");
    [self subViews];

    [self addTronNotification];
    
    UIBarButtonItem *popToSup = [UIBarButtonItem barButtonWithImage:@"navi_back" highligthedImage:@"navi_back" selector:@selector(popToSuperView) target:self];
    self.navigationItem.leftBarButtonItem = popToSup;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//- (void)requestTokenInfoDataArray{
//    self.get_token_info_service.accountName = [UserinfoModel shareManage].wallet.address;
//    WeakSelf(weakSelf);
//    [self.get_token_info_service get_token_info:^(id service, BOOL isSuccess) {
//        if (isSuccess) {
//            NSArray *aa = weakSelf.get_token_info_service.dataSourceArray;
//            weakSelf.get_token_info_service_data_array = weakSelf.get_token_info_service.dataSourceArray;
//            if (weakSelf.get_token_info_service_data_array.count > 0) {
//                weakSelf.currentToken = weakSelf.get_token_info_service_data_array[0];
//            }else{
//                [TKCommonTools showToast:LocalizedString(@"当前账号未添加资产")];
//                return;
//            }
//        }
//    }];
//}

- (void)popToSuperView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setBrand:(NSString *)brand
{
    _brand = brand;
    NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:_brand],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
    self.model = [arr lastObject];
    
    if ([_brand isEqualToString:@"ETH"])
        _transferTypeCell.balanceLab.text = [NSString stringWithFormat:@"%@ %.4f %@",LocalizedString(@"余额："),[self.model.totalAmount floatValue]/kETHDense,@"ETH"];
}

- (void)setToAddress:(NSString *)toAddress
{
    _toAddress = toAddress;
}

- (void)addTronNotification
{
    //trx 钱包
    if (![_brand isEqualToString:@"TRX"]) {
        return;
    }
    [self addNotificationForName:kAccountUpdateNotification response:^(NSDictionary * _Nonnull userInfo) {
        TronAccount *model = [userInfo objectForKey:@"Account"];
        //更新界面
        _transferTypeCell.balanceLab.text = [NSString stringWithFormat:@"%@ %.2f %@",LocalizedString(@"余额："),model.balance/kDense,@"TRX"];
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.fd_fullscreenPopGestureRecognizer setEnabled:NO];
    if ([self.model.brand isEqualToString:@"ETH"]) {
        _transferEthFootView = [SCTransferFootView new];
        _tableView.tableFooterView = _transferEthFootView;
    }
    if ([self.model.brand isEqualToString:@"BTC"]) {
        _transferBtcFootView = [SCTransferBtcFootView new];
        _tableView.tableFooterView = _transferBtcFootView;
    }
    if (([self.model.brand isEqualToString:@"EOS"])) {
        _transferAddressCell.addressTF.placeholder = LocalizedString(@"请输入EOS账号名");
        _transferAddressCell.noteTF.placeholder = @"Memo";
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.fd_fullscreenPopGestureRecognizer setEnabled:YES];
}

- (void)subViews
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"扫一扫-icon"]  style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    SCCommonBtn *commonBtn = [SCCommonBtn createCommonBtnText:LocalizedString(@"下一步")];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-commonBtn.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = SCGray(245);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    [self.view addSubview:_tableView];
    
    commonBtn.bottom = self.view.height-NAVIBAR_HEIGHT;
    [self.view addSubview:commonBtn];
    [commonBtn setTapActionWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self transactionAction];
        });
    }];
}

#pragma mark - Addrss
- (void)transferAddressDelegate
{
    SCAddressBookController *scb = [SCAddressBookController new];
    scb.brand = self.brand;
    [scb setBlock:^(NSString * _Nonnull address) {
        self->_transferAddressCell.addressTF.text = address;
    }];
    [self.navigationController pushViewController:scb animated:YES];
}

#pragma mark - 扫一扫
- (void)rightClick
{
    SCScanController *sc = [SCScanController new];
    sc.addressType = [RewardHelper typeNamecoin:self.model.brand];
    [sc setBlock:^(NSString *address, NSString *brand) {
        self->_transferAddressCell.addressTF.text = address;
    }];
    [self presentViewController:sc animated:YES completion:nil];
}

- (void)transactionAction
{
    NSString *price = _transferTypeCell.priceTF.text;
    NSString *address = _transferAddressCell.addressTF.text;
    if ([price floatValue]<=0) {
        [TKCommonTools showToast:LocalizedString(@"转账金额需大于0")];
        return;
    }
    if ([RewardHelper isBlankString:address]) {
        [TKCommonTools showToast:LocalizedString(@"请输入地址")];
        return;
    }
    if ([_brand isEqualToString:@"ETH"]) {
        NSString *gasLimt = _transferEthFootView.gasField.text;
        if ([gasLimt floatValue]<21000) {
            SCWalletTipView *tip = [SCWalletTipView shareInstance];
            tip.title = LocalizedString(@"提示");
            tip.detailStr = LocalizedString(@"Gas 不能少于21000");
            return;
        }
    }
 
    SCWalletEnterView *se = [SCWalletEnterView shareInstance];
    se.title = LocalizedString(@"请输入密码");
    se.placeholderStr = @"密码";
    se.isOperation = NO;
    [se setReturnTextBlock:^(NSString *showText) {
        walletModel *model = [UserinfoModel shareManage].wallet;
        //解密
//        NSString *ss = [AESCrypt decrypt:model.password password:showText];
//        if ([RewardHelper isBlankString:ss]) {
//            [TKCommonTools showToast:LocalizedString(@"密码错误")];
//            return ;
//        }
        if ([_brand isEqualToString:@"BTC"]) {
            [self btcTransfer:showText];
            return;
        }
        if ([_brand isEqualToString:@"TRX"]) {
            [self tronTransfer];
            return;
        }
        if ([_brand isEqualToString:@"ETH"]) {
            [self ethTransfer:showText];
            return;
        }
        if ([_brand isEqualToString:@"EOS"]||[self.model.fatherCoin isEqualToString:@"EOS"]) {
            [self eosTransfer:showText];
            return;
        }
        if ([_brand isEqualToString:@"IOST"]) {
            [self iostTransfer:showText];
            return;
        }
    }];

    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        SCTransferTypeCell *cell = [[SCTransferTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCTransferTypeCell"];
        _transferTypeCell = cell;
        cell.model = self.model;
        return cell;
    }
    if (indexPath.section==1) {
        SCTransferAddressCell *cell = [[SCTransferAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCTransferAddressCell"];
        cell.delegate = self;
        _transferAddressCell = cell;
        cell.addressTF.text = self.toAddress;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return TYPE_HEIGHT;
    }
    return ADDRESS_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - 转账
#pragma mark - 波场
- (void)tronTransfer
{
    NSString *price = _transferTypeCell.priceTF.text;
    NSString *address = _transferAddressCell.addressTF.text;
    //密码正确 TRX 转账
    [TRXClient reallySendAmount:price toAddress:address handler:^(id  _Nonnull response) {
        if ([response[@"result"] integerValue]) {
            [SVProgressHUD showErrorWithStatus:@"转账成功"];
            
            //                    [_walletClient refreshAccount:nil];
            //                    [weakSelf getData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"转账失败"];
        }
    }];
}

#pragma mark - ETH
- (void)ethTransfer:(NSString *)password
{
    NSString *toAddress = _transferAddressCell.addressTF.text;
    NSString *currentAddress = [UserinfoModel shareManage].wallet.address;
    NSString *price = _transferTypeCell.priceTF.text;
    NSString *gasPrice = _transferEthFootView.gaweiField.text;
    NSString *gasLimt = _transferEthFootView.gasField.text;
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    NSString *keyStore = [AESCrypt decrypt:wallet.keyStore password:password];
    if ([toAddress isEqualToString:currentAddress]) {
        [TKCommonTools showToast:LocalizedString(@"不能转账给自己")];
    }
    [SVProgressHUD show];
    [ETHClient sendTransactionWithkeyStore:keyStore address:toAddress password:password amount:price gasPrice:gasPrice gasLimt:gasLimt block:^(NSString * _Nonnull hashStr, BOOL suc) {
        [SVProgressHUD dismiss];
        if (suc) {
            [TKCommonTools showToast:LocalizedString(@"转账成功")];
        }
        else{
            [TKCommonTools showToast:LocalizedString(@"转账失败，请确保账号有足够的余额")];
        }
    }];
}

#pragma mark - btc
- (void)btcTransfer:(NSString *)password
{
    NSString *toAddress = _transferAddressCell.addressTF.text;
    NSString *fromAddress = [UserinfoModel shareManage].wallet.address;
    NSString *price = _transferTypeCell.priceTF.text;
    NSString *privateKey = [AESCrypt decrypt:[UserinfoModel shareManage].wallet.privateKey password:password];
    NSString *fee = _transferBtcFootView.countFee.text;
    
    [BTCClient sendToAddress:toAddress money:price fromAddress:fromAddress privateKey:privateKey fee:[fee integerValue] block:^(NSString * _Nonnull hashStr, BOOL suc) {
        if (suc) {
            [TKCommonTools showToast:LocalizedString(@"转账成功")];
        }
        else{
            [TKCommonTools showToast:@"转账失败，请确保账号有足够的余额"];
        }
    }];
}

#pragma mark - eos
- (void)eosTransfer:(NSString *)password
{
    [SVProgressHUD show];
    NSString *price = _transferTypeCell.priceTF.text;
    NSString *to = _transferAddressCell.addressTF.text;
    NSString *accountName = [UserinfoModel shareManage].wallet.address;
    NSString *memo = _transferAddressCell.noteTF.text; 
    // 验证密码输入是否正确
    walletModel *current_wallet = [UserinfoModel shareManage].wallet;
  
    self.transferAbi_json_to_bin_request.code = self.coin.contractAddress;
    
    if ([self.coin.totalAmount isEqualToString:@"0"] || (self.coin.totalAmount.doubleValue  < price.doubleValue)) {
        [TKCommonTools showToast:LocalizedString(@"余额不足")]; 
        return;
    }else{
        NSString *percision = [NSString stringWithFormat:@"%ld", [NSString getDecimalStringPercisionWithDecimalStr:self.coin.totalAmount]];
        self.transferAbi_json_to_bin_request.quantity = [NSString stringWithFormat:@"%@ %@", [NSString stringWithFormat:@"%.*f", 4, price.doubleValue], self.coin.brand];
    }
    self.transferAbi_json_to_bin_request.action = ContractAction_TRANSFER;
    self.transferAbi_json_to_bin_request.from = accountName;
    self.transferAbi_json_to_bin_request.to = to;
    self.transferAbi_json_to_bin_request.memo = VALIDATE_STRING(memo);
    WeakSelf(weakSelf);
    [self.transferAbi_json_to_bin_request postRequestDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
//        EOSBaseResult *result = [EOSBaseResult mj_objectWithKeyValues:data];
//        if (![result.code isEqualToNumber:@0]) {
//            [TKCommonTools showToast:result.message];
//            return ;
//        }
        SCLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"binargs"] );
//        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:CURRENT_ACCOUNT_NAME];
        weakSelf.mainService.available_keys = @[VALIDATE_STRING(current_wallet.account_owner_public_key) , VALIDATE_STRING(current_wallet.account_active_public_key)];
        
        weakSelf.mainService.action = ContractAction_TRANSFER;
        weakSelf.mainService.code = weakSelf.coin.contractAddress;
        weakSelf.mainService.sender = accountName;
#pragma mark -- [@"data"]
        weakSelf.mainService.binargs = data[@"binargs"];
        weakSelf.mainService.pushTransactionType = PushTransactionTypeTransfer;
        weakSelf.mainService.password = password;
        [weakSelf.mainService pushTransaction];
    
    } failure:^(id DAO, NSError *error) {
        
    }];
}

// TransferServiceDelegate
-(void)pushTransactionDidFinish:(TransactionResult *)result{
    [SVProgressHUD dismiss];
    if (![RewardHelper isBlankString:result.transaction_id]) {
        [TKCommonTools showToast:LocalizedString(@"转账成功,等待区块确认")];
        
    }else{
        NSDictionary *detailsDic = result.details[0];
        [TKCommonTools showToast:detailsDic[@"message"]];
    }
    
}

#pragma mark - iost
- (void)iostTransfer:(NSString *)password
{
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    NSString *price = _transferTypeCell.priceTF.text;
    NSString *to = _transferAddressCell.addressTF.text;
    NSString *memo = _transferAddressCell.noteTF.text;
    [SVProgressHUD show];
    [IOSTClient iost_sendToAssress:to fromAddress:wallet.address money:price token:@"iost" memo:memo transactionType:IOSTTransactionTransfer walletPassword:password block:^(IOSTTransResult *result) {
        [SVProgressHUD dismiss];
    }];
}

@end
