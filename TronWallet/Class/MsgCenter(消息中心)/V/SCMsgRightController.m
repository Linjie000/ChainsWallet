//
//  SCMsgRightController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/10.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCMsgRightController.h"
#import "SCSystemMsgCell.h"

@interface SCMsgRightController ()

@end

@implementation SCMsgRightController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = 0;
    
    [self.tableView tableViewDisplayWithShoppingCart:IMAGENAME(@"暂无通知") ifNecessaryForRowCount:0 tipString:nil message:nil onClickEvent:^(id obj) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCSystemMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCTransferMsgCell"];
    if (!cell) {
        cell = [[SCSystemMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCTransferMsgCell"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT;
}
@end
