//
//  TWAssetIssueViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/6/8.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWAssetIssueViewController.h"
#import "TKCommonTools.h"
#import "TWAddressOnlyViewController.h"
#import "UIViewController+Navigation.h"
#import "TWHexConvert.h"

@interface TWAssetIssueViewController ()<UITextFieldDelegate>

@property(nonatomic , strong) IBOutlet UITextField *nameField;
@property(nonatomic , strong) IBOutlet UITextField *abbrField;
@property(nonatomic , strong) IBOutlet UITextField *totalSupplyField;
@property(nonatomic , strong) IBOutlet UITextField *descriptionField;
@property(nonatomic , strong) IBOutlet UITextField *websiteField;
@property(nonatomic , strong) IBOutlet UITextField *exTrxField;
@property(nonatomic , strong) IBOutlet UITextField *exTokenField;
@property(nonatomic , strong) IBOutlet UITextField *frozenAmountField;
@property(nonatomic , strong) IBOutlet UITextField *frozenDaysField;
@property(nonatomic , strong) IBOutlet UITextField *startField;
@property(nonatomic , strong) IBOutlet UITextField *endField;
@property(nonatomic , strong) IBOutlet UIView *contentView;
@property(nonatomic , strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic , strong) IBOutlet UILabel *tokenPriceLabel;

@property(nonatomic , strong) IBOutlet UIDatePicker *datePicker;
@property(nonatomic , strong) IBOutlet UIView *pickerView;
@property(nonatomic , strong) IBOutlet UIView *inputToolView;
@property(nonatomic , assign) BOOL inputStart;
@property(nonatomic , strong) AssetIssueContract *contract ;

@end

@implementation TWAssetIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBackItem];
    self.title = @"ISSUE A TOKEN";
    NSArray *subViews = [_contentView subviews];
    for (UITextField *f in subViews) {
        if ([f isKindOfClass:[UITextField class]]) {
            f.delegate =self;
        }
    }
    
    _datePicker.minimumDate = [NSDate date];
    _contract = [AssetIssueContract new];
    _contract.ownerAddress = [AppWalletClient address];
    
    _startField.inputView = _pickerView;
    _startField.inputAccessoryView = _inputToolView;
    
    _endField.inputView = _pickerView;
    _endField.inputAccessoryView = _inputToolView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.contentView.superview) {
        self.contentView.width = SCREEN_WIDTH;
        [self.scrollView addSubview:self.contentView];
        self.scrollView.contentSize = self.contentView.size;
    }
}

-(BOOL)canCreate
{
    NSString *tip = nil;
    if (self.nameField.text.length == 0) {
        tip = @"Input token name";
    }else if (_abbrField.text.length == 0){
        tip = @"Input token abbr";
    }else if (_abbrField.text.length >= 6){
        tip = @"Abbr length should less than 6 ";
    } else if ([_totalSupplyField.text integerValue] == 0){
        tip = @"Input total supply";
    }else if ([_descriptionField.text length] == 0){
        tip = @"Input description";
    }else if (_websiteField.text.length == 0){
        tip = @"Input website url";
    }else if ([_exTrxField.text integerValue] == 0){
        tip = @"Input TRX Amount";
    }else if ([_exTrxField.text integerValue] == 0){
        tip = @"Input token amount";
    }else if (_contract.startTime <= 1){
        tip = @"Choose start time";
    }else if (_contract.endTime <= 1){
        tip = @"Choose end time";
    }else if (_contract.endTime < _contract.startTime){
        tip = @"Start time must earlier than end time";
    }
    
    if (tip) {
        
        MBProgressHUD *hud = [self showHudTitle:tip];
        [hud hideAnimated:YES afterDelay:1.5];
        return NO;
    }
    
    _contract.name = [self.nameField.text dataUsingEncoding:NSUTF8StringEncoding];
    _contract.abbr = [self.abbrField.text dataUsingEncoding:NSUTF8StringEncoding];
    _contract.totalSupply = [self.totalSupplyField.text integerValue];
    _contract.description_p = [self.descriptionField.text dataUsingEncoding:NSUTF8StringEncoding];
    _contract.URL = [self.websiteField.text dataUsingEncoding:NSUTF8StringEncoding];
    _contract.trxNum = [self.exTrxField.text intValue]*kDense;
    _contract.num = [self.exTokenField.text intValue];
    
    
//    if ([self.frozenDaysField.text integerValue] > 0 && [self.frozenAmountField.text integerValue] > 0) {
//        AssetIssueContract_FrozenSupply *supply = [AssetIssueContract_FrozenSupply new];
//        supply.frozenDays = [_frozenDaysField.text integerValue];
//        supply.frozenAmount = [_frozenAmountField.text integerValue];
//
//        [_contract.frozenSupplyArray addObject:supply];
//    }    
//    else{
//        AssetIssueContract_FrozenSupply *supply = [AssetIssueContract_FrozenSupply new];
//        supply.frozenDays = 1;
//        supply.frozenAmount = 0;
//
//        [_contract.frozenSupplyArray addObject:supply];
//    }
    
    
    
    return YES;
}

