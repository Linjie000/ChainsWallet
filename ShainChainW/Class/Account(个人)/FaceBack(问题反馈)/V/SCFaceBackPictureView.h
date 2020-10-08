//
//  SCFaceBackPictureView.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/14.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
 
//选择最大图片数量
#define MAXPHOTOSCOUNT 5

@class SCFaceBackPictureView;
@protocol UBPublishDraftPictureViewDelegate <NSObject>
/** 删除时需要回调，增加时也需要回调，控制器只需要接收*/
- (void)publishDraftPictureView:(SCFaceBackPictureView *)pictureView picArrayDidChange:(NSArray *)picArray;
/** 添加图片*/
- (void)publishDraftPictureViewAddImage:(SCFaceBackPictureView *)pictureView;
@end

@interface SCFaceBackPictureView : UIView

@property (nonatomic, strong) NSMutableArray <UIImage *>*pictureArray;

/** 添加图片*/
- (void)addImages:(NSArray *)images;
@property (nonatomic, strong) UICollectionView *colView;
@property (nonatomic, weak) id <UBPublishDraftPictureViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
