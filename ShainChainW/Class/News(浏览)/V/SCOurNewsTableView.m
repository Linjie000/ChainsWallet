//
//  SCOurNewsTableView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/5.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCOurNewsTableView.h"
#import "SCOurNewsLayout.h"
#import "SCOurNewsCell.h"

@interface SCOurNewsTableView()
<UITableViewDelegate,UITableViewDataSource>
//数据数组
@property(strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation SCOurNewsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = 0;
#warning mark - 模拟十条数据
        _dataArray = [NSMutableArray new];
        for (int i = 0; i<10; i++) {
            SCOurNewsLayout *layout = [SCOurNewsLayout new];
            [_dataArray addObject:layout];
        }
        [self reloadData];
    }
    return self;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCOurNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCOurNewsCell"];
    if (!cell) {
        cell = [[SCOurNewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCOurNewsCell"];
    }
    if (_dataArray.count) {
        cell.layout = _dataArray[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCOurNewsLayout *layout = _dataArray[indexPath.row];
    return layout.height;
}

@end
