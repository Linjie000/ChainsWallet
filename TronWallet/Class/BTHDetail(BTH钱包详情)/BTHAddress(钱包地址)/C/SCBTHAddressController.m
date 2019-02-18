//
//  SCBTHAddressController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/17.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCBTHAddressController.h"
#import "SCBTHAddressChangeCell.h"

@interface SCBTHAddressController ()
<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic) UITableView *tableView;

@property(strong, nonatomic) UIView *tableHeadView;
@property(strong, nonatomic) UIView *tableAddAddressView;
@end

@implementation SCBTHAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"钱包地址");
    [self subViews];
}

- (void)subViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self tableHeadView];
    _tableView.backgroundColor = SCGray(245);
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = 0;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCBTHAddressChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCBTHAddressChangeCell"];
    if (!cell) {
        cell = [[SCBTHAddressChangeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCBTHAddressChangeCell"];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableAddAddressView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}

- (UIView *)tableHeadView
{
    if (!_tableHeadView) {
        
        UIFont *detailFont = kFont(13);
        NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:LocalizedString(@"你可以在一个比特币钱包下添加多个不同的子地址来避免地址重用以保护你的隐私；\n标记•为未使用过的地址；\n选中的地址将作为默认地址显示在收款页面。") attributes:@{NSKernAttributeName:@(1)}];
        detailText.font = detailFont;
        detailText.color = SCGray(128);
        NSRange rang = [[detailText string] rangeOfString:@"•"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [detailText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailText length])];
        [detailText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rang];
        paragraphStyle.lineSpacing = 8;
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;//防止文字存在中英文空出太多
        YYTextContainer *detailContainer = [YYTextContainer containerWithSize:CGSizeMake(SCREEN_WIDTH-30, CGFLOAT_MAX)];
        YYLabel *lab = [YYLabel new];
        YYTextLayout *detailLayout = [YYTextLayout layoutWithContainer:detailContainer text:detailText];
        lab.size = detailLayout.textBoundingSize;
        lab.textLayout = detailLayout;
        lab.x = 15;
        lab.y = 10;

        _tableHeadView = [UIView new];
        _tableHeadView.backgroundColor = [UIColor whiteColor];
        _tableHeadView.width = SCREEN_WIDTH;
        _tableHeadView.height = detailLayout.textBoundingSize.height + 20;
        [_tableHeadView addSubview:lab];
    }
    return _tableHeadView;
}

- (UIView *)tableAddAddressView
{
    if (!_tableAddAddressView) {
        _tableAddAddressView = [UIView new];
        _tableAddAddressView.size = CGSizeMake(SCREEN_WIDTH, 38);
        _tableAddAddressView.backgroundColor = SCGray(245);
        
        UILabel *t = [UILabel new];
        t.size = CGSizeMake(60, _tableAddAddressView.height);
        t.font = kFont(15);
        t.textColor = SCGray(120);
        t.x = 15;
        t.y = 0;
        t.text = @"子地址";
        [_tableAddAddressView addSubview:t];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.size = CGSizeMake(60, _tableAddAddressView.height);
        button.right = SCREEN_WIDTH;
        button.y = 0;
        button.backgroundColor = [UIColor clearColor];
        //设置button正常状态下的图片
        [button setImage:[UIImage imageNamed:@"10.5_Add-to_icon"] forState:UIControlStateNormal];
        //设置button高亮状态下的图片
        [button setImage:[UIImage imageNamed:@"10.5_Add-to_icon"] forState:UIControlStateHighlighted];
        //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 60);
        [button setTitle:LocalizedString(@"添加") forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        //设置button正常状态下的标题颜色
        [button setTitleColor:SCPurpleColor forState:UIControlStateNormal];
        //设置button高亮状态下的标题颜色
        [button setTitleColor:SCPurpleColor forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_tableAddAddressView addSubview:button];
 
    }
    return _tableAddAddressView;
}

@end
