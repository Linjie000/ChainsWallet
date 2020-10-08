//
//  BrowserHeadView.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/28.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "InfiniteCarouselView.h"
#import "iCarousel.h"
#import "Masonry.h"

#define PAGE_OFFSET 10

@interface  InfiniteCarouselView ()<iCarouselDelegate,iCarouselDataSource>

@property (nonatomic,strong) iCarousel *carousel;

/**
 *  无数据时背景图
 */
@property (strong, nonatomic) UIImageView *placeholderImageView;
@end

@implementation  InfiniteCarouselView
#pragma mark - initview
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self carousel];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self carousel];
}
- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    self.carousel.autoscroll = autoScrollTimeInterval;
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
//        [self bringSubviewToFront:self.placeholderImageView];
//        UIImage *placeholderImage = [UIImage imageNamed:placeholder];
//    self.placeholderImageView.image = placeholderImage;
//        self.placeholderImageView.image = [placeholderImage HT_setRadius:self.cornerRadius size:CGSizeMake(SCREEN_WIDTH - 2*PAGE_OFFSET, self.height)];
}
//- (void)setImageURLSignal:(RACSignal *)imageURLSignal
//{
//    _imageURLSignal = imageURLSignal;
//    @weakify(self);
//    [_imageURLSignal subscribeNext:^(id  _Nullable x) {
//        
//        @strongify(self);
//        if ([x count] > 0) {
//            
//            [self.placeholderImageView removeFromSuperview];
//            
//            [x enumerateObjectsUsingBlock:^(HTBannerModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//                [self.imageURLStringsGroup addObject:model];
//            }];
//        }
//        
//        dispatch_main_async_safe(^{
//            
//            [self.carousel reloadData];
//            
//        });
//        
//        
//    }];
//}
#pragma mark - life cycle
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.left.top.bottom.equalTo(self);
    }];
}
- (void)dealloc
{
    self.carousel.dataSource = nil;
    self.carousel.delegate = nil;
}
#pragma mark - iCarouselDelegate && iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.bannerDappsArray.count;
}
-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    
    CGFloat viewWidth = (SCREEN_WIDTH/375)*300;
    CGFloat viewHeight = (SCREEN_HEIGHT/667)*130;
    UILabel *titleLabel = nil;
    UILabel *likeLabel = nil;
    UIImageView *startView = nil;
    if (view == nil) {
        
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        view.backgroundColor = [UIColor clearColor];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, viewWidth-16, 50)];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:@"DamascusBold" size:15];
        [view addSubview:titleLabel];
        
        likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, viewHeight - 30, viewWidth-16, 20)];
        likeLabel.textColor = [UIColor whiteColor];
        likeLabel.font = [UIFont fontWithName:@"Damascus" size:12];
        [view addSubview:likeLabel];
        
        startView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth - 40, viewHeight-40, 30, 30)];
        [view addSubview:startView];
    }
    
//    CGFloat viewWidth = SCREEN_WIDTH - 2*PAGE_OFFSET;
//    if (view == nil) {
//        
//        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.height)];
//        view.backgroundColor = [UIColor clearColor];
//    }
//    view.layer.cornerRadius = self.cornerRadius;
//    view.size = CGSizeMake(viewWidth, self.height);
//    view.clipsToBounds = YES;
//    HTBannerModel *model = self.imageURLStringsGroup[index];
//    [((UIImageView *)view) HT_setImageWithCornerRadius:self.cornerRadius imageURL:[NSURL URLWithString:model.image_url] placeholder:self.placeholder contentMode:UIViewContentModeScaleToFill size:CGSizeMake(viewWidth, self.height)];
    BannerDapps *model = self.bannerDappsArray[index];
    ((UIImageView *)view).contentMode = UIViewContentModeScaleToFill;
    ((UIImageView *)view).layer.cornerRadius = 6;
    ((UIImageView *)view).clipsToBounds = YES;
    [((UIImageView *)view) setImageWithURL:[NSURL URLWithString:model.dappImage] placeholder:[UIImage imageWithColor:SCGray(250)] options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
 
    return view;
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            
            return value * 1.05;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
//    HTBannerModel *model = self.imageURLStringsGroup[index];
//    HTWebViewModel *viewModel = [[HTWebViewModel alloc] initWithServices:nil params:@{ViewTitlekey:@"",RequestURLkey:model.html_url,NavBarStyleTypekey:@(kNavBarStyleNomal)}];
//    [[HTMediatorAction sharedInstance] pushWebViewControllerWithViewModel:viewModel];
    
    if (self.clickItemOperationBlock) {
        self.clickItemOperationBlock(index);
    }
}
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if (self.itemDidScrollOperationBlock) {
        self.itemDidScrollOperationBlock(self.carousel.currentItemIndex);
    }
}
#pragma mark - getter
- (iCarousel *)carousel
{
    if (!_carousel) {
        _carousel = [[iCarousel alloc] init];
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.pagingEnabled = YES;
        _carousel.type = iCarouselTypeRotary;
        [self addSubview:_carousel];
    }
    return _carousel;
}
- (UIImageView *)placeholderImageView
{
    if (!_placeholderImageView) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 2*PAGE_OFFSET, self.height)];
        view.contentMode = UIViewContentModeScaleToFill;
        _placeholderImageView = view;
        [self addSubview:view];
    }
    return _placeholderImageView;
}

- (void)setBannerDappsArray:(NSArray *)bannerDappsArray
{
    _bannerDappsArray = bannerDappsArray;
    dispatch_main_async_safe(^{
        [self.carousel reloadData];
    });
}


@end
