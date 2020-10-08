//
//  IOSTPermissionsController.m
//  ShainChainW
//
//  Created by 闪链 on 2019/6/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "IOSTPermissionsController.h"
#import "EOSPermissionsView.h"

@interface IOSTPermissionsController ()
{
    IOSTAccount *_iostAccount;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@implementation IOSTPermissionsController

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.backgroundColor = SCGray(253);
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"权限查看");
    
    [self.view addSubview:self.scrollView];
    [self getAccount];
}

- (void)getAccount
{
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    [IOSTClient iost_getAccount:wallet.address handle:^(IOSTAccount *account) {
        _iostAccount = account;
        [self subViews];
    }];
}

- (void)subViews
{
    for (int i=0; i<2; i++) {
        IOSTPermissions *permission = _iostAccount.permissions;
        EOSPermissionsView *pv = [EOSPermissionsView new];
        pv.centerX = SCREEN_WIDTH/2;
        pv.top = pv.height*i + i*15 + 15;
        if (!i) {
            pv.public_keyLab.text = [permission.active.items[0] ids];
            pv.thresholdLab.text = [NSString stringWithFormat:LocalizedString(@"[权重阈值:%@]"),permission.active.threshold] ;
            pv.weightLab.text = [permission.active.items[0] weight];
        }
        else{
            pv.public_keyLab.text = [permission.owner.items[0] ids];
            pv.thresholdLab.text = [NSString stringWithFormat:LocalizedString(@"[权重阈值:%@]"),permission.owner.threshold] ;
            pv.weightLab.text = [permission.owner.items[0] weight];
        }
        [_scrollView addSubview:pv];
    }
    
    UITextView *textView = [[UITextView alloc]init];
    textView.size = CGSizeMake(SCREEN_WIDTH-30, 150);
    textView.x = 15;
    textView.top = (172+15)*2+15;
    textView.font = kFont(13);
    textView.textColor = SCGray(128);
    textView.backgroundColor = [UIColor clearColor];
    textView.text = LocalizedString(@"Tips:\n • Owner权限：Owner拥有账号的所有权，可以管理账号权限，管理Active及其他角色；\n• Active权限：Active拥有转账、投票等其它权限；\n• 权重阈值：权重阈值是行驶权限的最低权重要求；\n• 权重：权重是公钥的权重等级，数字越大权重越高；\n");
    [_scrollView addSubview:textView];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, textView.bottom+30);
}

@end

