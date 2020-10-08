//
//  SCNewsCell.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/4.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCNewsCell.h"

@implementation SCNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    _newsStatusView = [SCNewsStatusView new];
    _newsStatusView.cell = self;
    [self addSubview:_newsStatusView];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)setLayout:(SCNewsLayout *)layout
{
    _layout = layout;
    _newsStatusView.height = layout.height;
    _newsStatusView.layout = layout;
}

- (void)setBsjLayout:(SCBSJNewsLayout *)bsjLayout
{
    _bsjLayout = bsjLayout;
    _newsStatusView.height = bsjLayout.height;
    _newsStatusView.bsjLayout = bsjLayout;
}

- (void)setBitCoin86Layout:(SCBitCoin86Layout *)bitCoin86Layout
{
    _bitCoin86Layout = bitCoin86Layout;
    _newsStatusView.height = bitCoin86Layout.height;
    _newsStatusView.bitCoin86Layout = bitCoin86Layout;
}

- (void)setSearchLayout:(SCBSJSearchLayout *)searchLayout
{
    _searchLayout = searchLayout;
    _newsStatusView.height = searchLayout.height;
    _newsStatusView.searchLayout = searchLayout;
}

@end

@implementation SCNewsStatusView

- (instancetype)init
{
    self = [super init];
    self.width = SCREEN_WIDTH;
    
    _newsTopView = [SCNewsTopView new];
    [self addSubview:_newsTopView];
    
    _titleLab = [YYLabel new];
    _titleLab.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    _titleLab.displaysAsynchronously = YES;
    _titleLab.ignoreCommonProperties = YES;
    _titleLab.fadeOnHighlight = NO;
    _titleLab.fadeOnAsynchronouslyDisplay = NO;
    _titleLab.size = CGSizeMake(kT1ContentWidth, kTitleFontSize * 2);
    _titleLab.left = kTitleLeftPadding;
    _titleLab.userInteractionEnabled = NO;
    [self addSubview:_titleLab];
    
    _detailLab2 = [YYLabel new];
    _detailLab2.width = kT1ContentWidth;
    _detailLab2.left = kTitleLeftPadding;
    _detailLab2.userInteractionEnabled = NO;
    [self addSubview:_detailLab2];
//    _detailLab = [UILabel new];
//    _detailLab.width = kT1ContentWidth;
//    _detailLab.left = kTitleLeftPadding;
//    _detailLab.userInteractionEnabled = NO;
//    _detailLab.numberOfLines = 0;
//    [self addSubview:_detailLab];
    
    _newsBottomView = [SCNewsBottomView new];
    [self addSubview:_newsBottomView];
    
    _bottomLine = [RewardHelper addLine2];
    [self addSubview:_bottomLine];
    
    return self;
}

- (void)setSearchLayout:(SCBSJSearchLayout *)searchLayout
{
    _searchLayout = searchLayout;
    _newsTopView.searchLayout = searchLayout;
    _newsTopView.x = _newsTopView.y = 0;
    
    _newsBottomView.searchLayout = searchLayout;
    _newsBottomView.height = searchLayout.bottomViewHeight;
    _newsBottomView.bottom = searchLayout.height;
    
    _titleLab.textLayout = searchLayout.titleLayout;
    _titleLab.height = searchLayout.titleLayout.textBoundingSize.height;
    _titleLab.top = searchLayout.topViewHeight;
    
    _detailLab2.textLayout = searchLayout.detailLayout;
    _detailLab2.height = searchLayout.detailLayout.textBoundingSize.height;
    _detailLab2.top = _titleLab.bottom+searchLayout.titlePadding;
    //    _detailLab.height = layout.detailLayout.textBoundingSize.height;
    //    _detailLab.top = _titleLab.bottom+layout.titlePadding;
    //    _detailLab.attributedText = layout.detailText;
    //    _detailLab.numberOfLines = 6;
    //    _detailLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    _bottomLine.x = 0;
    _bottomLine.bottom = searchLayout.height;
}

- (void)setBitCoin86Layout:(SCBitCoin86Layout *)bitCoin86Layout
{
    _bitCoin86Layout = bitCoin86Layout;
    
    _newsTopView.bitCoin86Layout = bitCoin86Layout;
    _newsTopView.x = _newsTopView.y = 0;
    
    _newsBottomView.bitCoin86Layout = bitCoin86Layout;
    _newsBottomView.height = bitCoin86Layout.bottomViewHeight;
    _newsBottomView.bottom = bitCoin86Layout.height;
    
    _titleLab.textLayout = bitCoin86Layout.titleLayout;
    _titleLab.height = bitCoin86Layout.titleLayout.textBoundingSize.height;
    _titleLab.top = bitCoin86Layout.topViewHeight;
    
    _detailLab2.textLayout = bitCoin86Layout.detailLayout;
    _detailLab2.height = bitCoin86Layout.detailLayout.textBoundingSize.height;
    _detailLab2.top = _titleLab.bottom+bitCoin86Layout.titlePadding;
    
    _bottomLine.x = 0;
    _bottomLine.bottom = bitCoin86Layout.height;
}

