//
//  SCPropertyOPInController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/21.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCPropertyOPInController.h"

@interface SCPropertyOPInController ()

@end

@implementation SCPropertyOPInController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCPropertyOPCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCPropertyOPCell"];
    if (!cell) {
        cell = [[SCPropertyOPCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCPropertyOPCell"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT;
}


@end

