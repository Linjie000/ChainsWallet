//
//  SCNewContaceController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/9.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCNewContaceController.h"
#import "SCUnderLineTextField.h"
#import "SCAlertCreater.h"
#import "SCContactView.h"
#import "AddressBookModel.h"

#define marginX 15

@interface SCNewContaceController ()
{
    //记录当前地址类型
}
@property(strong, nonatomic) SCUnderLineTextField *nameTextField;
@property(strong, nonatomic) SCUnderLineTextField *noteTextField;
@property(strong, nonatomic) YYControl *addAddressControl;
@property(strong, nonatomic) SCContactView *contactView;
@property(strong, nonatomic) NSArray *addressTypeArray;
@end

@implementation SCNewContaceController

- (NSArray *)addressTypeArray
{
    if (!_addressTypeArray) {
        _addressTypeArray = @[LocalizedString(@"添加比特币地址"),LocalizedString(@"添加波场地址"),LocalizedString(@"添加以太坊地址"),LocalizedString(@"添加EOS账户名"),LocalizedString(@"添加IOST账户名"),LocalizedString(@"添加ATOM账户名")];
    }
    return _addressTypeArray;
}

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
    _nameTextField.font = kFont(14);
    [self.view addSubview:_nameTextField];
    
    _noteTextField = [SCUnderLineTextField new];
    _noteTextField.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 60);
    _noteTextField.x = marginX;
    _noteTextField.y = _nameTextField.bottom;
    _noteTextField.font = kFont(14);
    _noteTextField.placeholder = LocalizedString(@"备注（选项）");
    [self.view addSubview:_noteTextField];
    
    [self.view addSubview:self.addAddressControl];
    self.addAddressControl.x = 0;
    self.addAddressControl.top = _noteTextField.bottom+5;
    WeakSelf(weakSelf);
    _addAddressControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state==YYGestureRecognizerStateBegan) {
            view.alpha = 0.6;
        }
        if (state==YYGestureRecognizerStateEnded) {
            view.alpha=1;
            [weakSelf newContaceAction];
        }
    };
    
    SCContactView *contactView = [[SCContactView alloc]init];
    contactView.x = 0;
    contactView.top = _noteTextField.bottom+5;
    contactView.hidden = YES;
    [contactView setHidenBlock:^{
        self.addAddressControl.hidden = NO;
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

- (YYControl *)addAddressControl
{
    if (!_addAddressControl) {
        _addAddressControl = [YYControl new];
        _addAddressControl.size = CGSizeMake(100, 40);
        
        UIImageView *img = [UIImageView new];
        img.size = CGSizeMake(40, 40);
        img.x = 9;
        img.centerY = _addAddressControl.height/2;
        img.image = IMAGENAME(@"添加地址");
        [_addAddressControl addSubview:img];
        
        UILabel *lab = [UILabel new];
        lab.font = kFont(16);
        lab.textColor = SCOrangeColor;
        lab.text = LocalizedString(@"添加地址");
        [lab sizeToFit];
        lab.y = 3;
        lab.left = img.right;
        [_addAddressControl addSubview:lab];
        _addAddressControl.width = lab.right+marginX;
    }
    return _addAddressControl;
}

#pragma mark - 新建联系人
- (void)newContaceAction
{
    WeakSelf(weakSelf);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [SCAlertCreater addActionTarget:alert titles:self.addressTypeArray color:SCColor(99, 154, 255) action:^(UIAlertAction * _Nonnull action) {
        if([action.title isEqualToString:LocalizedString(@"取消")])return ;
        [weakSelf addAddress:action.title];
    }];
//    [SCAlertCreater addActionTarget:alert titles:@[LocalizedString(@"添加波场地址")] color:SCColor(99, 154, 255) action:^(UIAlertAction * _Nonnull action) {
//        if([action.title isEqualToString:LocalizedString(@"取消")])return ;
//        [weakSelf addAddress:action.title];
//        SCLog(@"---- %@",action.title);
//    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addAddress:(NSString *)typeStr{
    _addAddressControl.hidden = YES;
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
    if ([typeStr isEqualToString:LocalizedString(@"添加ATOM账户名")]) {
        _contactView.contaceType = ADDRESS_TYPE_STRING_ATOM;
    }
}

#pragma mark - 保存
- (void)saveAction
{
    NSString *name = _nameTextField.text;
    NSString *note = _noteTextField.text;
    NSString *address = self.contactView.placeHolderTextView.text;
    NSString *brand = @"";
    if (IsStrEmpty(address)) {
        [TKCommonTools showToast:LocalizedString(@"请填写地址")];
        return;
    }
    BOOL vaAdderss = NO;
    if (self.contactView.contaceType==ADDRESS_TYPE_STRING_BTC) {
        brand = @"BTC";
        vaAdderss = [RewardHelper isBTCAddress:address];
    }
    if (self.contactView.contaceType==ADDRESS_TYPE_STRING_ETH) {
        brand = @"ETH";
        vaAdderss = [RewardHelper isETHAddress:address];
    }
    if (self.contactView.contaceType==ADDRESS_TYPE_STRING_EOS) {
        brand = @"EOS";
        vaAdderss = YES;
    }
    if (self.contactView.contaceType==ADDRESS_TYPE_STRING_IOST) {
        brand = @"IOST";
        vaAdderss = YES;
    }
    if (self.contactView.contaceType==ADDRESS_TYPE_STRING_TRON) {
        brand = @"TRON";
        vaAdderss = [RewardHelper isTronAddress:address];
    }
    if (self.contactView.contaceType==ADDRESS_TYPE_STRING_ATOM) {
        brand = @"ATOM";
        vaAdderss = [RewardHelper isATOMAddress:address];
    }
    if (!vaAdderss) {
        [TKCommonTools showToast:[NSString stringWithFormat:LocalizedString(@"请输入有效%@地址"),brand]];
        return;
    }
    if ([self isBlankString:name]) {
        [TKCommonTools showToast:LocalizedString(@"请填写名称")];
        return;
    }
    
    AddressBookModel *model= [AddressBookModel new];
    model.address = address;
    model.name = name;
    model.note = note;
    model.brand = brand;
    BOOL success = [model bg_save];
    if (success) {
        [TKCommonTools showToast:LocalizedString(@"添加成功")];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
