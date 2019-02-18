//
//  TWTransactionRecordViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/6/8.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWTransactionRecordViewController.h"
#import "TWTransferTableViewCell.h"
#import "UIViewController+Refresh.h"
#import "TKCommonTools.h"

@interface TWTransactionRecordViewController ()

@property(nonatomic , strong) NSMutableArray *transactionList;
@property(nonatomic , assign) NSInteger index;
@property(nonatomic , strong) NSURLSession *session;
@end

@implementation TWTransactionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Transactions";
    [self initBackItem];
    
    self.transactionList = [NSMutableArray new];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    self.tableView.allowsSelection = NO;
    
    UINib *nib = [UINib nibWithNibName:@"TWTransferTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cellid"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addHeaderRefreshView:self.tableView];
    [self addFooterRefreshView:self.tableView];
    
    [self startHeadRefresh:self.tableView];
   
}


-(void)headRefreshAction
{
    [self loadData:YES];
}

-(void)footRefreshAction
{
    [self loadData:NO];
}

-(void)loadData:(BOOL)isHead
{
    if (isHead) {
        _index = 0;
    }
    NSString *address = AppWalletClient.base58OwnerAddress;
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.tronscan.org/api/transfer?sort=-timestamp&limit=30&start=%ld&address=%@",_index,address];
    __weak typeof(self) wself = self;
    
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself stopRefresh:wself.tableView];
        });
        if (error) {
            [TKCommonTools showToast:@"Request failed"];
            return ;
        }
        
        @try{
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (json) {
                if (isHead) {
                    [wself.transactionList removeAllObjects];
                }
                NSArray *data = json[@"data"];
                if (data.count > 0) {
                    [wself.transactionList addObjectsFromArray:data];
                    wself.index += data.count;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [wself.tableView reloadData];
                    });
                }
            }
        }@catch(NSException *e){
            
        }
        
    }];
    [task resume];    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _transactionList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWTransferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *transcation = _transactionList[indexPath.row];
    [cell bindData:transcation];
        
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
