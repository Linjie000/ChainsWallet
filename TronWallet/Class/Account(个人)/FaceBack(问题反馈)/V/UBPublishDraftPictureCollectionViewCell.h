//
//  UBPublishDraftPictureCollectionViewCell.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/14.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UBPublishDraftPictureCollectionViewCell : UICollectionViewCell
/** 图片*/
@property (nonatomic, strong) UIImage *image;
/** 删除图片回调*/
@property (nonatomic, copy) void(^publishDraftPictureCellDeleteImgHandle)(UBPublishDraftPictureCollectionViewCell *cell);
/** 添加图片回调*/
@property (nonatomic, copy) void(^publishDraftPictureCellAddImgHandle)(UBPublishDraftPictureCollectionViewCell *cell);
/** 是否显示关闭按钮*/
@property (nonatomic, assign) BOOL hiddenCloseBtn;
@end

NS_ASSUME_NONNULL_END
