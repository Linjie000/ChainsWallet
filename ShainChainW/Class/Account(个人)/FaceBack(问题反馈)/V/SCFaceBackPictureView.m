//
//  SCFaceBackPictureView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/14.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCFaceBackPictureView.h"
#import <UIKit/UIKit.h>
#import "UIView+Tap.h"
#import "UBPublishDraftPictureCollectionViewCell.h"
#import "UIView+Layer.h"


@interface SCFaceBackPictureView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@end

static NSString *cellID = @"UBPublishDraftPictureViewCellID";
static NSString *addCellID = @"UBPublishDraftPictureViewAddCellID";
@implementation SCFaceBackPictureView

-(instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.colView];
    }
    return self;
}

- (void)setPictureArray:(NSMutableArray <UIImage *>*)pictureArray {
    _pictureArray = pictureArray;
    [self.colView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.colView.frame = self.bounds;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.pictureArray.count == 0) {
        return 1;
    }
    if (self.pictureArray.count >= MAXPHOTOSCOUNT) {
        return self.pictureArray.count;
    }
    return self.pictureArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf);
    if (indexPath.row == self.pictureArray.count) {
        UBPublishDraftPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:addCellID forIndexPath:indexPath];
        cell.hiddenCloseBtn = YES;
        cell.image = [UIImage imageNamed:@"takePicture"];
        cell.contentView.layerBorderColor = SCGray(200);
        cell.contentView.layerBorderWidth = 0.3;
        cell.contentView.layerCornerRadius = 4.0;
        cell.contentView.clipsToBounds = YES;
        cell.publishDraftPictureCellAddImgHandle = ^(UBPublishDraftPictureCollectionViewCell *cell) {
            if ([weakSelf.delegate respondsToSelector:@selector(publishDraftPictureViewAddImage:)]) {
                [weakSelf.delegate publishDraftPictureViewAddImage:weakSelf];
            }
        };
        return cell;
    }
    UBPublishDraftPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.image = self.pictureArray[indexPath.row];
    cell.publishDraftPictureCellDeleteImgHandle = ^(UBPublishDraftPictureCollectionViewCell *cell) {
        
        NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
        if (weakSelf.pictureArray.count == 1) {
            [weakSelf.pictureArray removeAllObjects];
            [weakSelf.colView reloadData];
        } else {
            [weakSelf.pictureArray removeObjectAtIndex:indexPath.row];
            if (weakSelf.pictureArray.count == MAXPHOTOSCOUNT - 1) {
                [weakSelf.colView reloadData];
            }else
                [weakSelf.colView deleteItemsAtIndexPaths:@[indexPath]];
            
        }
        if ([weakSelf.delegate respondsToSelector:@selector(publishDraftPictureView:picArrayDidChange:)]) {
            [weakSelf.delegate publishDraftPictureView:weakSelf picArrayDidChange:weakSelf.pictureArray];
        }
    };
    return cell;
}

- (void)addImages:(NSArray *)images {
    if (images.count) {
        [self.pictureArray addObjectsFromArray:images];
        if ([self.delegate respondsToSelector:@selector(publishDraftPictureView:picArrayDidChange:)]) {
            [self.delegate publishDraftPictureView:self picArrayDidChange:self.pictureArray];
        }
        [self.colView reloadData];
    }
}

- (UICollectionView *)colView {
    if (!_colView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = ((SCREEN_WIDTH - 20) - 5 * 4) / 5.0;
        layout.itemSize = CGSizeMake(itemW, itemW);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        UICollectionView *col = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [self addSubview:col];
        _colView = col;
        col.delegate = self;
        col.dataSource = self;
        col.backgroundColor = [UIColor clearColor];
        [col registerClass:[UBPublishDraftPictureCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        [col registerClass:[UBPublishDraftPictureCollectionViewCell class] forCellWithReuseIdentifier:addCellID];
    }
    return _colView;
}


@end

