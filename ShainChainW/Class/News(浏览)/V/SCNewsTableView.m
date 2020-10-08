//
//  SCNewsTableView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/5.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCNewsTableView.h"
#import "SCNewsCell.h"
#import "SCBSJNewsLayout.h"
#import "SCShareWalletView.h"
#import <WXApi.h>
#import <WXApiObject.h>
@interface SCNewsTableView ()
<UITableViewDelegate,UITableViewDataSource,
SCNewsCellDelegate,SCShareWalletViewDelegate>

//数据数组
@property(strong, nonatomic) NSMutableArray *dataArray;
@property(strong, nonatomic) SCShareWalletView *shareWalletView;
@end

@implementation SCNewsTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = 0;
#warning mark - 模拟十条数据
//        _dataArray = [NSMutableArray new];
//        for (int i = 0; i<10; i++) {
//            SCNewsLayout *layout = [SCNewsLayout new];
//            [_dataArray addObject:layout];
//        }
//        [self reloadData];
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
        cell.bitCoin86Layout = self.dataArray[indexPath.row];
        
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
    SCBSJNewsLayout *layout = self.dataArray[indexPath.row];
    return layout.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow]animated:YES];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *lab = [UILabel new];
//    lab.size = CGSizeMake(SCREEN_WIDTH, 30);
//    lab.font = kHelFont(12);
//    lab.textColor = SCGray(88);
//    lab.backgroundColor = [UIColor whiteColor];
//    BSJDataModel *model = self.model.data[section];
//    lab.text = [NSString stringWithFormat:@"     %@",model.topStr];
//    return lab;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}

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
    swv.model = cell.bsjLayout.model;
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
    if (tag==0) {
        UIImageWriteToSavedPhotosAlbum(self.shareWalletView.shareViewImg.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        return;
    }
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


#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = LocalizedString(@"保存图片失败");
    }else{
        msg = LocalizedString(@"保存图片成功");
    }
    [TKCommonTools showToast:msg];
}


@end
