//
//  SCMsgLeftController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/10.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCMsgLeftController.h"
#import "SCTransferMsgCell.h"

@interface SCMsgLeftController ()

@end

@implementation SCMsgLeftController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = 0;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCTransferMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCTransferMsgCell"];
    if (!cell) {
        cell = [[SCTransferMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCTransferMsgCell"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT;
}

@end
