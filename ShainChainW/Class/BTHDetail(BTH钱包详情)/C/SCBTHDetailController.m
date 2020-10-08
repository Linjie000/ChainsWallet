//
//  SCBTHDetailController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/17.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCBTHDetailController.h"
#import "SCDailyWalletCell.h"
#import "SCDailyFunCell.h"
#import "SCWalletEnterView.h"
#import "SCBTHAddressCell.h"
#import "SCAlertCreater.h"
#import "SCExpPriKController.h"
#import "SCRootTool.h"
#import "SCReplacePicController.h"
#import "SCPWPromptController.h"
#import "SCDeriveWordsController.h"
#import "SCBTHAddressController.h"
#import "AESCrypt.h"

@interface SCBTHDetailController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_bthTypeStr;//隔离见证 普通
}
@property(strong ,nonatomic) NSArray *imgArray1;
@property(strong ,nonatomic) NSArray *textArray1;

@property(strong ,nonatomic) NSArray *imgArray2;
@property(strong ,nonatomic) NSArray *textArray2;
@property(strong ,nonatomic) UIView *operationView;
@property(strong ,nonatomic) walletModel *wallet;
@end

@implementation SCBTHDetailController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"管理");
    
    _bthTypeStr = @"隔离见证";
    
    [self subViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     _wallet = [[walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentOperationWalletID]]]]  lastObject];
    if(![_wallet.isSystem integerValue]) self.tableView.tableFooterView = self.operationView;
    [self.tableView reloadData];
}

- (void)subViews{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = SCGray(244);
    [self.view addSubview:_tableView];
}

- (UIView *)operationView
{
    if (!_operationView) {
        _operationView = [UIView new];
        _operationView.size = CGSizeMake(SCREEN_WIDTH, 48);
        _operationView.backgroundColor = [UIColor clearColor];
        
        UILabel *lab1 = [UILabel new];
        lab1.size = CGSizeMake(SCREEN_WIDTH, 48);
        lab1.x = 0;
        lab1.y = 10;
        lab1.text = LocalizedString(@"删除");
        lab1.textColor = SCColor(252, 102, 50);
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.font = kFont(15);
        lab1.backgroundColor = [UIColor whiteColor];
        [_operationView addSubview:lab1];
        
        WeakSelf(weakSelf);
        [lab1 setTapActionWithBlock:^{
            [weakSelf delectWallet];
        }];
        
    }
    return _operationView;
}

