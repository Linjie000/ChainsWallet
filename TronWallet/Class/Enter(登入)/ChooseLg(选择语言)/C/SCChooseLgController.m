//
//  SCChooseLgController.m
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/28.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import "SCChooseLgController.h"
#import "UIBarButtonItem+SetUpBarButtonItem.h"
#define CellHight 48

@interface SCChooseLgController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong ,nonatomic) UITableView *tableView;
@property(strong ,nonatomic) NSArray *sysLgArray;
@end

@implementation SCChooseLgController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LocalizedString(@"多语言");
    _sysLgArray = [self systemLanguge];
    [self subViews];
}

- (void)subViews{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = 0;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 60, 35);
    saveBtn.titleLabel.font = kFont(17);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:SCGray(40) forState:UIControlStateNormal];
    [saveBtn setTitleColor:SCGray(120) forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lg"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lg"];
    }
    cell.selectedBackgroundView= [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor= SCGray(244);
    if(_sysLgArray.count)
        cell.textLabel.text = _sysLgArray[indexPath.row];
    UIView *line = [RewardHelper addLine2];
    line.width = SCREEN_WIDTH;
    line.bottom = CellHight;
    [cell addSubview:line];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sysLgArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHight;
}

- (NSArray *)systemLanguge
{
    NSMutableArray *sysMArray = [NSMutableArray new];
    NSArray *languge = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    for (NSString *code in languge) {
        NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:code];
        NSString *displayNameString = [frLocale displayNameForKey:NSLocaleIdentifier value:code];
        [sysMArray addObject:displayNameString];
    }
    return sysMArray.copy;
}

#pragma mark - 保存
- (void)saveAction
{
    
}

@end
