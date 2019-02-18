//
//  SCEditContactController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/15.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCEditContactController.h"
#import "SCUnderLineTextField.h"
#import "SCAlertCreater.h"
#import "SCContactView.h"

#define marginX 15

@interface SCEditContactController ()
{
    //记录当前地址类型
    
}
@property(strong, nonatomic) SCUnderLineTextField *nameTextField;
@property(strong, nonatomic) SCUnderLineTextField *noteTextField;
@property(strong, nonatomic) SCContactView *contactView;
@end

@implementation SCEditContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LocalizedString(@"新建联系人");
    
    [self subViews];
}

- (void)subViews
{
    _nameTextField = [SCUnderLineTextField new];
    _nameTextField.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 60);
    _nameTextField.x = marginX;
    _nameTextField.y = marginX;
    _nameTextField.placeholder = LocalizedString(@"名称");
    [self.view addSubview:_nameTextField];
    
    _noteTextField = [SCUnderLineTextField new];
    _noteTextField.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 60);
    _noteTextField.x = marginX;
    _noteTextField.y = _nameTextField.bottom;
    _noteTextField.placeholder = LocalizedString(@"备注（选填）");
    [self.view addSubview:_noteTextField];
 
    SCContactView *contactView = [[SCContactView alloc]init];
    contactView.x = 0;
    contactView.top = _noteTextField.bottom+5;
    __block SCContactView *contactView_b = contactView;
    [contactView setHidenBlock:^{
        contactView_b.hidden = NO;
        [self newContaceAction];
    }];
    _contactView = contactView;
    [self.view addSubview:contactView];
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40, 30)];
    [saveButton setTitleColor:SCGray(128) forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveButton setTitle:LocalizedString(@"保存") forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - 新建联系人
- (void)newContaceAction
{
    WeakSelf(weakSelf);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [SCAlertCreater addActionTarget:alert titles:@[LocalizedString(@"添加比特币地址"),LocalizedString(@"添加以太坊地址"),LocalizedString(@"添加EOS账户名")] color:SCColor(99, 154, 255) action:^(UIAlertAction * _Nonnull action) {
        if([action.title isEqualToString:LocalizedString(@"取消")])return ;
        [weakSelf addAddress:action.title];
        SCLog(@"---- %@",action.title);
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addAddress:(NSString *)typeStr{
    _contactView.hidden = NO;
    if ([typeStr isEqualToString:LocalizedString(@"添加比特币地址")]) {
        _contactView.contaceType = BTCTYPE;
    }
    if ([typeStr isEqualToString:LocalizedString(@"添加以太坊地址")]) {
        _contactView.contaceType = ETHTYPE;
    }
    if ([typeStr isEqualToString:LocalizedString(@"添加EOS账户名")]) {
        _contactView.contaceType = EOSTYPE;
    }
}

#pragma mark - 保存
- (void)saveAction
{
    
}

@end