- (void)setBsjLayout:(SCBSJNewsLayout *)bsjLayout
{
    _bsjLayout = bsjLayout;
    _newsTopView.bsjLayout = bsjLayout;
    _newsTopView.x = _newsTopView.y = 0;
    
    _newsBottomView.bsjLayout = bsjLayout;
    _newsBottomView.height = bsjLayout.bottomViewHeight;
    _newsBottomView.bottom = bsjLayout.height;
    
    _titleLab.textLayout = bsjLayout.titleLayout;
    _titleLab.height = bsjLayout.titleLayout.textBoundingSize.height;
    _titleLab.top = bsjLayout.topViewHeight;
    
    _detailLab2.textLayout = bsjLayout.detailLayout;
    _detailLab2.height = bsjLayout.detailLayout.textBoundingSize.height;
    _detailLab2.top = _titleLab.bottom+bsjLayout.titlePadding;
    //    _detailLab.height = layout.detailLayout.textBoundingSize.height;
    //    _detailLab.top = _titleLab.bottom+layout.titlePadding;
    //    _detailLab.attributedText = layout.detailText;
    //    _detailLab.numberOfLines = 6;
    //    _detailLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    _bottomLine.x = 0;
    _bottomLine.bottom = bsjLayout.height;
}

- (void)setLayout:(SCNewsLayout *)layout
{
    _layout = layout;
    _newsTopView.layout = layout;
    _newsTopView.x = _newsTopView.y = 0;
    
    _newsBottomView.layout = layout;
    _newsBottomView.height = layout.bottomViewHeight;
    _newsBottomView.bottom = layout.height;
    
    _titleLab.textLayout = layout.titleLayout;
    _titleLab.height = layout.titleLayout.textBoundingSize.height;
    _titleLab.top = layout.topViewHeight;
 
    _detailLab2.textLayout = layout.detailLayout;
    _detailLab2.height = layout.detailLayout.textBoundingSize.height;
    _detailLab2.top = _titleLab.bottom+layout.titlePadding;
//    _detailLab.height = layout.detailLayout.textBoundingSize.height;
//    _detailLab.top = _titleLab.bottom+layout.titlePadding;
//    _detailLab.attributedText = layout.detailText;
//    _detailLab.numberOfLines = 6;
//    _detailLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    _bottomLine.x = 0;
    _bottomLine.bottom = layout.height;

}

- (void)setCell:(SCNewsCell *)cell
{
    _cell = cell;
    _newsTopView.cell = cell;
    _newsBottomView.cell = cell;
}

@end

@implementation SCNewsTopView

- (instancetype)init
{
    self = [super init];
    
    CALayer *dotLayer = [CALayer new];
    dotLayer.size = CGSizeMake(9, 9);
    dotLayer.backgroundColor = SCOrangeColor.CGColor;
    dotLayer.cornerRadius = dotLayer.width/2;
    _dotLayer = dotLayer;
    [self.layer addSublayer:dotLayer];
    
    UILabel *timeLab = [UILabel new];
    timeLab.size = CGSizeMake(150, 18);
    timeLab.layer.cornerRadius = timeLab.height/2;
    timeLab.clipsToBounds = YES;
    timeLab.backgroundColor = SCColor(238, 130, 238);
//    timeLab.text = @"09:11";
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.font = kFont(12.5);
//    timeLab.textColor = SCGray(140);
    timeLab.textColor = [UIColor whiteColor];
    _timeLab = timeLab;
    [self addSubview:timeLab];
    
//    UILabel *sourceLab = [UILabel new];
//    sourceLab.text = @"来源：金色财经";
//    sourceLab.textAlignment = NSTextAlignmentRight;
//    sourceLab.font = kFont(13);
//    sourceLab.textColor = SCGray(140);
//    _sourceLab = sourceLab;
//    [self addSubview:sourceLab];
    
    
    return self;
}

