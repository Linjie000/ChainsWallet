//
//  EOSDetailController.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSDetailController.h"
#import "SCReplacePicController.h"
#import "SCPWPromptController.h"
#import "EOSPermissionsController.h"
#import "SCExpPriKController.h"
#import "SCRootTool.h"
#import "SCDailyWalletCell.h"
#import "SCDailyFunCell.h"
#import "SCWalletEnterView.h"
#import "IOSTPermissionsController.h"
#import "IOSTResourceController.h"
#import "EOSResourceController.h"

#import "AESCrypt.h"

@interface EOSDetailController ()
<UITableViewDelegate,UITableViewDataSource>
@property(strong ,nonatomic) NSArray *imgArray;
@property(strong ,nonatomic) NSArray *textArray;
@property(strong ,nonatomic) walletModel *wallet;
@property(strong ,nonatomic) UIView *operationView;
@end

@implementation EOSDetailController

- (NSArray *)imgArray
{
    if (!_imgArray) {
        _imgArray = @[];
    }
    return _imgArray;
}

- (NSArray *)textArray
{
    if (!_textArray) {
        _textArray = @[];
    }
    return _textArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //不是获取当前的 因为多个钱包
    _wallet = [[walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentOperationWalletID]]]]  lastObject];
    
    _textArray = @[LocalizedString(@"资源管理"),LocalizedString(@"权限查看"),LocalizedString(@"导出私钥")];
    _imgArray = @[LocalizedString(@"密码提示信息"),LocalizedString(@"导出助记词"),LocalizedString(@"导出私钥")];
    if(![_wallet.isSystem integerValue]) self.tableView.tableFooterView = self.operationView;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"管理");
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
    return 2;
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
    if (indexPath.section==1) {
        SCDailyFunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCDailyFunCell"];
        if (!cell) {
            cell = [[SCDailyFunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCDailyFunCell"];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.funStr = self.textArray[indexPath.row];
        cell.image = IMAGENAME(self.imgArray[indexPath.row]);
        return cell;
    }
    return [UITableViewCell new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return self.textArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return KWalletHeight;
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
    NSString *selectStr = self.textArray[indexPath.row];
    if (indexPath.section==0) {
        [self.navigationController pushViewController:[SCReplacePicController new] animated:YES];
    }
    if (indexPath.section==1) {
        if ([selectStr isEqualToString:@"密码提示信息"]) {
            [self.navigationController pushViewController:[SCPWPromptController new] animated:YES];
            return;
        }
        if ([selectStr isEqualToString:LocalizedString(@"资源管理")]) {
            if (self.isIOSTPermissions) {
                IOSTResourceController *sc = [IOSTResourceController new];
                [self.navigationController pushViewController:sc animated:YES];
            }
            else
            {
                EOSResourceController *rc = [[EOSResourceController alloc]init];
                [self.navigationController pushViewController:rc animated:YES];
            }
            return;
        }
        if ([selectStr isEqualToString:LocalizedString(@"权限查看")]) {
            if (self.isIOSTPermissions) {
                IOSTPermissionsController *sc = [IOSTPermissionsController new];
                [self.navigationController pushViewController:sc animated:YES];
            }else
            {
                EOSPermissionsController *sc = [EOSPermissionsController new];
                [self.navigationController pushViewController:sc animated:YES];
            }
            return;
        }
        SCWalletEnterView *se = [SCWalletEnterView shareInstance];
        se.title = LocalizedString(@"请输入密码");
        se.placeholderStr = @"密码";
        [se setReturnTextBlock:^(NSString *showText) {
            walletModel *wallet = [[walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentOperationWalletID]]]]  lastObject];
            if ([selectStr isEqualToString:LocalizedString(@"导出私钥")]) {
                NSString *privateKey = [AESCrypt decrypt:wallet.privateKey password:showText];
                if ([RewardHelper isBlankString:privateKey]) {
                    [TKCommonTools showToast:LocalizedString(@"密码错误")];
                    return ;
                }
                SCExpPriKController *priKvc = [SCExpPriKController new];
                priKvc.prikey = privateKey;
                [self.navigationController pushViewController:priKvc animated:YES];
            }
        }];
    }
}

@end
