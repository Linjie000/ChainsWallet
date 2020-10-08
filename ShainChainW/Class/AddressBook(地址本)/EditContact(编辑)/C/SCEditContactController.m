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
#import "AddressBookModel.h"

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
    
    self.title = LocalizedString(@"编辑联系人");
    
    [self subViews];
    
    _nameTextField.text = _model.name;
    _noteTextField.text = _model.note;
    _contactView.placeHolderTextView.text = _model.address;
    _contactView.contaceType = [RewardHelper typeNamecoin:_model.brand];
}

- (void)setModel:(AddressBookModel *)model
{
    _model = model;
}

- (void)subViews
{
    _nameTextField = [SCUnderLineTextField new];
    _nameTextField.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 60);
    _nameTextField.x = marginX;
    _nameTextField.y = marginX;
    _nameTextField.placeholder = LocalizedString(@"名称");
    _nameTextField.font = kFont(14);
    [self.view addSubview:_nameTextField];
    
    _noteTextField = [SCUnderLineTextField new];
    _noteTextField.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 60);
    _noteTextField.x = marginX;
    _noteTextField.y = _nameTextField.bottom;
    _noteTextField.placeholder = LocalizedString(@"备注（选填）");
    _noteTextField.font = kFont(14);
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
    [saveButton setTitleColor:SCGray(70) forState:UIControlStateNormal];
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
    [SCAlertCreater addActionTarget:alert titles:@[LocalizedString(@"添加比特币地址"),LocalizedString(@"添加波场地址"),LocalizedString(@"添加以太坊地址"),LocalizedString(@"添加EOS账户名"),LocalizedString(@"添加IOST账户名")] color:SCColor(99, 154, 255) action:^(UIAlertAction * _Nonnull action) {
        if([action.title isEqualToString:LocalizedString(@"取消")])return ;
        [weakSelf addAddress:action.title];
        SCLog(@"---- %@",action.title);
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addAddress:(NSString *)typeStr{
    _contactView.hidden = NO;
    if ([typeStr isEqualToString:LocalizedString(@"添加比特币地址")]) {
        _contactView.contaceType = ADDRESS_TYPE_STRING_BTC;
    }
    if ([typeStr isEqualToString:LocalizedString(@"添加以太坊地址")]) {
        _contactView.contaceType = ADDRESS_TYPE_STRING_ETH;
    }
    if ([typeStr isEqualToString:LocalizedString(@"添加EOS账户名")]) {
        _contactView.contaceType = ADDRESS_TYPE_STRING_EOS;
    }
    if ([typeStr isEqualToString:LocalizedString(@"添加波场地址")]) {
        _contactView.contaceType = ADDRESS_TYPE_STRING_TRON;
    }
    if ([typeStr isEqualToString:LocalizedString(@"添加IOST账户名")]) {
        _contactView.contaceType = ADDRESS_TYPE_STRING_IOST;
    }
}

#pragma mark - 保存
- (void)saveAction
{
    NSString *name = _nameTextField.text;
    NSString *note = _noteTextField.text;
    NSString *address = self.contactView.placeHolderTextView.text;
    NSString *brand = @"";
    switch (self.contactView.contaceType) {
        case ADDRESS_TYPE_STRING_BTC:
            brand = @"BTC";
            break;
        case ADDRESS_TYPE_STRING_ETH:
            brand = @"ETH";
            break;
        case ADDRESS_TYPE_STRING_EOS:
            brand = @"EOS";
            break;
        case ADDRESS_TYPE_STRING_TRON:
            brand = @"TRON";
            break;
        case ADDRESS_TYPE_STRING_IOST:
            brand = @"IOST";
            break;
        default:
            break;
    }
    if ([self isBlankString:name]) {
        [TKCommonTools showToast:LocalizedString(@"请填写名称")];
        return;
    }
    if ([self isBlankString:address]) {
        [TKCommonTools showToast:LocalizedString(@"请填写地址")];
        return;
    }
 
    self.model.address = address;
    self.model.name = name;
    self.model.note = note;
    self.model.brand = brand;
    BOOL success = [self.model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:self.model.bg_id]]];
    if (success) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [TKCommonTools showToast:@"修改失败"];
}

@end
