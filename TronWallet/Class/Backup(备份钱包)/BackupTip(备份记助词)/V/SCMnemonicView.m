//
//  SCMnemonicView.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/25.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCMnemonicView.h"
#import "SCMnemonicViewCell.h"

@interface SCMnemonicView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@end

@implementation SCMnemonicView


+ (instancetype)init:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    return [[self alloc] initWithFrame:frame collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self) {
 
        self.backgroundColor = SCGray(250);
        self.delegate = self;
        self.dataSource = self;
        self.scrollsToTop = NO;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
 
        //注册cell
        [self registerClass:[SCMnemonicViewCell class] forCellWithReuseIdentifier:@"SCMnemonicViewCell"];
    }
    return self;
}


#pragma mark --UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mnemonicWord.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCMnemonicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SCMnemonicViewCell" forIndexPath:indexPath];
    cell.wordCell.text = _mnemonicWord[indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout Delagate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 20)/4, (self.height-10)/3);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark --UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_mnemonicDelegate selectWord:_mnemonicWord[indexPath.row]];
}


@end
