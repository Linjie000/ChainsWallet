//
//  TWTopScrollView.m
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWTopScrollView.h"
#import "NSString+TKSize.h"

#define kTitleFontSize 15


@interface TWScrollItemViewCell : UICollectionViewCell

@property(nonatomic , strong) UILabel *titleLabel;

@end

@interface TWTopScrollView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic , strong) UICollectionView *collectionView;
@property(nonatomic , strong) NSArray *items;
@property(nonatomic , assign) NSInteger currentIndex;
@property(nonatomic , assign) TWTopScrollViewType type;

@end

@implementation TWTopScrollView

-(instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items type:(TWTopScrollViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor themeRed];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[TWScrollItemViewCell class] forCellWithReuseIdentifier:@"cellid"];
        [self addSubview:_collectionView];
        
//        _items = @[@"BLOCKCHAIN",@"WITNESS",@"NODES",@"TOKENS",@"ACCOUNT"];
        self.items = items;
        
        self.backgroundColor = HexColor(0x1ab0fd);//[UIColor whiteColor];
        
        
    }
    return self;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TWScrollItemViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    
    NSString *title = _items[indexPath.item];
    
    cell.titleLabel.text = title;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_type == TWTopScrollViewTypeEqualWidth) {
        
       return  CGSizeMake(CGRectGetWidth(collectionView.frame)/_items.count, CGRectGetHeight(collectionView.bounds));
    }
    
    NSString *title = _items[indexPath.item];
    UIFont *font = indexPath.item == _currentIndex ? [UIFont boldSystemFontOfSize:kTitleFontSize]:[UIFont systemFontOfSize:kTitleFontSize];
    CGSize size = [title sizeWithMaxWidth:1000 font:font];
    
    size.width += 20;
    
    if (size.width < 60) {
        size.width = 60;
    }
    
    return CGSizeMake(size.width, CGRectGetHeight(collectionView.bounds));
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_chooseBlock) {
        _chooseBlock(indexPath.item,_currentIndex);
    }
    _currentIndex = indexPath.item;
}

-(void)scrollToShow:(NSInteger)index
{
    if (index < _items.count && index >= 0) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation TWScrollItemViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.titleLabel.font = selected ? [UIFont boldSystemFontOfSize:kTitleFontSize]:[UIFont systemFontOfSize:kTitleFontSize];
}

@end
