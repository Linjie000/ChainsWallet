//
//  SCNewsSearchController.m
//  ShainChainW
//
//  Created by 闪链 on 2019/7/31.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCNewsSearchController.h"
#import "NewsSearchTitleView.h"
#import "SCCustomHeadView.h"
#import "NewsSearchTableView.h"
#import "SCNewsSearchController.h"
#import "NewsTool.h"

#import "SCOurNewsLayout.h"
#import "SCNewsLayout.h"
#import "SCBSJNewsLayout.h"
#import "SCBSJSearchLayout.h"

@interface SCNewsSearchController ()<UITextFieldDelegate>
{
    FCXRefreshHeaderView *_refreshHeaderView;
    FCXRefreshFooterView *_refreshFooterView;
    
    NSString *searchStr;
    NSInteger sizeNum;
}
@property(strong, nonatomic) NewsSearchTableView *tableView;
@property(strong, nonatomic) NewsSearchTitleView *titleView;
@end

@implementation SCNewsSearchController

- (NewsSearchTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[NewsSearchTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 35)];
    }
    return _titleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    [self subViews];
    [self setupNavigationItem];
    
    sizeNum = 100;
}

- (void)setupNavigationItem {
    
    SCCustomHeadView *headView = [SCCustomHeadView new];
    headView.x = headView.y = 0;
    [self.view addSubview:headView];
    
    [headView addSubview:self.titleView];
    self.titleView.x = 40;
    self.titleView.centerY = headView.leftBtnImg.centerY;
    self.titleView.searchView.delegate = self;
    
    WeakSelf(weakSelf);
    headView.rightTitleLab.text = LocalizedString(@"取消");
    [headView.rightTitleLab setTapActionWithBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
 
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    searchStr = textField.text;
    [self refreshAction];
    return YES;
}

- (void)refreshAction
{
    if (IsStrEmpty(searchStr)) {
        return ;
    }
    [NewsTool getNewsForBiShiJieKey:searchStr size:sizeNum success:^(BSJSearchModel * _Nonnull model) {
        [_refreshHeaderView endRefresh];
        NSMutableArray *layoutMarr = [[NSMutableArray alloc] init];
        for (BSJSearchExpressModel *bmodel in model.data.express) {
            SCBSJSearchLayout *layout = [[SCBSJSearchLayout alloc] initWithModel:bmodel heightLightText:searchStr];
            [layoutMarr addObject:layout];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.layoutArray = layoutMarr; 
            [self.tableView tableViewDisplayWithShoppingCart:IMAGENAME(@"暂无通知") imgFrame:CGRectMake(0 , 0, 100, 120) ifNecessaryForRowCount:layoutMarr.count tipString:nil message:nil onClickEvent:^(id obj) {
                
            }];
        });
    }];
   
}

- (void)subViews{
    
    _tableView = [[NewsSearchTableView alloc]initWithFrame:CGRectMake(0, NAVIBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    _refreshHeaderView = [_tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshAction];
    }];
  
    [self setRightBtn];
}

- (void)setRightBtn
{
    UIButton *findButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40, 30)];
    [findButton setImage:IMAGENAME(@"find") forState:UIControlStateNormal];
    [findButton addTarget:self action:@selector(findAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:findButton];
    self.navigationItem.rightBarButtonItem = item;
}


- (void)findAction
{
    SCNewsSearchController *sc = [SCNewsSearchController new];
    [self.navigationController pushViewController:sc animated:YES];
}
 
@end