-(IBAction)createAction:(id)sender{
    
    [self.view endEditing:YES];
    if (![self canCreate]) {
        return;
    }
        
    [self showAlert:nil mssage:@"Confirm that creating the total supply of the token costs a one time total fee of 1024 TRX." confrim:@"Confirm" cancel:@"Cancel" confirmAction:^{
        if (AppWalletClient.type == TWWalletAddressOnly) {
            [self publicAddressOnlyCreate];
            return;
        }
        
        [self createIssue];
    }];
    
}

-(void)createIssue
{
    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
    TWWalletAccountClient *client = AppWalletClient;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [wallet createAssetIssueWithRequest:_contract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            hud.label.text = [error localizedDescription];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.5 ];
            });
            return ;
        }else if (!response.hasRawData){
            hud.label.text = @"Create Asset Issue Failed";
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.5 ];
            });
            return ;
        }
        
        response = [client signTransaction:response];
        
        [wallet broadcastTransactionWithRequest:response handler:^(Return * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                hud.label.text = [error localizedDescription];
            }else{
                if (response.code == Return_response_code_Success) {
                    hud.label.text = @"Success";
                    
                    [client refreshAccount:^(TronAccount *account, NSError *error) {
                        
                    }];
                }else{
                    hud.label.text = [[NSString alloc] initWithData:response.message encoding:NSUTF8StringEncoding];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.5];
            });
        }];
        
    }];
}

-(void)publicAddressOnlyCreate
{
    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [wallet createAssetIssueWithRequest:_contract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        if (error) {
            hud.label.text = [error localizedDescription];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.5 ];
            });
            return ;
        }else if (!response.hasRawData){
            hud.label.text = @"Create Asset Issue Failed";
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.5 ];
            });
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        
        [self signTransaction:response];
    }];
}

-(void)signTransaction:(Transaction *)transaction
{
    
    TWAddressOnlyViewController *controller = [[TWAddressOnlyViewController alloc] initWithNibName:@"TWAddressOnlyViewController" bundle:nil];
    
    NSData *data = [transaction data];
    NSString *str = [TWHexConvert convertDataToHexStr:data];
    [controller updateQR:str];
    __weak typeof(self) wself = self;
    controller.scanblock = ^(NSString *qr) {
        NSData *tdata = [TWHexConvert convertHexStrToData:qr];
        Transaction *transaction = [Transaction parseFromData:tdata error:nil];
        [wself broadcastTransaction:transaction];
    };
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)broadcastTransaction:(Transaction *)transaction
{
    TWWalletAccountClient *client = AppWalletClient;
    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
    MBProgressHUD *hud = [self showHud];
    [wallet broadcastTransactionWithRequest:transaction handler:^(Return * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            hud.label.text = [error localizedDescription];
        }else{
            if (response.code == Return_response_code_Success) {
                hud.label.text = @"Success";
                
                [client refreshAccount:^(TronAccount *account, NSError *error) {

                }];
                
            }else{
                
                hud.label.text = [[NSString alloc] initWithData:response.message encoding:NSUTF8StringEncoding];
                if (hud.label.text.length == 0) {
                    hud.label.text = @"Send failed";
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.5 ];
        });
    }];
}

-(NSString *)chooseDateTime
{
    return  [TKCommonTools dateStringWithFormat:TKDateFormatEnglishAll date:self.datePicker.date];
}

-(void)tryExchange
{
    if ([_exTrxField.text intValue] > 0 && [_exTokenField.text integerValue] > 0) {
        _contract.trxNum = [_exTrxField.text intValue];
        _contract.num = [_exTokenField.text intValue];
        
        if (_contract.trxNum/_contract.num*_contract.num == _contract.trxNum) {
            //even
            _tokenPriceLabel.text = [NSString stringWithFormat:@"1 Token = %d TRX",_contract.trxNum/_contract.num];
        }else{
           _tokenPriceLabel.text = [NSString stringWithFormat:@"1 Token = %.3f TRX",((float)_contract.trxNum)/_contract.num];
        }
        
    }
}

-(IBAction)cancelAction:(id)sender
{
    [self.startField resignFirstResponder];
    [self.endField resignFirstResponder];
}

-(IBAction)doneAction:(id)sender
{
    if ([self.startField isFirstResponder]) {
        _contract.startTime = [self.datePicker.date timeIntervalSince1970]*1000;
        _startField.text = [self chooseDateTime];
        [_startField resignFirstResponder];
        [_endField becomeFirstResponder];
    }else{
        _contract.endTime = [self.datePicker.date timeIntervalSince1970]*1000;
        _endField.text = [self chooseDateTime];
        [_endField resignFirstResponder];
    }
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _startField) {
        _contract.startTime = [self.datePicker.date timeIntervalSince1970]*1000;
        textField.text = [self chooseDateTime];
    }else if (textField == _endField){
        _contract.endTime = [self.datePicker.date timeIntervalSince1970]*1000;
        textField.text = [self chooseDateTime];
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _exTrxField || textField == _exTokenField){
        [self tryExchange];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
