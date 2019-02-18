//
//  SCNewsCell.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/4.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCNewsLayout.h"

NS_ASSUME_NONNULL_BEGIN

@class SCNewsCell;
@class SCNewsStatusView;
@class SCNewsTopView;
@class SCNewsBottomView;

//文字视图+全视图
@interface SCNewsStatusView : YYControl
@property(strong, nonatomic) YYLabel *titleLab;
@property(strong, nonatomic) YYLabel *detailLab2;
//@property(strong, nonatomic) UILabel *detailLab;
@property(strong, nonatomic) UIView *bottomLine;
@property(strong, nonatomic) SCNewsTopView *newsTopView;
@property(strong, nonatomic) SCNewsBottomView *newsBottomView;

@property(strong, nonatomic) SCNewsLayout *layout;
@property (nonatomic, weak) SCNewsCell *cell;
@end

//顶部视图
@interface SCNewsTopView : YYControl
@property(strong, nonatomic) UILabel *timeLab;
@property(strong, nonatomic) CALayer *dotLayer;
@property(strong, nonatomic) UILabel *sourceLab;
@property(strong, nonatomic) SCNewsLayout *layout;

@property (nonatomic, weak) SCNewsCell *cell;
@end

//底部视图
@interface SCNewsBottomView: YYControl
 
@property(strong, nonatomic) YYControl *likeControl;
@property(strong, nonatomic) UILabel *likeCount;
@property(strong, nonatomic) UIImageView *likeImg;

@property(strong, nonatomic) YYControl *notlikeControl;
@property(strong, nonatomic) UILabel *notlikeCount;
@property(strong, nonatomic) UIImageView *notlikeImg;

@property(strong, nonatomic) YYControl *shareControl;
@property(strong, nonatomic) UILabel *shareLab;
@property(strong, nonatomic) UIImageView *shareImg;

@property(strong, nonatomic) SCNewsLayout *layout;
@property (nonatomic, weak) SCNewsCell *cell;

- (void)updateLikeWithAnimation;
- (void)updateNotLikeWithAnimation;
@end

@protocol SCNewsCellDelegate <NSObject>
@optional
- (void)cellDidClickLike:(SCNewsCell *)cell;
- (void)cellDidClickNotLike:(SCNewsCell *)cell;
- (void)cellDidClickShare:(SCNewsCell *)cell;
@end

@interface SCNewsCell : UITableViewCell
@property(strong, nonatomic) SCNewsStatusView *newsStatusView;
@property(strong, nonatomic) SCNewsLayout *layout;
@property (nonatomic, weak) id<SCNewsCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