- (void)setSearchLayout:(SCBSJSearchLayout *)searchLayout
{
    _searchLayout = searchLayout;
    self.width = SCREEN_WIDTH;
    self.height = searchLayout.topViewHeight;
    _timeLab.text = searchLayout.model.update_time;
    [_timeLab sizeToFit];
    _timeLab.width = _timeLab.width+23;
    _timeLab.x = kTitleLeftPadding;
    _timeLab.centerY = searchLayout.topViewHeight/2;
    
    
    _dotLayer.right = _timeLab.left-12;
    _dotLayer.centerY = _timeLab.centerY;
    
    _sourceLab.size = CGSizeMake(200, searchLayout.topViewHeight);
    _sourceLab.y = 0;
    _sourceLab.right = SCREEN_WIDTH - kTitleRightPadding;
}

- (void)setBitCoin86Layout:(SCBitCoin86Layout *)bitCoin86Layout
{
    _bitCoin86Layout = bitCoin86Layout;
    
    self.width = SCREEN_WIDTH;
    self.height = bitCoin86Layout.topViewHeight;
    _timeLab.x = kTitleLeftPadding;
    _timeLab.centerY = bitCoin86Layout.topViewHeight/2;
    _timeLab.text = bitCoin86Layout.model.inputtime;
    
    _dotLayer.right = _timeLab.left-12;
    _dotLayer.centerY = _timeLab.centerY;
    
    _sourceLab.size = CGSizeMake(200, bitCoin86Layout.topViewHeight);
    _sourceLab.y = 0;
    _sourceLab.right = SCREEN_WIDTH - kTitleRightPadding;
}

- (void)setBsjLayout:(SCBSJNewsLayout *)bsjLayout
{
    _bsjLayout = bsjLayout;
    self.width = SCREEN_WIDTH;
    self.height = bsjLayout.topViewHeight;
    _timeLab.x = kTitleLeftPadding;
    _timeLab.centerY = bsjLayout.topViewHeight/2;
    _timeLab.text = [self formattWithData:[bsjLayout.model.issue_time integerValue]];
    
    _dotLayer.right = _timeLab.left-12;
    _dotLayer.centerY = _timeLab.centerY;
    
    _sourceLab.size = CGSizeMake(200, bsjLayout.topViewHeight);
    _sourceLab.y = 0;
    _sourceLab.right = SCREEN_WIDTH - kTitleRightPadding;
}

- (void)setLayout:(SCNewsLayout *)layout
{
    _layout = layout;
    self.width = SCREEN_WIDTH;
    self.height = layout.topViewHeight;
    _timeLab.x = kTitleLeftPadding;
    _timeLab.centerY = layout.topViewHeight/2;
    _timeLab.text = [self formattWithData:layout.model.created_at];
    
    _dotLayer.right = _timeLab.left-12;
    _dotLayer.centerY = _timeLab.centerY;
    
    _sourceLab.size = CGSizeMake(200, layout.topViewHeight);
    _sourceLab.y = 0;
    _sourceLab.right = SCREEN_WIDTH - kTitleRightPadding;
}

- (NSString *)formattWithData:(NSInteger)time
{
    NSDate *selected = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}

@end

@implementation SCNewsBottomView


