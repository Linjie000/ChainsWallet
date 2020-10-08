//
//  DAppExcuteMutipleActionsBaseView.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "DAppExcuteMutipleActionsBaseView.h"
#define CONTENT_BASE_VIEW_HEIGHT 240.0f

#define TITLE_IMAGEVIEW_HEIGHT 94.0f

#define PAGE_CONTROL_HEIGHT 35.0f

#define CONFIRM_BUTTON_HEIGHT 46.0f

#import "DAppExcuteMutipleActionsBaseView.h"
#import "ExcuteActions.h"
#import "ExcuteActionsResult.h"
#import "DAppExcuteActionsContentCell.h"
#import "SCCommonBtn.h"

@interface DAppExcuteMutipleActionsBaseView()<UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
 
@property(nonatomic , strong) UIView *topBaseView;

@property(nonatomic , strong) UIImageView *titleImageView;

@property(nonatomic , strong) UILabel *titleLabel;

@property(nonatomic , strong) UIView *line1;

@property(nonatomic , strong) UIView *contentBaseView;

@property(nonatomic , strong) UIScrollView *mainScrollView;

@property(nonatomic , strong) UIPageControl *pageControl;



@property(nonatomic , strong) UILabel *confirmBtn;


@property(nonatomic , assign) BOOL hasViewAllAction;

@end


@implementation DAppExcuteMutipleActionsBaseView

- (UIView *)topBaseView{
    if (!_topBaseView) {
        _topBaseView = [[UIView alloc] init];
        WeakSelf(weakSelf);
        [_topBaseView setTapActionWithBlock:^{
            [weakSelf removeFromSuperview];
        }];
    }
    return _topBaseView;
}


- (UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
//        _titleImageView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
        _titleImageView.image = IMAGENAME(@"dapp_transfer_titleimg");
        _titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _titleImageView;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = HEXCOLOR(0xEEEEEE);
    }
    return _line1;
}

- (UIView *)contentBaseView{
    if (!_contentBaseView) {
        _contentBaseView = [[UIView alloc] init];
    }
    return _contentBaseView;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, CONTENT_BASE_VIEW_HEIGHT))];
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.actionsArray.count, CONTENT_BASE_VIEW_HEIGHT);
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.delegate = self;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _mainScrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        // 设置总页数
        _pageControl.numberOfPages = self.actionsArray.count;
        _pageControl.pageIndicatorTintColor = HEXCOLOR(0xD8D8D8);
        // 设置当前所在页数
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = MainColor;
        [_pageControl addTarget:self action:@selector(pageControlValueChange:) forControlEvents:UIControlEventValueChanged];
        _pageControl.enabled = NO;
        _pageControl.backgroundColor = HEXCOLOR(0xFFFFFF);
    }
    return _pageControl;
}

- (UILabel *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UILabel new];
        _confirmBtn.text = LocalizedString(@"确认签名");
        _confirmBtn.backgroundColor = SCOrangeColor;
        _confirmBtn.textAlignment = NSTextAlignmentCenter;
        _confirmBtn.textColor = [UIColor whiteColor];
//        _confirmBtn.width = self.width;
//        _confirmBtn.height = self.height;
        _confirmBtn.font = kFont(15);
        WeakSelf(weakSelf);
        [_confirmBtn setTapActionWithBlock:^{
            [weakSelf excuteMutipleActionsConfirmBtnClick];
        }];
    }
    return _confirmBtn;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBtnClick)];
        tap.delegate = self;
        [self.topBaseView addGestureRecognizer:tap];
    }
    return self;
}



- (void)updateViewWithArray:(NSArray *)dataArray{
    self.actionsArray = [NSMutableArray arrayWithArray:dataArray];
    
    [self addSubview:self.topBaseView];
    self.topBaseView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(SCREEN_HEIGHT - NAVIBAR_HEIGHT -  TITLE_IMAGEVIEW_HEIGHT - CONTENT_BASE_VIEW_HEIGHT - PAGE_CONTROL_HEIGHT -  CONFIRM_BUTTON_HEIGHT);
    
    [self addSubview:self.titleImageView];
    self.titleImageView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.topBaseView, 0).rightSpaceToView(self, 0).heightIs(TITLE_IMAGEVIEW_HEIGHT);
    
    [self addSubview:self.contentBaseView];
    self.contentBaseView.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.titleImageView, 0).rightSpaceToView(self, 0).heightIs(CONTENT_BASE_VIEW_HEIGHT);
    
    // mainScrollView
    [self.contentBaseView addSubview:self.mainScrollView];
    for (int i = 0 ; i < dataArray.count; i++) {
        ExcuteActions *action = self.actionsArray[i];
        DAppExcuteActionsContentCell *cell = [[DAppExcuteActionsContentCell alloc] initWithFrame:(CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, CONTENT_BASE_VIEW_HEIGHT))];
        cell.model = action;
        [self.mainScrollView addSubview:cell];
    }
    
    [self addSubview:self.pageControl];
    self.pageControl.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.contentBaseView, 0).rightSpaceToView(self, 0).heightIs(PAGE_CONTROL_HEIGHT);
    
    [self addSubview:self.confirmBtn];
    
    self.confirmBtn.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self.pageControl, 0).rightSpaceToView(self, 0).heightIs(CONFIRM_BUTTON_HEIGHT);
  
    if (self.actionsArray.count==1) {
        self.hasViewAllAction = YES;
        self.confirmBtn.backgroundColor = MainColor;
    }else{
        self.confirmBtn.backgroundColor = SCGray(240);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x_offset = scrollView.contentOffset.x;
    self.pageControl.currentPage = x_offset / SCREEN_WIDTH;
    
    if (self.pageControl.currentPage == self.actionsArray.count- 1) {
        self.hasViewAllAction = YES;
        self.confirmBtn.backgroundColor = MainColor;
    }
}

- (void)pageControlValueChange:(UIPageControl *)pageControl{
    NSLog(@"%ld", pageControl.currentPage);
}

- (void)closeBtnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(excuteMutipleActionsCloseBtnDidClick)]) {
        [self.delegate excuteMutipleActionsCloseBtnDidClick];
    }
}


- (void)excuteMutipleActionsConfirmBtnClick{
    if (self.hasViewAllAction == YES) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(excuteMutipleActionsConfirmBtnDidClick)]) {
            [self.delegate excuteMutipleActionsConfirmBtnDidClick];
        }
    }else{
        [TKCommonTools showToast:NSLocalizedString(@"请查看所有签名内容后再确认", nil)];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isEqual:self.contentBaseView]) {
        return NO;
        
    }else{
        return YES;
    }
}

@end
