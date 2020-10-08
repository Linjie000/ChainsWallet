//
//  NewsSearchTableView.m
//  ShainChainW
//
//  Created by 闪链 on 2019/7/31.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "NewsSearchTableView.h"
#import "SCNewsCell.h" 
#import "SCShareWalletView.h"
#import <WXApi.h>
#import <WXApiObject.h>
@interface NewsSearchTableView ()
<UITableViewDelegate,UITableViewDataSource,SCNewsCellDelegate,SCShareWalletViewDelegate>

//数据数组
@property(strong, nonatomic) NSMutableArray *dataArray;
@property(strong, nonatomic) SCShareWalletView *shareWalletView;
@end

@implementation NewsSearchTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = 0; 
    }
    return self;
}

- (void)setLayoutArray:(NSArray *)layoutArray
{
    _layoutArray = layoutArray;
    self.dataArray = layoutArray.mutableCopy;
    [self reloadData];
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
        cell.searchLayout = self.dataArray[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_dataArray.count)return 100;
    SCBSJSearchLayout *layout = self.dataArray[indexPath.row];
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
    SCShareWalletView *swv = [SCShareWalletView new];
    swv.model = cell.searchLayout.model;
    swv.delegate = self;
    self.shareWalletView = swv;
}

#pragma mark - SCShareWalletViewDelegate 分享
- (void)SCShareWalletViewClick:(NSInteger)tag
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"myiost_yellow"]];
    
    WXImageObject *ext = [WXImageObject object];  
    ext.imageData = UIImagePNGRepresentation(self.shareWalletView.shareViewImg.image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    if (tag==1) {
        req.scene = WXSceneSession;
    }
    if (tag==2) {
        req.scene = WXSceneTimeline;
    }
    if ([WXApi isWXAppInstalled]) {
        [WXApi sendReq:req];
    }
}
@end