- (instancetype)init
{
    self = [super init];
    self.width = SCREEN_WIDTH;
    
    //赞
    YYControl *likeControl = [YYControl new];
    likeControl.size = CGSizeMake(65, 23);
    likeControl.layer.cornerRadius = likeControl.height/2;
    likeControl.clipsToBounds = YES;
    [self addSubview:likeControl];
    likeControl.layer.borderColor = SCGray(230).CGColor;
    likeControl.layer.borderWidth = 0.5;
    _likeControl = likeControl;
    likeControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state==YYGestureRecognizerStateEnded) {
            if ([self.cell.delegate respondsToSelector:@selector(cellDidClickLike:)]) {
//                [self.cell.delegate cellDidClickLike:self.cell];
            }
        }
    };
    
    UIImageView *likeImg = [UIImageView new];
    likeImg.size = CGSizeMake(12, 13);
    likeImg.x = 11;
    likeImg.centerY = likeControl.height/2;
    likeImg.image = IMAGENAME(@"news_praise_up");
    [likeControl addSubview:likeImg];
    _likeImg = likeImg;
    
    UILabel *likeCount = [UILabel new];
    likeCount.size = CGSizeMake(likeControl.width - likeImg.right, likeControl.height);
    likeCount.textAlignment = NSTextAlignmentCenter;
    likeCount.font = kFont(13.3);
    likeCount.textColor = SCGray(130);
    [likeControl addSubview:likeCount];
    _likeCount = likeCount;
    
    //踩
    YYControl *notlikeControl = [YYControl new];
    notlikeControl.size = CGSizeMake(65, 23);
    notlikeControl.layer.cornerRadius = notlikeControl.height/2;
    notlikeControl.clipsToBounds = YES;
    [self addSubview:notlikeControl];
    notlikeControl.layer.borderColor = SCGray(230).CGColor;
    notlikeControl.layer.borderWidth = 0.5;
    _notlikeControl = notlikeControl;
    _notlikeControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state==YYGestureRecognizerStateEnded) {
            if ([self.cell.delegate respondsToSelector:@selector(cellDidClickNotLike:)]) {
//                [self.cell.delegate cellDidClickNotLike:self.cell];
            }
        }
    };
    
    UIImageView *notlikeImg = [UIImageView new];
    notlikeImg.size = CGSizeMake(12, 13);
    notlikeImg.x = 11;
    notlikeImg.centerY = notlikeControl.height/2;
    notlikeImg.image = IMAGENAME(@"news_praise_down");
    [notlikeControl addSubview:notlikeImg];
    _notlikeImg = notlikeImg;
    
    UILabel *notlikeCount = [UILabel new];
    notlikeCount.size = CGSizeMake(notlikeControl.width - notlikeImg.right, notlikeControl.height);
    notlikeCount.textAlignment = NSTextAlignmentCenter;
    
    notlikeCount.font = kFont(13.3);
    notlikeCount.textColor = SCGray(130);
    [notlikeControl addSubview:notlikeCount];
    _notlikeCount = notlikeCount;
    
    //分享
    UILabel *shareLab = [UILabel new];
    shareLab.text = LocalizedString(@"分享");
    shareLab.font = kFont(13);
    shareLab.textColor = SCOrangeColor;
    [shareLab sizeToFit];
    _shareLab = shareLab;
    [self addSubview:shareLab];
    
    UIImageView *shareImg = [UIImageView new];
    shareImg.size = CGSizeMake(13, 11);
    shareImg.image = IMAGENAME(@"news_share");
    [self addSubview:shareImg];
    _shareImg = shareImg;
    
    _shareControl = [YYControl new];
    [self addSubview:_shareControl];
    _shareControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state==YYGestureRecognizerStateEnded) {
//            SCLog(@"+++++分享");
            if (self.cell.delegate && [self.cell.delegate respondsToSelector:@selector(cellDidClickShare:)]) {
                [self.cell.delegate cellDidClickShare:self.cell];
            }
        }
    };
    
    return self;
}

- (void)setBitCoin86Layout:(SCBitCoin86Layout *)bitCoin86Layout
{
    _bitCoin86Layout = bitCoin86Layout;
    _likeControl.x = kTitleLeftPadding;
    _likeControl.centerY = bitCoin86Layout.bottomViewHeight/2;
    _likeCount.x = _likeImg.right;
    
    _notlikeControl.x = _likeControl.right+17;
    _notlikeControl.centerY = _likeControl.centerY;
    _notlikeCount.x = _notlikeImg.right;
    
    _shareLab.right = SCREEN_WIDTH - kTitleRightPadding;
    _shareLab.centerY = _likeControl.centerY;
    _shareImg.right = _shareLab.left-8;
    _shareImg.centerY = _shareLab.centerY;
    
    _shareControl.size = CGSizeMake(60, bitCoin86Layout.bottomViewHeight);
    _shareControl.right = _shareLab.right;
    
    _likeCount.text = [NSString stringWithFormat:@"%ld",bitCoin86Layout.userLikeCount];
    _notlikeCount.text = [NSString stringWithFormat:@"%ld",bitCoin86Layout.userNotLikeCount];
    
    if (bitCoin86Layout.userLike) _likeImg.image = IMAGENAME(@"news_praise_up_light");
    else _likeImg.image = IMAGENAME(@"news_praise_up");
    
    if (bitCoin86Layout.userNotLike) _notlikeImg.image = IMAGENAME(@"news_praise_down_light");
    else _notlikeImg.image = IMAGENAME(@"news_praise_down");
}

