//
//  BackupPriKeyController.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BackupPriKeyController.h"
#import "SCExpNaviView.h"
#import "BackupPriKeyView.h"
#import "TWHexConvert.h"
#import "SCRootTool.h"

@interface BackupPriKeyController ()
<SCExpNaviViewDelegate,UIScrollViewDelegate,BackupPriKeyViewDelegate>
{
    CGFloat lastContentOffset;
}
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) BackupPriKeyView *leftView;
@property(strong, nonatomic) TWWalletAccountClient *client;

@end

@implementation BackupPriKeyController

- (void)setClient:(TWWalletAccountClient *)client
{
    _client = client;
    
    self.leftView.client = client;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LocalizedString(@"备份钱包");
    
    [self subViews];
    
    if (self.isBackup) {
        self.client = [UserinfoModel shareManage].appDelegate.walletClient;
    }else
    {
        TWWalletType type = TWWalletDefault;
        TWWalletAccountClient *client = [[TWWalletAccountClient alloc] initWithGenKey:YES type:type];
        [client store:self.wallet.password];
 
        self.client = client;
        self.wallet.address =  client.base58OwnerAddress;
    }
}

- (void)subViews{
 
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _scrollView.height);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:self.leftView];
 
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL _isRight;
    CGFloat x = scrollView.contentOffset.x;
    if (x > lastContentOffset) {
        _isRight = YES;
    } else {
        _isRight = NO;
    }
    lastContentOffset = x;
    CGFloat f = scrollView.contentOffset.x/self.view.bounds.size.width;
 
    if (f>0.3) {
        [self setRightScrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat f = scrollView.contentOffset.x/SCREEN_WIDTH;
    if (f==1) {
        [self setRightScrollView];
    }
}

- (void)backupPriKeyCommon
{
    if (self.isBackup) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    BOOL success = [self.wallet bg_save];
    if (success) {
        [SVProgressHUD showWithStatus:LocalizedString(@"正在创建钱包")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SCRootTool creatWallet];
            [SVProgressHUD dismiss];
            AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [appdelegate createAccountDone];
        });
    }else
    {
        [TKCommonTools showToast:LocalizedString(@"创建失败")];
    }
}

#pragma mark - mark - 加载右侧滚动
- (void)setRightScrollView
{

}

#pragma mark - SCExpNaviViewDelegate 顶部
- (void)SCExpNaviViewDidIndex:(NSInteger)index
{
    [self setCurrentPage:index animated:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = currentPage * self.scrollView.width;
    [self.scrollView setContentOffset:contentOffset animated:animated];
}

#pragma mark - lazyload
- (BackupPriKeyView *)leftView
{
    if (!_leftView) {
        BackupPriKeyView *leftView = [[BackupPriKeyView alloc]init];
        leftView.width = SCREEN_WIDTH;
        leftView.height = _scrollView.height;
        leftView.x = leftView.y = 0;
        _leftView = leftView;
        _leftView.delegate = self;
    }
    return _leftView;
}
 
@end

