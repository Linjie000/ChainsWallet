//
//  SCMaketTableHeadView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/4.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCMaketTableHeadView.h"

#define marginX SCREEN_ADJUST_WIDTH(15)
#define kFontSize 16

@interface SCMaketTableHeadView()
{
    YYControl *_allAction;
    YYControl *_priceAction;
    
    UILabel *_allLab;
    UILabel *_priceLab;
    UILabel *_udLab;

    UIImageView *_markImg1;
    UIImageView *_markImg2;
}
@end

@implementation SCMaketTableHeadView

+ (instancetype)sharInstance
{
    static SCMaketTableHeadView *headView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        headView = [[SCMaketTableHeadView alloc]init];
    });
    return headView;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = 40;
        [self subViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)subViews{
    _allAction = [YYControl new];
    _allAction.size = CGSizeMake(66, 40);
    [self addSubview:_allAction];
    _allAction.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        
    };
    
    _allLab = [UILabel new];
    _allLab.text = LocalizedString(@"全部");
    _allLab.font = kHelFont(kFontSize);
    [_allAction addSubview:_allLab];
    UIImageView *markImg1 = [UIImageView new];
    markImg1.size = CGSizeMake(8, 8);
    markImg1.image = IMAGENAME(@"3角行");
    _markImg1 = markImg1;
//    [_allAction addSubview:markImg1];
    
    _priceLab = [UILabel new];
    _priceLab.text = LocalizedString(@"价格");
    _priceLab.font = kHelFont(kFontSize);
    _priceLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_priceLab];
    
    _priceAction = [YYControl new];
    _priceAction.size = CGSizeMake(66, 40);
    [self addSubview:_priceAction];
    _priceAction.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        
    };
    _udLab = [UILabel new];
    _udLab.text = LocalizedString(@"涨跌幅");
    _udLab.font = kHelFont(kFontSize);
    [_priceAction addSubview:_udLab];
    UIImageView *markImg2 = [UIImageView new];
    markImg2.size = CGSizeMake(8, 8);
    markImg2.image = IMAGENAME(@"3角行");
    _markImg2 = markImg2;
//    [_priceAction addSubview:markImg2];
    
    [_allLab sizeToFit];
    [_priceLab sizeToFit];
    [_udLab sizeToFit];
    
    UIView *line = [RewardHelper addLine2];
    line.x = 0;
    line.bottom = kHeadHeight;
    [self addSubview:line];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
 
    _allAction.x = 0;
    _allAction.centerY = kHeadHeight/2;
    
    _allLab.centerX = _allAction.width/2;
    _allLab.centerY = _allAction.height/2;
    _markImg1.x = _allLab.right+3;
    _markImg1.bottom = _allLab.bottom-2;
    
    _priceLab.centerY = kHeadHeight/2;
    _priceLab.right = SCREEN_WIDTH - SCREEN_ADJUST_WIDTH(90) - marginX - SCREEN_ADJUST_WIDTH(14);
    
    _priceAction.centerY = kHeadHeight/2;
    _priceAction.right = SCREEN_WIDTH-marginX;
    
    _markImg2.right = _priceAction.width;
    _udLab.right = _markImg2.left-3;
    _udLab.centerY = _priceAction.height/2;
    _markImg2.bottom = _udLab.bottom-2;
}

@end
