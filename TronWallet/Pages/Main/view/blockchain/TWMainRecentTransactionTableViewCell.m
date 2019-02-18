//
//  TWMainRecentTransactionTableViewCell.m
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWMainRecentTransactionTableViewCell.h"
#import "TWTransInfoTableViewCell.h"

@interface TWMainRecentTransactionTableViewCell()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , strong) UITableView *tableView;
@property(nonatomic,  strong) NSArray<Transaction*> *transactionsArray;

@end

@implementation TWMainRecentTransactionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.tableView];
        self.contentView.backgroundColor = [UIColor themeDarkBgColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor themeDarkBgColor];
        UINib *nib = [UINib nibWithNibName:@"TWTransInfoTableViewCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:@"cellid"];
        
        [self.contentView addSubview:_tableView];
    }
    return _tableView;
}

-(void)bindData:(NSArray<Transaction *>*)data
{
    self.transactionsArray = data;
    [self.tableView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _tableView.frame = CGRectInset(self.bounds, 20, 0);    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _transactionsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTransInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    Transaction *transaction = _transactionsArray[indexPath.row];
    [cell bindData:transaction];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

@end
