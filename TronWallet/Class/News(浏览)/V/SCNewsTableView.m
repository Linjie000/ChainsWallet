//
//  SCNewsTableView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/5.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCNewsTableView.h"
#import "SCNewsCell.h"

@interface SCNewsTableView ()
<UITableViewDelegate,UITableViewDataSource,SCNewsCellDelegate>

//数据数组
@property(strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation SCNewsTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = 0;
#warning mark - 模拟十条数据
        _dataArray = [NSMutableArray new];
        for (int i = 0; i<10; i++) {
            SCNewsLayout *layout = [SCNewsLayout new];
            [_dataArray addObject:layout];
        }
        [self reloadData];
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[SCNewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.delegate = self;
    if (_dataArray.count) {
        cell.layout = _dataArray[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_dataArray.count)return 100;
    SCNewsLayout *layout = _dataArray[indexPath.row];
    return layout.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow]animated:YES];
}

#pragma mark - SCNewsCellDelegate
- (void)cellDidClickLike:(SCNewsCell *)cell
{
    SCNewsLayout *layout = cell.layout;
    if (layout.userNotLike) {
        return;
    }
    if (layout.userLike) {
        layout.userLike = NO;
        if (layout.userLikeCount > 0) layout.userLikeCount--;
    }else{
        layout.userLike = YES;
        layout.userLikeCount++;
    }
    [cell.newsStatusView.newsBottomView updateLikeWithAnimation];
}

-(void)cellDidClickNotLike:(SCNewsCell *)cell
{
    SCNewsLayout *layout = cell.layout;
    if (layout.userLike) {
        return;
    }
    if (layout.userNotLike) {
        layout.userNotLike = NO;
        if (layout.userNotLikeCount > 0) layout.userNotLikeCount--;
    }else{
        layout.userNotLike = YES;
        layout.userNotLikeCount++;
    }
    [cell.newsStatusView.newsBottomView updateNotLikeWithAnimation];
}

-(void)cellDidClickShare:(SCNewsCell *)cell
{
    
}


@end
