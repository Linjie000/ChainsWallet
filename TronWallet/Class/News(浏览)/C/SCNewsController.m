//
//  SCNewsController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/4.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCNewsController.h"
#import "SCNewsLayout.h"
#import "SCNewsCell.h"
#import "SCNewsTableView.h"
#import "SCOurNewsTableView.h"

@interface SCNewsController ()
@property(strong, nonatomic) SCNewsTableView *tableView;
@property(strong, nonatomic) SCOurNewsTableView *ourNewsTableView;
@end

@implementation SCNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self subViews];
    

}

- (void)subViews{

    SCNewsTableView *tableView = [[SCNewsTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    
    
    
    [self createSegMentController];
}

//创建导航栏分栏控件
-(void)createSegMentController{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"快讯",@"闪链科技",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0, 0, 140, 30);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = SCOrangeColor;
    [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];
}

-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender
{
    NSInteger selecIndex = sender.selectedSegmentIndex;
    
    if (selecIndex==0) {
        self.tableView.hidden = NO;
        self.ourNewsTableView.hidden = YES;
    }
    if (selecIndex==1) {
        self.tableView.hidden = YES;
        self.ourNewsTableView.hidden = NO;
    }
}
 
- (SCOurNewsTableView *)ourNewsTableView
{
    if (!_ourNewsTableView) {
        _ourNewsTableView = [[SCOurNewsTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT) style:UITableViewStylePlain];
        [self.view addSubview:_ourNewsTableView];
    }
    return _ourNewsTableView;
}

@end
