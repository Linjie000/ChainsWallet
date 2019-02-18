//
//  FirstViewController.m
//  SCWallet
//
//  Created by zaker_sink on 2018/12/7.
//  Copyright © 2018 zaker_sink. All rights reserved.
//

#import "WalletViewController.h"
#import "SCLeftNavView.h"
#import "SCWalletView.h"
#import "Colours.h"
#import "SCPropertyTableView.h"
#import "SCGuideOneView.h"
#import "SCScanController.h"
#import "SCPropertyHead.h"
#import "SCDailyWalletController.h"
#import "SCDailyWalletExistCell.h"
#import "SCAddAssetController.h"
#import "SCPropertyOPController.h"
#import "WalletNavViewController.h"
#import "TRXClient.h"

@interface WalletViewController ()<SCPropertyTableViewDelegate>

@property (strong, nonatomic) SCPropertyTableView *propertyTableView;
@property (strong, nonatomic) SCLeftNavView* leftView;
@property (strong, nonatomic) SCPropertyHead *propertyHead;
@property (strong, nonatomic) NSMutableArray *dataArray; 
@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"钱包";
    
    [self setUpNaviBtn];
    
    [self subViews];
    
    [self addNotification];
    
    
//    [KeyWindow addSubview:[SCGuideOneView new]];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadWallet];
}

- (void)loadWallet
{
    if ([[walletModel bg_findAll:nil] count]>0) {
        //有钱包
        
        walletModel*wallet= [[walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]] lastObject];
        if (!wallet) {
            walletModel*model=[[walletModel bg_findAll:nil] objectAtIndex:0];
            [UserinfoModel shareManage].wallet=model;
            [NSUserDefaultUtil PutNumberDefaults:CurrentWalletID Value:model.bg_id];//存储到本地
            wallet = model;
        }else{
            [UserinfoModel shareManage].wallet=wallet;
        }
        if ([wallet.ID isEqualToNumber:@(195)]) {
            _leftView.walletType = @"TRX";
            
            [wallet.tronClient refreshAccount:^(TronAccount *account, NSError *error) {

            }];
        }
    }
}

#pragma mark - 设置导航栏按钮
- (void)setUpNaviBtn{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"扫一扫-icon"]  style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];

    self.navigationItem.rightBarButtonItems = @[rightItem];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    SCLeftNavView* leftView =  [[SCLeftNavView alloc] initWithFrame:CGRectMake(0, 0, 60, 26)];
    [leftView layout];
    _leftView = leftView;
    WeakSelf(weakSelf);
    [_leftView setTapActionWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf leftClick];
        });
    }];
    leftView.walletType = @" ";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItems = @[leftItem];
}

- (void)chooseDailyWallet
{
    SCDailyWalletController *dwc = [SCDailyWalletController new];
    dwc.canPost = YES;
    [dwc setBlock:^(SCDailyWalletExistCell * _Nonnull cell) {
        self.leftView.walletType = cell.typeLab.text;
//        self.propertyHead.
        
    }];
 
    WalletNavViewController *navi = [[WalletNavViewController alloc]initWithRootViewController:dwc];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)subViews{
    [self.view addSubview:self.propertyTableView];
    self.propertyHead = [SCPropertyHead shareInstance];
    self.propertyTableView.tableHeaderView = self.propertyHead;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
}

#pragma mark - 添加通知
- (void)addNotification
{
    WeakSelf(weakSelf);
    [self addNotificationForName:KEY_SCWALLET_ADDASSET response:^(NSDictionary * _Nonnull userInfo) {
        SCAddAssetController *sc = [SCAddAssetController new];
        [weakSelf.navigationController pushViewController:sc animated:YES];
    }];
    [self addNotificationForName:kAccountUpdateNotification response:^(NSDictionary * _Nonnull userInfo) {
        TronAccount *account = [userInfo objectForKey:@"Account"];
        //查找 TRX 币
        NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"TRX"]]];
        coinModel *model = [arr lastObject];
        //更新数据
        model.totalAmount = [NSString stringWithFormat:@"%.4f",(account.balance/kDense)];
 
        //查询TRX兑人民汇率
        [TRXClient getExchangeRates:@"cny" success:^(id  _Nonnull responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSString *close = [dic objectForKey:@"close"];
            model.closePrice = close;
            [model bg_cover];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf TotalassetsCalculatedWithWallet:[UserinfoModel shareManage].wallet withtype:0];
                //更新coinmodel数据
                [weakSelf postNotificationForName:kcoinModelUpdateNotification userInfo:@{}];
            });
        }];
    }];
}

-(void)rightClick{
    [self.navigationController pushViewController:[SCScanController new] animated:YES];
}

-(void)leftClick{
    [self chooseDailyWallet];
}

#pragma mark--计算总资产
-(void)TotalassetsCalculatedWithWallet:(walletModel*)wallet withtype:(int)type{
 
    [SCPropertyHead shareInstance].wallet = wallet;
    self.dataArray=(NSMutableArray*)[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id],[NSObject bg_sqlKey:@"collect"],[NSObject bg_sqlValue:@(1)]]];
    self.propertyTableView.dataArray = self.dataArray;
    
}

#pragma make - SCPropertyTableViewDelegate
- (void)propertySeleteTableView:(coinModel *)model
{
    SCPropertyOPController *sc = [SCPropertyOPController new];
    sc.brand = model.brand;
    [self.navigationController pushViewController:sc animated:YES];
}

#pragma make - lazyload
- (SCPropertyTableView *)propertyTableView
{
    if (!_propertyTableView) {
        _propertyTableView = [[SCPropertyTableView alloc]initWithFrame:
                              CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT)
                                                                 style:UITableViewStylePlain];
        _propertyTableView.propertyDelegate = self;
        _propertyTableView.separatorStyle = 0;
        _propertyTableView.tableFooterView = [UIView new];
    }
    return _propertyTableView;
}

@end