- (void)delectWallet
{
    [SCRootTool delectWalletWithID:_wallet.bg_id handle:^(BOOL result) {
        if(result)[self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        SCDailyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCDailyWalletCell"];
        if (!cell) {
            cell = [[SCDailyWalletCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCDailyWalletCell"];
        }
        cell.headImg.image = IMAGENAME(_wallet.portrait);
        cell.walletName.text = _wallet.name;
        cell.walletCode.text = _wallet.address;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    SCDailyFunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCDailyFunCell"];
    if (!cell) {
        cell = [[SCDailyFunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCDailyFunCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==1) {
        cell.funStr = self.textArray1[indexPath.row];
        cell.image = IMAGENAME(self.imgArray1[indexPath.row]);
        return cell;
    }
    if (indexPath.section==2) {
        if (indexPath.row==1) {
            SCBTHAddressCell *cell = [[SCBTHAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCBTHAddressCell"];
            cell.imgView.image = IMAGENAME(self.imgArray2[indexPath.row]);
            cell.addressLab.text = self.textArray2[indexPath.row];
            cell.typeLab.text = LocalizedString(_bthTypeStr);
            return cell;
        }
        cell.funStr = self.textArray2[indexPath.row];
        cell.image = IMAGENAME(self.imgArray2[indexPath.row]);
        return cell;
    }
    return [UITableViewCell new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return self.textArray1.count;
    }
    return self.textArray2.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return KWalletHeight;
    }
    if (indexPath.section==2&&indexPath.row==1) {
        return BTH_CELLHEIGHT;
    }
    return KFunHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) return 22;
    return 13;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]animated:YES];
    if (indexPath.section==0) {
        [self.navigationController pushViewController:[SCReplacePicController new] animated:YES];
    }
    
    if (indexPath.section==1) {
        NSString *selectStr = self.textArray1[indexPath.row];
        if ([selectStr isEqualToString:LocalizedString(@"密码提示信息")]) {
            [self.navigationController pushViewController:[SCPWPromptController new] animated:YES];
        }
        if ([selectStr isEqualToString:LocalizedString(@"导出助记词")]) {
            SCWalletEnterView *se = [SCWalletEnterView shareInstance];
            se.title = LocalizedString(@"请输入登录密码");
            se.placeholderStr = @"密码";
            [se setReturnTextBlock:^(NSString *showText) {
                SCDeriveWordsController *swc = [SCDeriveWordsController new];
                //解密
                NSString *ss = [AESCrypt decrypt:_wallet.mnemonics password:showText];
                if ([RewardHelper isBlankString:ss]) {
                    [TKCommonTools showToast:LocalizedString(@"密码错误")];
                    return ;
                }
                swc.text = ss;
                [self.navigationController pushViewController:swc animated:YES];
            }];
        }
        if ([selectStr isEqualToString:LocalizedString(@"导出私钥")]) {
            SCWalletEnterView *se = [SCWalletEnterView shareInstance];
            se.title = LocalizedString(@"请输入登录密码");
            se.placeholderStr = @"密码";
            [se setReturnTextBlock:^(NSString *showText) {
                //解密
                NSString *ss = [AESCrypt decrypt:_wallet.privateKey password:showText];
                if ([RewardHelper isBlankString:ss]) {
                    [TKCommonTools showToast:LocalizedString(@"密码错误")];
                    return ;
                }
                SCExpPriKController *sc = [SCExpPriKController new];
                NSString *priKey = ss;
                sc.prikey = priKey;
                [self.navigationController pushViewController:sc animated:YES];
       
            }];
        }
    }
    
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            //钱包地址
            SCBTHAddressController *sc = [SCBTHAddressController new];
            [self.navigationController pushViewController:sc animated:YES];
        }
        if (indexPath.row==1) {
            //切换地址类型
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [SCAlertCreater addActionTarget:alert titles:@[LocalizedString(@"隔离见证"),LocalizedString(@"普通")] color:SCColor(99, 154, 255) action:^(UIAlertAction * _Nonnull action) {
                if([action.title isEqualToString:LocalizedString(@"取消")])return ;
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_bthTypeStr = action.title;
                    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
                });
                SCLog(@"---- %@",action.title);
            }];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

//        私钥导入的钱包无助记词导出的
- (NSArray *)imgArray1
{
    if (!_imgArray1) {
        if (![RewardHelper isBlankString:_wallet.mnemonics]) {
            _imgArray1 = @[@"密码提示信息",@"导出助记词",@"导出私钥"];
            return _imgArray1;
        }
        _imgArray1 = @[@"密码提示信息",@"导出私钥"];
    }
    return _imgArray1;
}

- (NSArray *)textArray1
{
    if (!_textArray1) {
        if (![RewardHelper isBlankString:_wallet.mnemonics]) {
            _textArray1 = @[LocalizedString(@"密码提示信息"),LocalizedString(@"导出助记词"),LocalizedString(@"导出私钥")];
            return _textArray1;
        }
        _textArray1 = @[LocalizedString(@"密码提示信息"),LocalizedString(@"导出私钥")];
    }
    return _textArray1;
}

- (NSArray *)imgArray2
{
    if (!_imgArray2) {
        _imgArray2 = @[@"10.1_Wallet_address_icon",@"10.1_Switch_address_type_icon"];
    }
    return _imgArray2;
}

- (NSArray *)textArray2
{
    if (!_textArray2) {
        _textArray2 = @[LocalizedString(@"钱包地址"),LocalizedString(@"切换地址类型")];
    }
    return _textArray2;
}

@end
