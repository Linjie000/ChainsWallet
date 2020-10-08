//
//  SCAddAssetController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/11.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCAddAssetController.h"
#import "SCAddAssetCell.h"
#import "SCAddAssetHeadView.h"

@interface SCAddAssetController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_imgarr;
}
@property(strong, nonatomic) UITableView *tableView;
@end

@implementation SCAddAssetController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    _imgarr = @[@"3.1BNT",@"3.1DOGE",@"EOS",@"3.1ETH",@"3.1GNT",@"3.1PAY",@"3.1SNT"];
    
    [self subViews];
    self.tableView.separatorStyle = 0;
}

- (void)subViews
{
    SCAddAssetHeadView *shv = [[SCAddAssetHeadView alloc]init];
    [self.view addSubview:shv];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIBAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCAddAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCAddAssetCell"];
    if (!cell) {
        cell = [[SCAddAssetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCAddAssetCell"];
    }
    cell.headImg.image = IMAGENAME(_imgarr[indexPath.row]);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT;
}

@end
