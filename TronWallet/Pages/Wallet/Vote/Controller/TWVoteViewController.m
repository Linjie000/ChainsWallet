//
//  TWVoteViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/27.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWVoteViewController.h"
#import "TWCandicateViewController.h"
#import "TWYourVotesViewController.h"
#import "TWTopScrollView.h"
#import "TWAddressOnlyViewController.h"
#import "TWHexConvert.h"
#import "TWShEncoder.h"

#define kTopScrollHeight 40

@interface TWVoteViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property(nonatomic , strong) TWTopScrollView *topScrollView;
@property(nonatomic , strong) UIPageViewController *pageContainerViewController;
@property(nonatomic , strong) NSArray *controllers;
@property(nonatomic , strong) TWCandicateViewController *canController;
@property(nonatomic , strong) TWYourVotesViewController *ownController;

@property(nonatomic , assign) NSInteger balance;
@property(nonatomic , assign) NSInteger avaiable;

@end

@implementation TWVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"VOTES";
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11.0 , *)) {
        insets = [[[UIApplication sharedApplication] keyWindow] safeAreaInsets];
    }
    
    NSArray *items = @[@"CADIDATES",@"YOUR VOTES"];
    _topScrollView = [[TWTopScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopScrollHeight) items:items type:TWTopScrollViewTypeEqualWidth];
    [self.containerView addSubview:_topScrollView];
    __weak typeof(self) wself = self;
    _topScrollView.chooseBlock = ^(NSInteger index,NSInteger lastIndex) {
        UIViewController *controller = wself.controllers[index];
        [wself.pageContainerViewController setViewControllers:@[controller] direction:index>=lastIndex?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    };
    
    _pageContainerViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageContainerViewController.dataSource = self;
    _pageContainerViewController.delegate = self;
    _pageContainerViewController.view.backgroundColor = [UIColor themeDarkBgColor];
    
    
    CGRect frame = self.containerView.bounds;//[[UIScreen mainScreen]bounds];
    frame.size.height -= ( CGRectGetHeight(_topScrollView.frame));
    frame.origin.y = CGRectGetMaxY(_topScrollView.frame);
    _pageContainerViewController.view.frame = frame;
    _pageContainerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self addChildViewController:_pageContainerViewController];
    [_pageContainerViewController didMoveToParentViewController:self];
    
    _canController = [[TWCandicateViewController alloc]init];
    _ownController = [[TWYourVotesViewController alloc]init];
    _controllers = @[_canController,_ownController ];
    
    [_pageContainerViewController setViewControllers:@[_controllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    _pageContainerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:_pageContainerViewController.view];
    
    self.containerView.backgroundColor = [UIColor themeDarkBgColor];
    
    [_topScrollView scrollToShow:0];
    
    [self refrshUI];
    
    [self initBackItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refrshUI
{
    TWWalletAccountClient * client =  AppWalletClient ;
    NSMutableArray<Vote*> *voteArray = client.account.votesArray;
    
    
    NSInteger totalVotes = 0;
    NSInteger fronzes = 0;
    
    for (Vote *vote in voteArray) {
        totalVotes += vote.voteCount;
    }
    
    for (Account_Frozen *frozen in  client.account.frozenArray) {
        fronzes += frozen.frozenBalance;
    }
    
    long balance = fronzes/kDense;
    _amountLabel.text = [NSString stringWithFormat:@"%@ / %@",@(balance - totalVotes),@(balance)];
    
    self.avaiable = balance - totalVotes;
    self.balance = balance;
    
}

-(IBAction)submitAction:(id)sender
{
    if (self.avaiable == 0 && self.balance == 0) {
        [self showAlert:nil mssage:@"Please froze enough TRX" confrim:@"OK" cancel:nil];
        return;
    }
    
    [self.canController.view endEditing:YES];
    if (self.canController.voteWitness.count == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Please choose Votes";
        [hud hideAnimated:YES afterDelay:1];
        return;
    }
    
    
    Wallet *wallet = [[TWNetworkManager sharedInstance] walletClient];
    VoteWitnessContract *contract = [[VoteWitnessContract alloc] init];
    contract.ownerAddress = [AppWalletClient address];
    for (TWVoteWitnessModel *model in self.canController.voteWitness) {
        VoteWitnessContract_Vote *vote = [VoteWitnessContract_Vote new];
        vote.voteAddress = model.witness.address;
        vote.voteCount = model.vote;
        [contract.votesArray addObject:vote];
    }
    
    if (AppWalletClient.type == TWWalletAddressOnly) {
        [self addressOnlyVote:contract];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) wself = self;
    [wallet voteWitnessAccountWithRequest:contract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        if (error) {
            hud.label.text = [NSString stringWithFormat:@"%@",error];
            [hud hideAnimated:YES afterDelay:1];
        }else if(!response.hasRawData){
            hud.label.text = @"Vote failed";
            [hud hideAnimated:YES afterDelay:1];
        }else{
            [wself broadcastTransaction:response hud:hud completion:^(Return * _Nullable response, NSError * _Nullable error) {
                [AppWalletClient refreshAccount:^(TronAccount *account, NSError *error) {
                    [wself refrshUI];
                }];
                [wself.canController startRequest];
                [wself.ownController startRequest];
            }];
        }
    }];
}

-(void)addressOnlyVote:(VoteWitnessContract *)contract
{
//    TWWalletAccountClient *client = AppWalletClient;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
    
    [wallet voteWitnessAccountWithRequest:contract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        if (error) {
            hud.label.text = [NSString stringWithFormat:@"%@",error];
            [hud hideAnimated:YES afterDelay:1];
        }else if(!response.hasRawData){
            hud.label.text = @"Vote failed";
            [hud hideAnimated:YES afterDelay:1];
        }else{
            
            [hud hideAnimated:NO];
            
            [self signTransaction:response];                        
        }
    }];
    
    
}

