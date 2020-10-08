//
//  SCShareWalletView.m
//  ShainChainW
//
//  Created by 闪链 on 2019/8/2.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCShareWalletView.h"
#import "SCShareWayView.h"
#import "SCOutShareView.h"
@interface SCShareWalletView ()
<SCShareWayViewDelegate>
@property (strong, nonatomic) UIView *bgView; 
@property (strong, nonatomic) SCShareWayView *wayView;
@property (strong, nonatomic) SCOutShareView *shareView;
@end

@implementation SCShareWalletView

+ (instancetype)shareInstance
{
    static SCShareWalletView *enterv = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        enterv = [[SCShareWalletView alloc]init];
    });
    [KeyWindow addSubview:enterv];
    return enterv;
}

- (SCOutShareView *)shareView
{
    if (!_shareView) {
        _shareView = [SCOutShareView new];
        _shareView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _shareView;
}

- (UIImageView *)shareViewImg
{
    if (!_shareViewImg) {
        _shareViewImg = [UIImageView new];
        _shareViewImg.size = CGSizeMake(SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.8);
        _shareViewImg.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        _shareViewImg.alpha = 0;
        _shareViewImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _shareViewImg;
}

- (void)setModel:(BSJButtomsModel *)model
{
    _model = model;
    self.shareView.model = model;
    [self makeImageWithView:self.shareView withSize:self.shareView.size];
}

- (void)setSearchModel:(BSJSearchExpressModel *)searchModel
{
    _searchModel = searchModel;
    
}

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = SCREEN_HEIGHT;
        [self subViews];
        [KeyWindow addSubview:self];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
 
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5 options:0 animations:^{
        _wayView.bottom = SCREEN_HEIGHT+50;
        _bgView.alpha = 0.3;
        self.shareViewImg.alpha=0;
    } completion:^(BOOL finished) {

    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.1 animations:^{
        _wayView.top = SCREEN_HEIGHT;
        _bgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)subViews
{
    WeakSelf(weakSelf);
    _bgView = [UIView new];
    _bgView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    _bgView.x = _bgView.y = 0;
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.0;
    [self addSubview:_bgView];
    [_bgView setTapActionWithBlock:^{
        [weakSelf hide];
    }];
    
    [self addSubview:self.shareViewImg];
    
    _wayView = [SCShareWayView new];
    _wayView.x = 0;
    _wayView.top = SCREEN_HEIGHT;
    _wayView.delegate = self;
    [self addSubview:_wayView];
}

#pragma mark ---- 生成image
- (void)makeImageWithView:(UIView *)view withSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.shareViewImg.image = image;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.shareViewImg.alpha = 1;
    }];

}

#pragma mark ---- SCShareWayViewDelegate
- (void)SCShareWayViewClick:(NSInteger)tag
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(SCShareWalletViewClick:)]) {
        [self hide];
        [self.delegate SCShareWalletViewClick:tag-1024];
    }
}

@end
