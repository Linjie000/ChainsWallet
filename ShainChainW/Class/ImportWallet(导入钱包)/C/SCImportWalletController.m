//
//  SCImportWalletController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/18.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCImportWalletController.h"
#import "SCCustomHeadView.h"

#import "SCImportETHController.h"
#import "SCImportBITController.h"
#import "SCImportEOSController.h"
#import "ImportTronPriKeyController.h"
#import "ImportIOSTController.h"
#import "ImportATOMController.h"

@interface SCImportWalletController ()

@end

@implementation SCImportWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self subViews];
}

- (void)subViews
{
    SCCustomHeadView *headv = [SCCustomHeadView new];
    headv.leftBtnImg.size = CGSizeMake(8, 14);
    [self.view addSubview:headv];
    
    UILabel *titlelab = [UILabel new];
    titlelab.width = SCREEN_WIDTH;
    titlelab.height = 40;
    titlelab.top = SCREEN_ADJUST_HEIGHT(80);
    titlelab.font = kPFFont(24);
    titlelab.textAlignment = NSTextAlignmentCenter;
    titlelab.text = LocalizedString(@"选择钱包类型");
    [self.view addSubview:titlelab];
    WeakSelf(weakSelf);
    NSArray *textarr = @[@"以太坊钱包",@"比特币钱包",@"EOS钱包",@"波场钱包",@"IOST钱包",@"IOST钱包"];
    NSArray *imgarr = @[@"9.3以太坊钱包",@"BTC",@"9.3EOS钱包",@"TRX",@"IOST",@"ATOM"];
    for (int i=0 ;i<textarr.count;i++) {
        YYControl *view = [self createWalletType:textarr[i] coinImg:IMAGENAME(imgarr[i])];
        view.centerX = SCREEN_WIDTH/2;
        view.top = i*20+i*view.height+SCREEN_ADJUST_HEIGHT(55)+titlelab.bottom;
        [self.view addSubview:view];
        view.tag = 100+i;
        view.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            if (state==YYGestureRecognizerStateEnded) {
                [weakSelf importWalletType:view.tag-100];
            }
        };
    }
}

#pragma mark - 选择钱包类型后
- (void)importWalletType:(NSInteger)tag
{
    //0 1 2   取数组下标再判断
    if (tag==0) {
        SCImportETHController *ec = [SCImportETHController new];
        [self.navigationController pushViewController:ec animated:YES];
    }
    if (tag==1) {
        SCImportBITController *bc = [SCImportBITController new];
        [self.navigationController pushViewController:bc animated:YES];
    }
    if (tag==2) {
        SCImportEOSController *ec = [SCImportEOSController new];
        [self.navigationController pushViewController:ec animated:YES];
    }
    if (tag==3) {
        ImportTronPriKeyController *ec = [ImportTronPriKeyController new];
        [self.navigationController pushViewController:ec animated:YES];
    }
    if (tag==4) {
        ImportIOSTController *ec = [ImportIOSTController new];
        [self.navigationController pushViewController:ec animated:YES];
    }
    if (tag==5) {
        ImportATOMController *ec = [ImportATOMController new];
        [self.navigationController pushViewController:ec animated:YES];
    }
}

- (YYControl *)createWalletType:(NSString *)type coinImg:(UIImage *)img
{
    YYControl *coinView = [YYControl new];
    coinView.size = CGSizeMake(SCREEN_WIDTH-61, 71);
    coinView.layer.cornerRadius = 5;
    coinView.clipsToBounds = YES;
    coinView.backgroundColor = SCGray(242);
    
    UIImageView *coinimg = [UIImageView new];
    coinimg.size = CGSizeMake(28, 28);
    coinimg.layer.cornerRadius = coinimg.width/2;
    coinimg.clipsToBounds = YES;
    coinimg.centerX = coinView.width/2;
    coinimg.bottom = coinView.height/2+4;
    coinimg.image = img;
    [coinView addSubview:coinimg];
    
    UILabel *coinLab = [UILabel new];
    coinLab.width = coinView.width;
    coinLab.height = 25;
    coinLab.x = 0;
    coinLab.font = kPFFont(14);
    coinLab.top = coinView.height/2+6;
    coinLab.textAlignment = NSTextAlignmentCenter;
    coinLab.text = type;
    coinLab.textColor = SCTEXTCOLOR;
    [coinView addSubview:coinLab];
    
    return coinView;
}


@end