- (void)setBsjLayout:(SCBSJNewsLayout *)bsjLayout
{
    _bsjLayout = bsjLayout;
    _likeControl.x = kTitleLeftPadding;
    _likeControl.centerY = bsjLayout.bottomViewHeight/2;
    _likeCount.x = _likeImg.right;
    
    _notlikeControl.x = _likeControl.right+17;
    _notlikeControl.centerY = _likeControl.centerY;
    _notlikeCount.x = _notlikeImg.right;
    
    _shareLab.right = SCREEN_WIDTH - kTitleRightPadding;
    _shareLab.centerY = _likeControl.centerY;
    _shareImg.right = _shareLab.left-8;
    _shareImg.centerY = _shareLab.centerY;
    
    _shareControl.size = CGSizeMake(60, bsjLayout.bottomViewHeight);
    _shareControl.right = _shareLab.right;
    
    _likeCount.text = [NSString stringWithFormat:@"%ld",bsjLayout.userLikeCount];
    _notlikeCount.text = [NSString stringWithFormat:@"%ld",bsjLayout.userNotLikeCount];
    
    if (bsjLayout.userLike) _likeImg.image = IMAGENAME(@"news_praise_up_light");
    else _likeImg.image = IMAGENAME(@"news_praise_up");
    
    if (bsjLayout.userNotLike) _notlikeImg.image = IMAGENAME(@"news_praise_down_light");
    else _notlikeImg.image = IMAGENAME(@"news_praise_down");
}

- (void)setSearchLayout:(SCBSJSearchLayout *)searchLayout
{
    _searchLayout = searchLayout;
    _likeControl.x = kTitleLeftPadding;
    _likeControl.centerY = searchLayout.bottomViewHeight/2;
    _likeCount.x = _likeImg.right;
    
    _notlikeControl.x = _likeControl.right+17;
    _notlikeControl.centerY = _likeControl.centerY;
    _notlikeCount.x = _notlikeImg.right;
    
    _shareLab.right = SCREEN_WIDTH - kTitleRightPadding;
    _shareLab.centerY = _likeControl.centerY;
    _shareImg.right = _shareLab.left-8;
    _shareImg.centerY = _shareLab.centerY;
    
    _shareControl.size = CGSizeMake(60, searchLayout.bottomViewHeight);
    _shareControl.right = _shareLab.right;
    
    _likeCount.text = [NSString stringWithFormat:@"%ld",searchLayout.userLikeCount];
    _notlikeCount.text = [NSString stringWithFormat:@"%ld",searchLayout.userNotLikeCount];
    
    if (searchLayout.userLike) _likeImg.image = IMAGENAME(@"news_praise_up_light");
    else _likeImg.image = IMAGENAME(@"news_praise_up");
    
    if (searchLayout.userNotLike) _notlikeImg.image = IMAGENAME(@"news_praise_down_light");
    else _notlikeImg.image = IMAGENAME(@"news_praise_down");
}

- (void)setLayout:(SCNewsLayout *)layout
{
    _layout = layout;
    _likeControl.x = kTitleLeftPadding;
    _likeControl.centerY = layout.bottomViewHeight/2;
    _likeCount.x = _likeImg.right;
    
    _notlikeControl.x = _likeControl.right+17;
    _notlikeControl.centerY = _likeControl.centerY;
    _notlikeCount.x = _notlikeImg.right;
    
    _shareLab.right = SCREEN_WIDTH - kTitleRightPadding;
    _shareLab.centerY = _likeControl.centerY;
    _shareImg.right = _shareLab.left-8;
    _shareImg.centerY = _shareLab.centerY;
    
    _shareControl.size = CGSizeMake(60, layout.bottomViewHeight);
    _shareControl.right = _shareLab.right;
    
    _likeCount.text = [NSString stringWithFormat:@"%ld",layout.userLikeCount];
    _notlikeCount.text = [NSString stringWithFormat:@"%ld",layout.userNotLikeCount];
    
    if (layout.userLike) _likeImg.image = IMAGENAME(@"news_praise_up_light");
    else _likeImg.image = IMAGENAME(@"news_praise_up");
    
    if (layout.userNotLike) _notlikeImg.image = IMAGENAME(@"news_praise_down_light");
    else _notlikeImg.image = IMAGENAME(@"news_praise_down");
}

- (void)updateLikeWithAnimation {
    
    SCNewsLayout *layout = self.cell.layout;

    _likeCount.text = [NSString stringWithFormat:@"%ld",layout.userLikeCount];
    if (layout.userLike) _likeImg.image = IMAGENAME(@"news_praise_up_light");
    else _likeImg.image = IMAGENAME(@"news_praise_up");
 
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.likeImg.layer.transformScale = 1.2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.likeImg.layer.transformScale = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)updateNotLikeWithAnimation
{
    SCNewsLayout *layout = self.cell.layout;
    
    _notlikeCount.text = [NSString stringWithFormat:@"%ld",layout.userNotLikeCount];
    if (layout.userNotLike) _notlikeImg.image = IMAGENAME(@"news_praise_down_light");
    else _notlikeImg.image = IMAGENAME(@"news_praise_down");
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.notlikeImg.layer.transformScale = 1.2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.notlikeImg.layer.transformScale = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

@end


