//
//  TRXDetailController.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/18.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "TRXDetailController.h"
#import "SCDailyWalletCell.h"
#import "SCDailyFunCell.h"
#import "SCReplacePicController.h"
#import "SCWalletEnterView.h"
#import "SCExpPriKController.h"
#import "SCDeriveWordsController.h"
#import "SCPWPromptController.h"
#import "SCRootTool.h"
#import "TWHexConvert.h"
#import "AESCrypt.h"

@interface TRXDetailController ()
<UITableViewDelegate,UITableViewDataSource>
@property(strong ,nonatomic) NSArray *imgArray;
@property(strong ,nonatomic) NSArray *textArray;
@property(strong ,nonatomic) walletModel *wallet;
@property(strong ,nonatomic) UIView *operationView;
@end

@implementation TRXDetailController

- (NSArray *)imgArray
{
    if (!_imgArray) {
        _imgArray = @[@"密码提示信息",@"导出私钥"];
    }
    return _imgArray;
}

- (NSArray *)textArray
{
    if (!_textArray) {
        _textArray = @[@"密码提示信息",@"导出私钥"];
    }
    return _textArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"管理");
    [self subViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _wallet = [[walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentOperationWalletID]]]]  lastObject];
    [self.tableView reloadData];
    if(![_wallet.isSystem integerValue]) self.tableView.tableFooterView = self.operationView;
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
    if (indexPath.section==0) {
    
        [self.navigationController pushViewController:[SCReplacePicController new] animated:YES];
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            [self.navigationController pushViewController:[SCPWPromptController new] animated:YES];
        }
        if (indexPath.row==1) {
            SCWalletEnterView *se = [SCWalletEnterView shareInstance];
            se.title = LocalizedString(@"请输入密码");
            se.placeholderStr = @"密码";
            [se setReturnTextBlock:^(NSString *showText) {
                //找出那个波场钱包
                
                NSString *privateKey = [AESCrypt decrypt:self.wallet.privateKey password:showText];
                if ([RewardHelper isBlankString:privateKey]) {
                    [TKCommonTools showToast:LocalizedString(@"密码错误")];
                    return ;
                }
                SCExpPriKController *sc = [SCExpPriKController new];
                sc.prikey = privateKey;
                [self.navigationController pushViewController:sc animated:YES];
            }];
   
        }
 
    }
}

@end
