//
//  UBPublishDraftPictureCollectionViewCell.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/14.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//


#import "UBPublishDraftPictureCollectionViewCell.h"
#import "UIView+Tap.h"

@interface UBPublishDraftPictureCollectionViewCell ()
@property (nonatomic, weak) UIImageView *bgImgView;
@property (nonatomic, weak) UIButton *closeBtn;
@end

@implementation UBPublishDraftPictureCollectionViewCell

- (void)setImage:(UIImage *)image {
    _image = image;
    if (image) {
        self.bgImgView.image = image;
        [self.contentView bringSubviewToFront:self.closeBtn];
    }
}

- (void)setHiddenCloseBtn:(BOOL)hiddenCloseBtn {
    _hiddenCloseBtn = hiddenCloseBtn;
    self.closeBtn.hidden = hiddenCloseBtn;
}

// 删除
- (void)closeBtnClick:(UIButton *)btn {
    if (self.publishDraftPictureCellDeleteImgHandle) {
        self.publishDraftPictureCellDeleteImgHandle(self);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 图片
    CGFloat margin = 2.5;
    CGFloat bgX = margin;
    CGFloat bgY = margin;
    CGFloat bgW = self.contentView.width - margin * 2.0;
    CGFloat bgH = self.contentView.height - margin * 2.0;
    self.bgImgView.frame = CGRectMake(bgX, bgY, bgW, bgH);
    
    // 删除按钮
    CGFloat closeW = self.closeBtn.currentImage.size.width;
    CGFloat closeH = self.closeBtn.currentImage.size.height;
    CGFloat closeX = self.contentView.width - closeW;
    CGFloat closeY = 0;
    self.closeBtn.frame = CGRectMake(closeX, closeY, closeW, closeH);
    [self bringSubviewToFront:self.closeBtn];
    
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        UIImageView *bg = [[UIImageView alloc] init];
        [self.contentView addSubview:bg];
        _bgImgView = bg;
        bg.layer.cornerRadius = 4;
        bg.contentMode = UIViewContentModeScaleAspectFill;
        bg.clipsToBounds = YES;
        WeakSelf(weakSelf);
        [bg setTapActionWithBlock:^{
            if (weakSelf.closeBtn.hidden == NO) return ;
            if (weakSelf.publishDraftPictureCellAddImgHandle) {
                weakSelf.publishDraftPictureCellAddImgHandle(weakSelf);
            }
        }];
    }
    return _bgImgView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        UIButton *btn = [[UIButton alloc] init];
        [self.contentView addSubview:btn];
        _closeBtn = btn;
        [btn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"publish_delete"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}
@end
