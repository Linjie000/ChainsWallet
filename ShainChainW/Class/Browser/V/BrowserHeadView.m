//
//  BrowserHeadView.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/28.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BrowserHeadView.h"
#import "RecommendMenuView.h"
#import "SDCycleScrollView.h"
#import "UnicornDappView.h"

@interface BrowserHeadView ()

//@property (strong, nonatomic) InfiniteCarouselView *bannerView;
@property (strong, nonatomic) RecommendMenuView *menuView;
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@end

@implementation BrowserHeadView

- (instancetype)init
{
    if (self=[super init]) {
        self.width = SCREEN_WIDTH;
        self.height = 450;
        [self subViews];
    }
    return self;
}

- (void)setModel:(RecommendDappModel *)model
{
    _model = model;
//    self.bannerView.bannerDappsArray = model.bannerDapps;
    self.menuView.introDappsArray = model.introDapps;
}

- (SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        CGRect frame = (CGRect){13,15,SCREEN_WIDTH-26,130};
        id<SDCycleScrollViewDelegate>delegate = self;
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:delegate placeholderImage:nil];
        cycleScrollView.layer.cornerRadius = 5;
        cycleScrollView.autoScrollTimeInterval = 3.3;
        cycleScrollView.clipsToBounds = YES;
        cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        cycleScrollView.imageURLStringsGroup = @[@"unicorn_banner_1",@"unicorn_banner_2",@"unicorn_banner_3"];
        UIImage *currentPageDotImage = IMAGENAME(@"page_sel");
        UIImage *pageDotImage = IMAGENAME(@"page_nor");
        cycleScrollView.pageDotImage = pageDotImage;
        cycleScrollView.currentPageDotImage = currentPageDotImage;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleScrollView = cycleScrollView;
    }
    return _cycleScrollView;
}

- (RecommendMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[RecommendMenuView alloc]init];
        _menuView.frame = CGRectMake(0,0, SCREEN_WIDTH, 0);
    }
    return _menuView;
}

- (void)subViews
{
    WeakSelf(weakSelf);
    [self addSubview:self.cycleScrollView];
    [self addSubview:self.menuView];
    
    UILabel *lab1 = [UILabel new];
    lab1.size = CGSizeMake(200, 30);
    lab1.x = 15;
    lab1.top = self.cycleScrollView.bottom+10;
    lab1.font = kHelBoldFont(16);
    lab1.text = @"UNICORN Dapps";
    [self addSubview:lab1];
    
    NSArray *array = @[@"eos_job",@"eos_sic",@"eos_bac"];
    UnicornDappView *dapp_View;
    for (int i=0; i<array.count; i++) {
        UnicornDappModel *model = [UnicornDappModel new];
        model.dappIcon = array[i];
        
        CGFloat marginx = 0;
        UnicornDappView *dappView = [UnicornDappView new];
        dappView.top = lab1.bottom+7;
        dappView.x = (dappView.width*i)+10+marginx*i;
        dappView.dappModel = model;
        dapp_View = dappView;
        [self addSubview:dappView];
    }
    UILabel *lab2 = [UILabel new];
    lab2.size = CGSizeMake(200, 30);
    lab2.x = 15;
    lab2.top = dapp_View.bottom+10;
    lab2.font = kHelBoldFont(16);
    lab2.text = @"推荐 Dapps";
    [self addSubview:lab2];
    self.menuView.top = lab2.bottom+10;
    [self.menuView setRecommendMenu:^(IntroDapps * _Nonnull model) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(browserHeadViewDelegateRecommendModel:)]) {
            [weakSelf.delegate browserHeadViewDelegateRecommendModel:model];
        }
    }]; 
}

@end
