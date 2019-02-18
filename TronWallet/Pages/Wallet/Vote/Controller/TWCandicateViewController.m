//
//  TWCandicateViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/27.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWCandicateViewController.h"
#import "TWCandicateTableViewCell.h"
#import "TWVoteWitnessModel.h"
#import "TWShEncoder.h"

@interface TWCandicateViewController ()

@property(nonatomic , strong) NSMutableDictionary *voteMap;
@property(nonatomic , strong) NSMutableArray<Witness*> *witnessesArray;

@end

@implementation TWCandicateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.voteMap = [NSMutableDictionary new];
    
    self.tableView.allowsSelection = NO;
    self.tableView.separatorColor = [UIColor blackColor];//HexColor(0x747C7F);
    UINib *nib = [UINib nibWithNibName:@"TWCandicateTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell_id"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startRequest];
}

-(void)startRequest
{
    Wallet *wallet = [[TWNetworkManager sharedInstance] walletClient];
    [wallet listWitnessesWithRequest:[EmptyMessage new] handler:^(WitnessList * _Nullable response, NSError * _Nullable error) {
        
        [self.voteMap removeAllObjects];
        BOOL success = NO;
        if (response.witnessesArray_Count > 0) {
            success = YES;
            self.witnessesArray = response.witnessesArray;
        }
        [self requestDone:success];
    }];
}

-(NSArray *)voteWitness
{    
    if (_voteMap.count == 0) {
        return NULL;
    }
    NSMutableArray *witnesses = [[NSMutableArray alloc] initWithCapacity:_voteMap.count];
    for (NSString *address in [_voteMap allKeys]) {
        
        for (Witness *wit in _witnessesArray) {
            NSString *addr = [TWShEncoder encode58Check:wit.address];
            if ([addr isEqualToString:address]) {
                TWVoteWitnessModel *model = [[TWVoteWitnessModel alloc]init];
                model.witness = wit;
                model.vote = [_voteMap[address] integerValue];
                [witnesses addObject:model];
            }
        }     
    }
    return witnesses;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _witnessesArray.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWCandicateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id" forIndexPath:indexPath];
    if (!cell.updateVotes) {
        __weak typeof(self) wself = self;
        cell.updateVotes = ^(NSInteger votes,NSString *address, NSInteger index) {
            wself.voteMap[address] = @(votes);
            [wself.tableView reloadData];
        };
    }
    
    // Configure the cell...
    NSInteger index = indexPath.section+1;
    Witness *witness = _witnessesArray[indexPath.section];
    NSString *address = [TWShEncoder encode58Check:witness.address];
    NSInteger votes = 0;
    if (address) {
        votes = [self.voteMap[address] integerValue];
    }
    [cell updateWithModel:witness index:index votes:votes];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section < _witnessesArray.count - 1) {
        return 2;
    }
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}

@end
