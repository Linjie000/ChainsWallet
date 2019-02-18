//
//  TRXPropertyHeadView.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/18.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "TRXPropertyHeadView.h"

@interface TRXPropertyHeadView ()
@property (nonatomic,strong) UILabel *currentPriceLab; //顶部价格
@property (nonatomic,strong) UILabel *exchangeLab; //约兑换多少钱


@property (nonatomic,strong) UIView *availableView; //可用余额
@property (nonatomic,strong) UIView *freezeView; //冻结
@property (nonatomic,strong) UILabel *availableLab; //可用余额
@property (nonatomic,strong) UILabel *freezeLab; //冻结
@end

@implementation TRXPropertyHeadView

- (instancetype)init
{
    if (self = [super init]) {
        self.height = 200;
        self.width = SCREEN_WIDTH;
        self.backgroundColor = [UIColor whiteColor];
 
        
        [self addDetailViews];
    }
    return self;
}

- (void)setModel:(coinModel *)model
{
    _model = model;
  
    _currentPriceLab.text = [NSString stringWithFormat:@"%.4f",[model.closePrice floatValue] ];
    _exchangeLab.text = [NSString stringWithFormat:@"≈¥%.2f",[model.closePrice floatValue]*[model.totalAmount floatValue] ];
    _availableLab.text = model.totalAmount;
    
    
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    
    NSArray *arr = wallet.tronClient.account.frozenArray;
    if (arr.count) {
        Account_Frozen *accountfrozen = arr[0];
        NSString *s = [NSString stringWithFormat:@"%.4lld",accountfrozen.frozenBalance];
        _freezeLab.text = [NSString stringWithFormat:@"%.4f",[s floatValue]/kDense];
    }

}

- (void)addDetailViews
{
    [self addSubview:self.currentPriceLab];
    [self addSubview:self.exchangeLab];
    
    [self addSubview:self.availableView];
    self.availableView.x = 0;
    self.availableView.top = self.exchangeLab.bottom+30;
    
    [self addSubview:self.freezeView];
    self.freezeView.x = SCREEN_WIDTH/2;
    self.freezeView.top = self.exchangeLab.bottom+30;
 
}

- (UILabel *)currentPriceLab
{
    if (!_currentPriceLab) {
        _currentPriceLab = [UILabel new];
        _currentPriceLab.width = SCREEN_WIDTH;
        _currentPriceLab.height = 39;
        _currentPriceLab.font = kHelBoldFont(30);
        _currentPriceLab.textAlignment = NSTextAlignmentCenter;
        _currentPriceLab.x = 0;
        _currentPriceLab.y = 30;
    }
    return _currentPriceLab;
}

- (UILabel *)exchangeLab
{
    if (!_exchangeLab) {
        _exchangeLab = [UILabel new];
        _exchangeLab.width = SCREEN_WIDTH;
        _exchangeLab.height = 17;
        _exchangeLab.font = kPFFont(13);
        _exchangeLab.textAlignment = NSTextAlignmentCenter;
        _exchangeLab.textColor = SCGray(128);
        _exchangeLab.x = 0;
        _exchangeLab.top = self.currentPriceLab.bottom;
    }
    return _exchangeLab;
}

- (UIView *)availableView
{
    if (!_availableView) {
        _availableView = [UIView new];
        _availableView.size = CGSizeMake(SCREEN_WIDTH/2, 40);
        UILabel *alab = [UILabel new];
        alab.size = CGSizeMake(_availableView.width, _availableView.height/2);
        alab.x = alab.y = 0;
        alab.textAlignment = NSTextAlignmentCenter;
        alab.font = kBoldFont(17);
//        alab.text = @"96.200001";
        _availableLab = alab;
        [_availableView addSubview:alab];
        
        UILabel *tlab = [UILabel new];
        tlab.size = CGSizeMake(_availableView.width, _availableView.height/2);
        tlab.x = 0;
        tlab.y = alab.bottom;
        tlab.textAlignment = NSTextAlignmentCenter;
        tlab.font = kPFFont(13);
        tlab.text = @"可用余额";
        [_availableView addSubview:tlab];
    }
    return _availableView;
}

- (UIView *)freezeView
{
    if (!_freezeView) {
        _freezeView = [UIView new];
        _freezeView.size = CGSizeMake(SCREEN_WIDTH/2, 40);
        UILabel *alab = [UILabel new];
        alab.size = CGSizeMake(_freezeView.width, _freezeView.height/2);
        alab.x = alab.y = 0;
        alab.textAlignment = NSTextAlignmentCenter;
        alab.font = kBoldFont(17);
        _freezeLab = alab;
        [_freezeView addSubview:alab];
        
        UILabel *tlab = [UILabel new];
        tlab.size = CGSizeMake(_freezeView.width, _freezeView.height/2);
        tlab.x = 0;
        tlab.y = alab.bottom;
        tlab.textAlignment = NSTextAlignmentCenter;
        tlab.font = kPFFont(13);
        tlab.text = @"冻结";
        [_freezeView addSubview:tlab];
    }
    return _freezeView;
}


@end
