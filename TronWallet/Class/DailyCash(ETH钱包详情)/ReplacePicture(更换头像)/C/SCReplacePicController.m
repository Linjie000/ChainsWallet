//
//  SCReplacePicController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/7.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCReplacePicController.h"
#import "SCReplacePicView.h"
#import "SCWalletEnterView.h"

#define HEIGHT 50
#define marginX 15

@interface SCReplacePicController ()<SCReplacePicViewDelegate>
@property(strong, nonatomic) UIView *replacePicView;
@property(strong, nonatomic) UIView *replaceWalletView;
@property(strong, nonatomic) UIImageView *headImgView;
@property(strong, nonatomic) UILabel *walletNameLab;

@property(strong ,nonatomic) walletModel *wallet;
@end

@implementation SCReplacePicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SCGray(242);
    [self subViews];

    self.title = LocalizedString(@"钱包详情");
    
    self.wallet = [UserinfoModel shareManage].wallet;
    
    self.headImg = IMAGENAME(self.wallet.portrait);
    self.walletName = self.wallet.name;
}

- (void)setHeadImg:(UIImage *)headImg
{
    _headImg = headImg;
    _headImgView.image = headImg;
}

- (void)setWalletName:(NSString *)walletName
{
    _walletName = walletName;
    _walletNameLab.text = walletName;
}

- (void)subViews{
    
    UIView *bgView = [UIView new];
    bgView.size = CGSizeMake(SCREEN_WIDTH, 2*HEIGHT);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.top = 20;
    [self.view addSubview:bgView];
    
    [bgView addSubview:self.replacePicView];
    [bgView addSubview:self.replaceWalletView];
    
    self.replacePicView.y = 0;
    self.replaceWalletView.y = self.replacePicView.bottom;
    
    UIView *line = [RewardHelper addLine2];
    line.x = 0;
    line.bottom = self.replacePicView.bottom;
    [bgView addSubview:line];
    
    _headImgView = [UIImageView new];
    _headImgView.size = CGSizeMake(HEIGHT-15, HEIGHT-15);
    _headImgView.right = SCREEN_WIDTH - 15;
    _headImgView.centerY = self.replacePicView.centerY;
    _headImgView.layer.borderColor = SCGray(220).CGColor;
    _headImgView.layer.borderWidth = 0.5;
    _headImgView.layer.cornerRadius = 4;
    _headImgView.clipsToBounds = YES;
//    _headImgView.image = IMAGENAME(@"葡萄");
    
    _walletNameLab = [UILabel new];
    _walletNameLab.size = CGSizeMake(200, HEIGHT);
    _walletNameLab.right = SCREEN_WIDTH-15;
    _walletNameLab.centerY = self.replaceWalletView.centerY;
    _walletNameLab.font = kPFFont(14);
//    _walletNameLab.text = @"BAT-Wallet";
    _walletNameLab.textAlignment = NSTextAlignmentRight;
    
    [bgView addSubview:_headImgView];
    [bgView addSubview:_walletNameLab];
    
    WeakSelf(weakSelf);
    [self.replacePicView setTapActionWithBlock:^{
        [weakSelf replacePic];
    }];
 
    [self.replaceWalletView setTapActionWithBlock:^{
        SCWalletEnterView *sn = [SCWalletEnterView shareInstance];
        sn.title = @"更换钱包名";
        sn.placeholderStr = @"钱包名";
        [sn setReturnTextBlock:^(NSString * showText) {
            weakSelf.walletNameLab.text = showText;
            weakSelf.wallet.name = showText;

            [weakSelf.wallet bg_cover];
            [UserinfoModel shareManage].wallet = weakSelf.wallet;
        }];
    }];
}

- (UIView *)replacePicView
{
    if (!_replacePicView) {
        _replacePicView = [UIView new];
        _replacePicView.size = CGSizeMake(SCREEN_WIDTH, HEIGHT);
        _replacePicView.x = marginX;
        UIImageView *headimg = [UIImageView new];
        headimg.size = CGSizeMake(19, 20);
        headimg.centerY = _replacePicView.height/2;
        headimg.image = IMAGENAME(@"更换头像");
        [self.view addSubview:headimg];
        [_replacePicView addSubview:headimg];
        
        UILabel *lab = [UILabel new];
        lab.size = CGSizeMake(100, HEIGHT);
        lab.centerY = _replacePicView.height/2;
        lab.left = headimg.right+20;
        lab.font = kFont(14);
        lab.text = LocalizedString(@"更换头像");
        [_replacePicView addSubview:lab];
    }
    return _replacePicView;
}

- (UIView *)replaceWalletView
{
    if (!_replaceWalletView) {
        _replaceWalletView = [UIView new];
        _replaceWalletView.size = CGSizeMake(SCREEN_WIDTH, HEIGHT);
        _replaceWalletView.x = marginX;
        UIImageView *headimg = [UIImageView new];
        headimg.size = CGSizeMake(20, 18);
        headimg.centerY = _replaceWalletView.height/2;
        headimg.image = IMAGENAME(@"更换钱包名");
        [self.view addSubview:headimg];
        [_replaceWalletView addSubview:headimg];
        
        UILabel *lab = [UILabel new];
        lab.size = CGSizeMake(100, HEIGHT);
        lab.centerY = _replaceWalletView.height/2;
        lab.left = headimg.right+20;
        lab.font = kFont(14);
        lab.text = LocalizedString(@"更换钱包名");
        [_replaceWalletView addSubview:lab];
    }
    return _replaceWalletView;
}

#pragma mark - 更换头像
- (void)replacePic
{
    SCReplacePicView *pic = [SCReplacePicView new];
    pic.delegate = self;
    [KeyWindow addSubview:pic];
}
//获得头像
- (void)SCReplacePicImage:(NSString *)imgName
{
    _headImgView.image = IMAGENAME(imgName);
    self.wallet.portrait = imgName;
    [self.wallet bg_cover];
    
    [UserinfoModel shareManage].wallet = self.wallet;
}


@end
