//
//  SCAffirmBackupController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/2.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCAffirmBackupController.h"
#import "UILabel+SCString.h"
#import "SCCommonBtn.h"
#import "SCWarnView.h"
#import "SCMnemonicView.h"
#import "SCSelectedModel.h"
#import "SCMnemonicViewCell.h"

@interface SCAffirmBackupController ()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) SCMnemonicView *mnemonicView;//上方
@property (nonatomic, strong) SCMnemonicView *confirmView;//下方
@property (nonatomic, strong) NSMutableArray *selectWordArr;//记录已选助记词的列表
@property (nonatomic, strong) NSMutableArray *confirmArr;
@end

@implementation SCAffirmBackupController

- (NSMutableArray *)selectWordArr
{
    if(_selectWordArr == nil) {
        _selectWordArr = [NSMutableArray array];
    }
    return _selectWordArr;
}

- (NSMutableArray *)confirmArr
{
    if(_confirmArr == nil) {
        _confirmArr = [NSMutableArray array];
    }
    return _confirmArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subViews];
    
    self.mnemonicArray = [self.mnemonicArray sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    
    self.confirmView.mnemonicWord = self.mnemonicArray;
    [self.mnemonicArray  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SCSelectedModel*model=[[SCSelectedModel alloc]init];
        model.name=self.confirmView.mnemonicWord[idx];
        model.type=0;
        [self.confirmArr addObject:model];
    }];

    [self.confirmView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
 
}

- (void)subViews
{
    UIImageView *createImg = [UIImageView new];
    createImg.size = CGSizeMake(35, 35);
    createImg.image = IMAGENAME(@"2.1确认助记词");
    createImg.centerX = SCREEN_WIDTH/2;
    createImg.top = 20;
    [self.view addSubview:createImg];
    
    UILabel *lab = [UILabel new];
    lab.size = CGSizeMake(100, 40);
    lab.centerX = createImg.centerX;
    lab.top = createImg.bottom+3;
    lab.text = LocalizedString(@"确认记助词");
    lab.font = kFont(17);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = SCTEXTCOLOR;
    [self.view addSubview:lab];
    
    UIFont *font = kFont(15);
    CGFloat w = SCREEN_WIDTH - 45;
    NSString *str = LocalizedString(@"按顺序点击记助词，以确认您正确备份。");
    
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:str];
    nameText.font = font;
    nameText.color = SCGray(120);
    nameText.lineSpacing = 8;
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    YYTextContainer *nameContainer = [YYTextContainer containerWithSize:CGSizeMake(w, CGFLOAT_MAX)];
    YYTextLayout *nameTextLayout = [YYTextLayout layoutWithContainer:nameContainer text:nameText];
    
    YYLabel *textlab = [YYLabel new];
    textlab.textLayout = nameTextLayout;
    textlab.textAlignment = NSTextAlignmentCenter;
    textlab.size = nameTextLayout.textBoundingSize;
    textlab.centerX = createImg.centerX;
    textlab.top = lab.bottom+SCREEN_ADJUST_HEIGHT(20);
    textlab.numberOfLines = 0;
    [self.view addSubview:textlab];
    
    UIView *bgView = [UIView new];
    bgView.size = CGSizeMake(SCREEN_WIDTH, 150);
    bgView.x = 0;
    bgView.y = textlab.bottom+SCREEN_ADJUST_HEIGHT(30);
    bgView.backgroundColor = SCGray(250);
    [self.view addSubview:bgView];
    
    _mnemonicView = [SCMnemonicView init:CGRectMake(0, 0, SCREEN_WIDTH - 20, bgView.height)];
    _mnemonicView.centerX = bgView.width/2;
    _mnemonicView.centerY = bgView.height/2;
    self.mnemonicView.delegate = self;
    self.mnemonicView.dataSource=self;
    [bgView addSubview:_mnemonicView];
    
    _confirmView = [SCMnemonicView init:CGRectMake(10, bgView.bottom+10, SCREEN_WIDTH - 20, bgView.height)];
    self.confirmView.backgroundColor = [UIColor clearColor];
    self.confirmView.delegate = self;
    self.confirmView.dataSource=self;
    [self.view addSubview:_confirmView];
    
 
    SCCommonBtn *commonBtn = [SCCommonBtn createCommonBtnText:LocalizedString(@"完成")];
    commonBtn.bottom = self.view.bottom-NAVIBAR_HEIGHT;
    [self.view addSubview:commonBtn];
    [commonBtn setTapActionWithBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
 
}

#pragma mark --UICollectionView Delegate
///** 初始化cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.confirmView]) {
        SCSelectedModel*model=self.confirmArr[indexPath.row];
        //下方
        SCMnemonicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SCMnemonicViewCell" forIndexPath:indexPath];
        cell.wordCell.text = model.name;
 
        return cell;
    }else{
        //上方
        SCSelectedModel*model=self.selectWordArr[indexPath.row];
        SCMnemonicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SCMnemonicViewCell" forIndexPath:indexPath];
        cell.wordCell.text = model.name;
 
        return cell;
    }
    
}

/** cell的点击事件*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //下方-confirmView
    if ([collectionView isEqual:self.confirmView]) {
        SCSelectedModel*model=self.confirmArr[indexPath.row];
        if (model.type==0) {
            model.type=1;
            [self.selectWordArr addObject:model];
            [self.confirmArr removeObjectAtIndex:indexPath.row];
            [self.mnemonicView reloadData];
            [self.confirmView reloadData];
        }
    }else{//上方
        SCSelectedModel*model=self.selectWordArr[indexPath.row];
        model.type=0;
        [self.selectWordArr removeObject:model];
        [self.confirmArr addObject:model];//
        [self.mnemonicView reloadData];
        [self.confirmView reloadData];
    }
    [self resetConfirmTframeWithArray:self.confirmArr];//重置确认按钮的位置
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
/** 每组中cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.confirmView]) {
        return self.confirmArr.count;
    }else{
        return self.selectWordArr.count;
    }
}
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 25)/4, (self.confirmView.height-10)/3);
}

/** 分区内cell之间的最小行间距*/
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
/** 分区内cell之间的最小列间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)resetConfirmTframeWithArray:(NSMutableArray*)confirmArr {
//    if (confirmArr.count>8) {
//        self.heightConstant.constant=180;
//    }else if (confirmArr.count<=8&&confirmArr.count>4){
//        self.heightConstant.constant=120;
//    }
//    else{
//        self.heightConstant.constant=60;
//    }
    
}


@end