-(void)signTransaction:(Transaction *)transaction
{
        
    TWAddressOnlyViewController *controller = [[TWAddressOnlyViewController alloc] initWithNibName:@"TWAddressOnlyViewController" bundle:nil];
    
    NSData *data = [transaction data];
    NSString *str = [TWHexConvert convertDataToHexStr:data];
    [controller updateQR:str];
    __weak typeof(self) wself = self;
    controller.scanblock = ^(NSString *qr) {
        NSData *tdata = [TWHexConvert convertHexStrToData:qr];
        Transaction *transaction = [Transaction parseFromData:tdata error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself broadcastTransaction:transaction];
        });        
    };
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)broadcastTransaction:(Transaction *)transaction
{
    TWWalletAccountClient *client = AppWalletClient;
    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) wself = self;
    [wallet broadcastTransactionWithRequest:transaction handler:^(Return * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            hud.label.text = [error localizedDescription];
        }else{
            if (response.code == Return_response_code_Success) {
                hud.label.text = @"Success";
                
                [client refreshAccount:^(TronAccount *account, NSError *error) {
                    [wself.canController startRequest];
                    [wself.ownController startRequest];
                }];                                
            }else{
                
                NSString *tip  = [[NSString alloc] initWithData:response.message encoding:NSUTF8StringEncoding];
                if (tip.length == 0) {
                    tip = @"Vote failed";
                }
                hud.label.text = tip;
            }
        }
        [hud hideAnimated:YES afterDelay:1.5 ];
    }];
}


- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [_controllers indexOfObject:viewController];
    if (index <= 0) {
        return nil;
    }
    return _controllers[index-1];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [_controllers indexOfObject:viewController];
    if (index < 0 || index >= [_controllers count] - 1) {
        return nil;
    }
    return _controllers[index+1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    UIViewController *controller = [pendingViewControllers firstObject];
    NSInteger index = [self.controllers indexOfObject:controller];
    [self.topScrollView scrollToShow:index];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
