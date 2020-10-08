# FCXRefresh
常用的上下拉刷新功能都支持可自定义，只需简单的两三行代码即可完成，主要支持以下功能：
* 普通上下拉刷新
* 自动上下拉刷新
* 上拉无更多数据控制
* 上下拉百分比显示
* 自定义上下拉动画

## 如何导入
* 1.手动导入
```objc
  把FCXRefresh文件夹导入即可
```
* 2.使用CocoaPods
```objc
  pod 'FCXRefresh'
```

## 如何使用
包含头文件
```objc
#import "UIScrollView+FCXRefresh.h"
```
添加上下拉刷新
```objc
//下拉刷新
_refreshHeaderView = [self.tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
[weakSelf refreshAction];
}];

//上拉加载更多
_refreshFooterView = [self.tableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
[weakSelf loadMoreAction];
}];
```
自动上下拉刷新设置
```objc
[_refreshHeaderView autoRefresh];
_refreshFooterView.autoLoadMore = YES;
```
上下拉百分比显示
```objc
_refreshHeaderView.pullingPercentHandler = ^(CGFloat pullingPercent) {
    headerPercentLabel.text = [NSString stringWithFormat:@"%.2f%%", pullingPercent * 100];
};

_refreshFooterView.pullingPercentHandler = ^(CGFloat pullingPercent) {
    footerPercentLabel.text = [NSString stringWithFormat:@"%.2f%%", pullingPercent * 100];
};
```
显示效果：
![](refreshGif.gif)


