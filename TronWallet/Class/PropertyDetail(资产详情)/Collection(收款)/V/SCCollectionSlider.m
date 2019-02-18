//
//  SCCollectionSlider.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCCollectionSlider.h"

@interface SCCollectionSlider ()
{
    UIView *_bgView;
    UILabel *_mainLab;
    UILabel *_minorLab;
    UIView *_scrollBG;
    
    BOOL _mainAddress;
}
@end

@implementation SCCollectionSlider

- (instancetype)init
{
    if (self = [super init]) {
        _mainAddress = YES;
        self.width = 140;
        self.height = 33;
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    UIView *bgView = [UIView new];
    bgView.size = CGSizeMake(133, 24);
    bgView.layer.cornerRadius = bgView.height/2;
    bgView.clipsToBounds = YES;
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    bgView.center = CGPointMake(self.width/2, self.height/2);
    _bgView = bgView;
    [self addSubview:bgView];
    
    _scrollBG = [UIView new];
    _scrollBG.backgroundColor = [UIColor whiteColor];
    _scrollBG.size = CGSizeMake(bgView.width/2, bgView.height);
    _scrollBG.x = _scrollBG.y = 0;
    _scrollBG.layer.cornerRadius = bgView.height/2;
    _scrollBG.clipsToBounds = YES;
    [bgView addSubview:_scrollBG];
    
    WeakSelf(weakSelf);
    _mainLab = [UILabel new];
    _mainLab.size = CGSizeMake(bgView.width/2, bgView.height);
    _mainLab.x = _mainLab.y = 0;
    _mainLab.textAlignment = NSTextAlignmentCenter;
    _mainLab.textColor = MainColor;
    _mainLab.font = kFont(15);
    [bgView addSubview:_mainLab];
    _mainLab.text = LocalizedString(@"主地址");
    [_mainLab setTapActionWithBlock:^{
        [weakSelf mainAddress];
    }];
    
    _minorLab = [UILabel new];
    _minorLab.size = CGSizeMake(bgView.width/2, bgView.height);
    _minorLab.y = 0;
    _minorLab.font = kFont(15);
    _minorLab.x = bgView.width/2;
    _minorLab.textAlignment = NSTextAlignmentCenter;
    _minorLab.textColor = [UIColor whiteColor];
    _minorLab.text = LocalizedString(@"次地址");
    [bgView addSubview:_minorLab];
    [_minorLab setTapActionWithBlock:^{
        [weakSelf mainorAddrss];
    }];
    
}

- (void)mainAddress
{
    if (_mainAddress) {
        return;
    }
    _mainLab.textColor = MainColor;
    _minorLab.textColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.3 animations:^{
        _scrollBG.centerX = _bgView.width/4;
    }];
    _mainAddress = !_mainAddress;
}

- (void)mainorAddrss
{
    if (!_mainAddress) {
        return;
    }
    _mainLab.textColor = [UIColor whiteColor];
    _minorLab.textColor = MainColor;
    [UIView animateWithDuration:0.3 animations:^{
        _scrollBG.centerX = _bgView.width/4+_bgView.width/2;
    }];
    _mainAddress = !_mainAddress;
}

@end
