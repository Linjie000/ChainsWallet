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

#import "SCReplacePicController.h"
#import "SCPWPromptController.h"
#import "SCDeriveWordsController.h"
#import "SCBTHAddressController.h"

@interface SCBTHDetailController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_bthTypeStr;//隔离见证 普通
}
@property(strong ,nonatomic) NSArray *imgArray1;
@property(strong ,nonatomic) NSArray *textArray1;

@property(strong ,nonatomic) NSArray *imgArray2;
@property(strong ,nonatomic) NSArray *textArray2;
@end

@implementation SCBTHDetailController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"管理");
    
    _bthTypeStr = @"隔离见证";
    
    [self subViews];
}

- (void)subViews{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = SCGray(244);
    [self.view addSubview:_tableView];
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
    return 2;
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
        if (indexPath.row==0) {
            [self.navigationController pushViewController:[SCPWPromptController new] animated:YES];
        }
        if (indexPath.row==1) {
            SCWalletEnterView *se = [SCWalletEnterView shareInstance];
            se.title = LocalizedString(@"请输入登录密码");
            se.placeholderStr = @"密码";
            [se setReturnTextBlock:^(NSString *showText) {
                [self.navigationController pushViewController:[SCDeriveWordsController new] animated:YES];
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

- (NSArray *)imgArray1
{
    if (!_imgArray1) {
        _imgArray1 = @[LocalizedString(@"密码提示信息"),LocalizedString(@"导出助记词")];
    }
    return _imgArray1;
}

- (NSArray *)textArray1
{
    if (!_textArray1) {
        _textArray1 = @[LocalizedString(@"密码提示信息"),LocalizedString(@"导出助记词")];
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
