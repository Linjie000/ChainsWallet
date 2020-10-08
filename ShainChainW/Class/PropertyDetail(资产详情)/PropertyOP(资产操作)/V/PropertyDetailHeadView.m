//
//  PropertyDetailHeadView.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/10.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "PropertyDetailHeadView.h"

#define marginX 15

#define marginX2 16

@interface PropertyDetailHeadView ()
{
    CGRect _initialFrame;
}
@property (strong, nonatomic) UIView *headBgView;
@end

@implementation PropertyDetailHeadView

- (UIView *)headBgView
{
    if (!_headBgView) {
        CGFloat cornerRadius = 9.0;
        _headBgView = [[UIView alloc]init];
        _headBgView.width = SCREEN_WIDTH-2*marginX;
        _headBgView.x = marginX;
        _headBgView.height = 130;
        _headBgView.layer.shadowColor = [UIColor blackColor].CGColor;
        _headBgView.layer.shadowOffset = CGSizeMake(0, 2);
        _headBgView.layer.shadowOpacity = 0.1;
        _headBgView.layer.shadowRadius = cornerRadius;
        _headBgView.layer.cornerRadius = cornerRadius;
        _headBgView.clipsToBounds = NO;
        UIView *view = [[UIView alloc]initWithFrame:_headBgView.bounds];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = cornerRadius;
        view.clipsToBounds = YES;
        [_headBgView addSubview:view];
    }
    return _headBgView;
}

- (UILabel *)currentPriceLab
{
    if (!_currentPriceLab) {
        _currentPriceLab = [UILabel new];
        _currentPriceLab.width = 200;
        _currentPriceLab.height = 38;
        _currentPriceLab.font = kDINMedium(20);
        _currentPriceLab.text = @"0.000";
        _currentPriceLab.x = marginX2;
        _currentPriceLab.y = 4;
    }
    return _currentPriceLab;
}

- (UILabel *)blanceLab
{
    if (!_blanceLab) {
        _blanceLab = [UILabel new];
        _blanceLab.width = 200;
        _blanceLab.height = 38;
        _blanceLab.font = kDINMedium(20);
        _blanceLab.text = @"0.000";
        _blanceLab.x = marginX2;
 
    }
    return _blanceLab;
}

- (UILabel *)currenttitleLab
{
    if (!_currenttitleLab) {
        _currenttitleLab = [UILabel new];
        _currenttitleLab.width = 200;
        _currenttitleLab.height = 15;
        _currenttitleLab.font = kFont(12);
        _currenttitleLab.text = LocalizedString(@"当前价格 Hobi");
        _currenttitleLab.x = marginX2;
        _currenttitleLab.textColor = SCGray(128);
    }
    return _currenttitleLab;
}

- (UILabel *)blancetitleLab
{
    if (!_blancetitleLab) {
        _blancetitleLab = [UILabel new];
        _blancetitleLab.width = 200;
        _blancetitleLab.height = 15;
        _blancetitleLab.font = kFont(12);
        _blancetitleLab.text = LocalizedString(@"资产");
        _blancetitleLab.x = marginX2;
        _blancetitleLab.textColor = SCGray(128);
    }
    return _blancetitleLab;
}

- (UILabel *)titleLab1
{
    if (!_titleLab1) {
        _titleLab1 = [UILabel new];
        _titleLab1.width = 60;
        _titleLab1.height = 15;
        _titleLab1.font = kFont(12);
        _titleLab1.right = self.headBgView.width - marginX2;
        _titleLab1.textColor = SCGray(128);
        _titleLab1.textAlignment = NSTextAlignmentRight;
    }
    return _titleLab1;
}

- (UILabel *)titleLab2
{
    if (!_titleLab2) {
        _titleLab2 = [UILabel new];
        _titleLab2.width = 60;
        _titleLab2.height = 15;
        _titleLab2.font = kFont(12);
        _titleLab2.right = self.headBgView.width - marginX2;
        _titleLab2.textColor = SCGray(128);
        _titleLab2.textAlignment = NSTextAlignmentRight;
    }
    return _titleLab2;
}

- (UILabel *)valueLab1
{
    if (!_valueLab1) {
        _valueLab1 = [UILabel new];
        _valueLab1.width = 100;
        _valueLab1.height = 30;
        _valueLab1.font = kFont(15);
        _valueLab1.right = self.headBgView.width - marginX2;
        _valueLab1.textAlignment = NSTextAlignmentRight;
    }
    return _valueLab1;
}

- (UILabel *)valueLab2
{
    if (!_valueLab2) {
        _valueLab2 = [UILabel new];
        _valueLab2.width = 100;
        _valueLab2.height = 30;
        _valueLab2.font = kFont(15);
        _valueLab2.right = self.headBgView.width - marginX2;
        _valueLab2.textAlignment = NSTextAlignmentRight;
    }
    return _valueLab2;
}
 
- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = 190;
        self.backgroundColor = [UIColor whiteColor];
        [self subViews];
         
    }
    return self;
}

- (void)subViews
{
    UIView *blueview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height*0.6)];
    blueview.backgroundColor = MainColor;
    self.colorBgView = blueview;
    _initialFrame = blueview.frame;
    [self addSubview:blueview];
    
    [self addSubview:self.headBgView];
    self.headBgView.centerY = self.height/2;
    
    [self.headBgView addSubview:self.currenttitleLab];
    [self.headBgView addSubview:self.currentPriceLab];
    [self.headBgView addSubview:self.blancetitleLab];
    [self.headBgView addSubview:self.blanceLab];
    
    [self.headBgView addSubview:self.titleLab1];
    [self.headBgView addSubview:self.valueLab1];
    [self.headBgView addSubview:self.titleLab2];
    [self.headBgView addSubview:self.valueLab2];
 
    self.currenttitleLab.top = 16;
    self.currentPriceLab.top = self.currenttitleLab.bottom;
    self.blancetitleLab.top = self.currentPriceLab.bottom;
    self.blanceLab.top = self.blancetitleLab.bottom;
    
    self.titleLab1.top = self.currenttitleLab.top+10;
    self.valueLab1.top = self.titleLab1.bottom;
    
    self.titleLab2.top = self.valueLab1.bottom;
    self.valueLab2.top = self.titleLab2.bottom;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect f = self.colorBgView.frame;
    f.size.width = SCREEN_WIDTH;
    self.colorBgView.frame = f;
    
    if(scrollView.contentOffset.y < 0) {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        _initialFrame.origin.y = offsetY * -1;
        _initialFrame.size.height = self.height*0.6 + offsetY;
        self.colorBgView.frame = _initialFrame;
    }
}

@end
