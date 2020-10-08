//
//  DAppExcuteMutipleActionsBaseView.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "DAppExcuteMutipleActionsBaseView.h"
#import "ExcuteActions.h"

@interface DAppExcuteMutipleActionsBaseView ()
<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *array;
@end

@implementation DAppExcuteMutipleActionsBaseView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = SCREEN_HEIGHT;
        WeakSelf(weakSelf);
        [self setTapActionWithBlock:^{
            if (weakSelf.delegate) {
                [weakSelf.delegate excuteMutipleActionsConfirmBtnDidClick];
            }
            [weakSelf removeFromSuperview];
        }];
    }
    return self;
}

- (void)updateViewWithArray:(NSArray *)dataArray
{
    self.array = dataArray;
    [self subViews];
}

 - (void)subViews
{
    UIView *bgView = [UIView new];
    bgView.x = bgView.y = 0;
    bgView.alpha = 0.5;
    bgView.backgroundColor = [UIColor blackColor];
    [self addSubview:bgView];
   
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bottom = self.height;
    [self addSubview:_tableView];
 
    [KeyWindow addSubview:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"asd"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"asd"];
    }
    ExcuteActions *model = self.array[indexPath.row];
    cell.textLabel.text = model.account;
    cell.detailTextLabel.text = model.name;
    
    return cell;
}

@end
