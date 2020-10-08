//
//  SCPropertyTableView.m
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/28.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import "SCPropertyTableView.h"
#import "SCPropertyCell.h"


@interface SCPropertyTableView()
<UITableViewDelegate,
UITableViewDataSource,
MGSwipeTableCellDelegate>
@property(strong, nonatomic) UIButton *leftBtn;  //左右滑按钮
@property(strong, nonatomic) UIButton *rightBtn;
@end

@implementation SCPropertyTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame
                              style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    [self reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCPropertyCell"];
    if (!cell) {
        cell = [[SCPropertyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCPropertyCell"];
    }
    if (self.dataArray.count) {
        [cell configModel:self.dataArray[indexPath.row]];
    }
    cell.delegate = self;
    cell.leftButtons = @[self.leftBtn];
    cell.leftSwipeSettings.transition = MGSwipeTransitionClipCenter;

    cell.rightButtons = @[self.rightBtn];
    cell.rightSwipeSettings.transition = MGSwipeTransitionClipCenter;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cancleSelect];
    if ([self.propertyDelegate respondsToSelector:@selector(propertySeleteTableView:)]) {
        [self.propertyDelegate propertySeleteTableView:self.dataArray[indexPath.row]];
    }
}

- (void)cancleSelect
{
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow]animated:YES];
}

#pragma mark - MGSwipeTableCellDelegate
-(void) swipeTableCellWillBeginSwiping:(nonnull MGSwipeTableCell *) cell
{
//    SCLog(@"BBBBBBBB");
}

-(void) swipeTableCellWillEndSwiping:(nonnull MGSwipeTableCell *) cell
{
//    SCLog(@"EEEEEEEE");
}

-(BOOL) swipeTableCell:(nonnull MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction fromPoint:(CGPoint) point
{
//    SCLog(@"======");
    return YES;
}


/**
 * Delegate method invoked when the current swipe state changes
 @param state the current Swipe State
 @param gestureIsActive YES if the user swipe gesture is active. No if the uses has already ended the gesture
 **/
-(void) swipeTableCell:(nonnull MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState) state gestureIsActive:(BOOL) gestureIsActive
{
//    SCLog(@"+++++++");
}

/**
 * Called when the user clicks a swipe button or when a expandable button is automatically triggered
 * @return YES to autohide the current swipe buttons
 **/
-(BOOL) swipeTableCell:(nonnull MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    return YES;
}



- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:IMAGENAME(@"Transfer_icon") forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = kFont(14);
        _leftBtn.size = CGSizeMake(80, 45);
        _leftBtn.centerX = SCREEN_WIDTH/2;
        _leftBtn.backgroundColor = [UIColor colorFromHexString:@"#fcae32"];
        [_leftBtn setTitle:LocalizedString(@"收款") forState:UIControlStateNormal];
        [_leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
        [_leftBtn addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:IMAGENAME(@"Transfer_icon") forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = kFont(14);
        _rightBtn.size = CGSizeMake(80, 45);
        _rightBtn.centerX = SCREEN_WIDTH/2;
        _rightBtn.backgroundColor = [UIColor colorFromHexString:@"#fcae32"];
        [_rightBtn setTitle:LocalizedString(@"转账") forState:UIControlStateNormal];
        [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
        [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 0)];
        [_rightBtn addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}


@end
