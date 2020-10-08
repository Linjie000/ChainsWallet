//
//  DAppDetailViewController.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "DAppDetailViewController.h"
#import "WkDelegateController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AESCrypt.h"
//view
#import "DAppExcuteMutipleActionsBaseView.h"
#import "DappWithoutPasswordView.h"
#import "SCWalletEnterView.h"
//model
#import "DappTransferResult.h"
#import "DappTransferModel.h"
#import "DAppExcuteMutipleActionsResult.h"
#import "DappPushMessageModel.h"
#import "SignatureForMessageModel.h"
//service
#import "DappExcuteActionsDataSourceService.h"
#import "ExcuteMultipleActionsService.h"
#import "DappDetailService.h"

#define JS_INTERACTION_METHOD_PUSH @"push"
#define JS_INTERACTION_METHOD_PUSHACTION @"pushAction"
#define JS_INTERACTION_METHOD_PUSHACTIONS @"pushActions"
#define JS_INTERACTION_METHOD_PUSHMESSAGE @"pushMessage"

#define JS_INTERACTION_METHOD_walletLanguage @"walletLanguage"
#define JS_INTERACTION_METHOD_getEosAccount @"getEosAccount"
#define JS_INTERACTION_METHOD_getWalletWithAccount @"getWalletWithAccount"
#define JS_INTERACTION_METHOD_getEosBalance @"getEosBalance"
#define JS_INTERACTION_METHOD_getEosAccountInfo @"getEosAccountInfo"
#define JS_INTERACTION_METHOD_getTransactionById @"getTransactionById"
#define JS_INTERACTION_METHOD_pushActions @"pushActions"
#define JS_INTERACTION_METHOD_pushTransfer @"pushTransfer"
#define JS_INTERACTION_METHOD_getAppInfo @"getAppInfo"
#define JS_INTERACTION_METHOD_unknown @"unknown"

#define JS_INTERACTION_METHOD_requestSignature @"requestSignature"
#define JS_INTERACTION_METHOD_requestMsgSignature @"requestMsgSignature"


#define JS_METHODNAME_CALLBACKRESULT @"callbackResult"
#define JS_METHODNAME_PUSHACTIONRESULT @"pushActionResult"

#define String_To_URL(str) [NSURL URLWithString: str]

@interface DAppDetailViewController ()
<UIGestureRecognizerDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,UIScrollViewDelegate,WKDelegate,DAppExcuteMutipleActionsBaseViewDelegate,DappWithoutPasswordViewDelegate,ExcuteMultipleActionsServiceDelegate>

@property(nonatomic, strong) WKUserContentController *userContentController;
@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic , strong) WKProcessPool *sharedProcessPool;
@property(nonatomic , assign) BOOL allowZoom;
@property(nonatomic , strong) walletModel *wallet;
@property(nonatomic, copy) NSString *WKScriptMessageName; // recieve WKScriptMessage.name
@property(nonatomic, strong) NSDictionary *WKScriptMessageBody;// recieve WKScriptMessage.body
//model
@property(nonatomic, strong) DappTransferResult *dappTransferResult;
@property(nonatomic, strong) DappTransferModel *dappTransferModel;
@property(nonatomic, strong) DAppExcuteMutipleActionsResult *dAppExcuteMutipleActionsResult;
@property(nonatomic, strong) DAppExcuteMutipleActionsBaseView *dAppExcuteMutipleActionsBaseView;
@property(nonatomic, strong) DappPushMessageModel *dappPushMessageModel;
@property(nonatomic , strong) SignatureForMessageModel *signatureForMessageModel;
//service
@property(nonatomic, strong) DappExcuteActionsDataSourceService *dappExcuteActionsDataSourceService;
@property(nonatomic, strong) ExcuteMultipleActionsService *excuteMultipleActionsService; //签名
@property(nonatomic, strong) DappDetailService *dappDetailService;
//view
@property(nonatomic, strong) DappWithoutPasswordView *dappWithoutPasswordView;
@end

@implementation DAppDetailViewController

//dapp 请求签名确认
- (DAppExcuteMutipleActionsBaseView *)dAppExcuteMutipleActionsBaseView{
    if (!_dAppExcuteMutipleActionsBaseView) {
        _dAppExcuteMutipleActionsBaseView = [[DAppExcuteMutipleActionsBaseView alloc] init];
        _dAppExcuteMutipleActionsBaseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _dAppExcuteMutipleActionsBaseView.delegate = self;
    }
    return _dAppExcuteMutipleActionsBaseView;
}

- (DappExcuteActionsDataSourceService *)dappExcuteActionsDataSourceService{
    if (!_dappExcuteActionsDataSourceService) {
        _dappExcuteActionsDataSourceService = [[DappExcuteActionsDataSourceService alloc] init];
    }
    return _dappExcuteActionsDataSourceService;
}
//免密确认
- (DappWithoutPasswordView *)dappWithoutPasswordView{
    if (!_dappWithoutPasswordView) {
        _dappWithoutPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"DappWithoutPasswordView" owner:nil options:nil] firstObject];
        _dappWithoutPasswordView.frame = self.view.bounds;
        _dappWithoutPasswordView.delegate = self;
    }
    return _dappWithoutPasswordView;
}
//签名service
- (ExcuteMultipleActionsService *)excuteMultipleActionsService{
    if (!_excuteMultipleActionsService) {
        _excuteMultipleActionsService = [[ExcuteMultipleActionsService alloc] init];
        _excuteMultipleActionsService.delegate = self;
    }
    return _excuteMultipleActionsService;
}
//获取账号 区块信息等 基础service
- (DappDetailService *)dappDetailService{
    if (!_dappDetailService) {
        _dappDetailService = [[DappDetailService alloc] init];
        _dappDetailService.delegate = self;
        _dappDetailService.choosedAccountName = self.choosedAccountName;
    }
    return _dappDetailService;
}

- (WKWebView *)webView{
    if (!_webView) {
        //配置环境
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
        self.userContentController =[[WKUserContentController alloc]init];
        configuration.userContentController = self.userContentController;
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:[self getInjectJS] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];// forMainFrameOnly:NO(全局窗口)，yes（只限主窗口）
        [self.userContentController addUserScript:userScript];
        
        
        self.sharedProcessPool = [[WKProcessPool alloc]init];
        configuration.processPool = self.sharedProcessPool;
        
        self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT) configuration:configuration];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        self.webView.scrollView.delegate = self;
        
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:JS_INTERACTION_METHOD_PUSHACTION];
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:JS_INTERACTION_METHOD_PUSH];
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:JS_INTERACTION_METHOD_PUSHACTIONS];
        [self.webView.configuration.userContentController addScriptMessageHandler:self name:JS_INTERACTION_METHOD_PUSHMESSAGE];
        
        
        // 顶部出现空白
        if (@available(iOS 11.0, *)) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            
        }
        if (@available(iOS 9.0, *)) {
            self.webView.customUserAgent = @"ShineChain";
        } else {
            // Fallback on earlier versions
        }
        self.allowZoom = YES;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.choosedAccountName = @"a12353215232";
    walletModel *wallet = [[walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"address"],[NSObject bg_sqlValue:self.choosedAccountName]]]  lastObject];
    self.wallet = wallet;
    [self loadWebView];
    // 给webview添加监听
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    if ([RewardHelper isBlankString:self.webView.title]) {
        [self.webView reload];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    // 因此这里要记得移除handlers
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"pushAction('%@','%@')"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"pushActions('%@','%@')"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"push('%@','%@','%@','%@','%@')"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"pushMessage('%@','%@','%@')"];
}

- (NSString *)getInjectJS{
    //compress_xinxin testScatterSONG
    NSString *JSfilePath = [[NSBundle mainBundle]pathForResource:@"scatter_pe" ofType:@"js"];
    NSString *content = [NSString stringWithContentsOfFile:JSfilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *final = [@"var script = document.createElement('script');"
                       "script.type = 'text/javascript';"
                       "script.text = \""
                       stringByAppendingString:content];
    return final;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil)message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil)style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [TKCommonTools showToast:[error localizedDescription]];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.allowZoom = NO;
    [self passEosAccountNameToJS];
    [self passWalletInfoToJS];
    WeakSelf(weakSelf);
    // 确保js 能收到 eosAccountName
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf passEosAccountNameToJS];
        [weakSelf passWalletInfoToJS];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf passEosAccountNameToJS];
        [weakSelf passWalletInfoToJS];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf passEosAccountNameToJS];
        [weakSelf passWalletInfoToJS];
    });
}

-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@  \n body:%@ \n frameInfo:%@ \n",message.name,message.body,message.frameInfo);
    self.WKScriptMessageName = (NSString *)message.name;
    self.WKScriptMessageBody = (NSDictionary *)message.body;

    if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHACTION] || [self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSH]) {
        self.dappTransferResult = [DappTransferResult mj_objectWithKeyValues:self.WKScriptMessageBody];
        self.dappTransferModel = (DappTransferModel *)[DappTransferModel mj_objectWithKeyValues:[self.dappTransferResult.message mj_JSONObject ] ];
//        [self.view addSubview:self.loginPasswordView];
    }else if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHACTIONS]){
        self.dAppExcuteMutipleActionsResult = [DAppExcuteMutipleActionsResult mj_objectWithKeyValues:self.WKScriptMessageBody];
        [self buildExcuteActionsDataSource];
    }else if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]){
        self.dappPushMessageModel = [DappPushMessageModel mj_objectWithKeyValues:self.WKScriptMessageBody];
        
        if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_getEosAccount]) {
            [self js_pushMessage_method_getEosAccount];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_getAppInfo]){
//            [self js_pushMessage_method_getAppInfo];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_walletLanguage]){
//            [self js_pushMessage_method_walletLanguage];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_getWalletWithAccount]){
//            [self js_pushMessage_method_getWalletWithAccount];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_getEosBalance]){
//            [self js_pushMessage_method_getEosBalance];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_getEosAccountInfo]){
//            [self js_pushMessage_method_getEosAccountInfo];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_getTransactionById]){
//            [self js_pushMessage_method_getTransactionById];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_pushActions]){
//            [self js_pushMessage_method_pushActions];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_pushTransfer]){
//            [self js_pushMessage_method_pushTransfer];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_requestSignature]){
            [self js_pushMessage_method_requestSignature];
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_requestMsgSignature]){
            [self generateSignatureForMessage];
        }else{
//            [self js_pushMessage_method_unknown];
        }
        
    }
}

- (void)loadWebView{
    NSString *requestStr;
    
    if ([self.model.url isEqualToString:@"https://eosflare.io"]) {
        requestStr = [NSString stringWithFormat:@"%@/account/%@",self.model.url,self.choosedAccountName];
    }else{
        requestStr = [NSString stringWithFormat:@"%@",self.model.url];
    }
    
    NSURLRequest *finalRequest = [NSURLRequest requestWithURL:String_To_URL(requestStr)];
    [self.webView loadRequest: finalRequest];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.scrollView.delegate = self;
    [self.view addSubview:self.webView];
    
    //暂时替代返回
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"扫一扫-icon"]  style:UIBarButtonItemStylePlain target:self action:@selector(backNative)];
    self.navigationItem.rightBarButtonItems = @[rightItem];
}

- (void)backNative {
    if([self.webView canGoBack]) {
        //如果有则返回
        [self.webView goBack];
    } 
}

- (void)passEosAccountNameToJS{
    NSString *js = [NSString stringWithFormat:@"getEosAccount('%@')", self.choosedAccountName];
    NSLog(@"responseToJs%@", js);
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //TODO
        NSLog(@"%@ ",response);
        
    }];
}

- (void)passWalletInfoToJS{
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    NSMutableDictionary *walletDict = [[NSMutableDictionary alloc] init];
    [walletDict setValue:self.choosedAccountName forKey:@"account"];
    [walletDict setValue:@"6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b" forKey:@"uid"];
    [walletDict setValue:wallet.name forKey:@"wallet_name"];
    [walletDict setValue:wallet.portrait forKey:@"image"];
    NSString *js = [NSString stringWithFormat:@"getWalletWithAccount('%@')",[walletDict mj_JSONString]];
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //TODO
        NSLog(@"%@ ",response);
    }];
}

- (void)buildExcuteActionsDataSource{
    WeakSelf(weakSelf);
    if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]) {
        self.dappExcuteActionsDataSourceService.actionsResultDict = self.dappPushMessageModel.params;
    }else if([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHACTIONS]){
        self.dappExcuteActionsDataSourceService.actionsResultDict = self.dAppExcuteMutipleActionsResult.actionsDetails;
    }
    
    [self.dappExcuteActionsDataSourceService buildDataSource:^(id service, BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.view addSubview:weakSelf.dAppExcuteMutipleActionsBaseView];
            [weakSelf.dAppExcuteMutipleActionsBaseView updateViewWithArray:weakSelf.dappExcuteActionsDataSourceService.dataSourceArray];
        }
    }];
    
}

#pragma mark - 签名确认 DAppExcuteMutipleActionsBaseViewDelegate
- (void)excuteMutipleActionsConfirmBtnDidClick{
    [self handleExcuteMutipleActions];
//    if (self.dappWithoutPasswordView.savePasswordBtn.selected == YES) {
//        [self handleExcuteMutipleActions];
//    }else{
//        [self.view addSubview:self.dappWithoutPasswordView];
//    }
}
//取消
- (void)excuteMutipleActionsCloseBtnDidClick{
    
    if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]) {
        [self responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:self.dappPushMessageModel.serialNumber andMessage: [ [self handleResponseToJsErrorInfoWithErrorMessage:@"ERROR:CANCLE"] mj_JSONString]];
    }else{
        [self responseToJsWithJSMethodName:JS_METHODNAME_PUSHACTIONRESULT SerialNumber:self.dAppExcuteMutipleActionsResult.serialNumber andMessage:@"ERROR:CANCLE"];
    }
}

- (void)handleExcuteMutipleActions{
    if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]) {
        
        if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_requestSignature]) {
            [self generateScatterSignature];
            
        }else if ([self.dappPushMessageModel.methodName isEqualToString:JS_INTERACTION_METHOD_requestMsgSignature]){
            [self generateSignatureForMessage];
        }
    }else{
//        [self pushActions];
    }
}

- (void)handleEccSignature:(NSString *)signatureStr{
    NSMutableDictionary *finalDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *signDataDict = [NSMutableDictionary dictionary];
    [signDataDict setObject:[NSDictionary dictionary] forKey:@"returnedFields"];
    [signDataDict setObject:@[VALIDATE_STRING(signatureStr)] forKey:@"signatures"];
    
    [dataDict setObject:signDataDict forKey:@"signData"];
    [dataDict setObject:self.dappPushMessageModel.serialNumber forKey:@"serialNumber"];
    [finalDict setObject:dataDict forKey:@"data"];
    [finalDict setObject:@"签名成功" forKey:@"message"];
    [finalDict setObject:@0 forKey:@"code"];
    
    NSLog(@"ScatterResponseToJSfinalJson %@", [finalDict mj_JSONString]);
    [self responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:self.dappPushMessageModel.serialNumber andMessage:[finalDict mj_JSONString]];
 
}

#pragma pushMessageResultResponse callbackResult
- (void)responseToJsWithJSMethodName:(NSString *)jsMethodName SerialNumber:(NSString *)serialNumber andMessage:(NSString *)message{
    NSString *jsStr = [NSString stringWithFormat:@"%@('%@', '%@')", jsMethodName,serialNumber, message];
    NSLog(@"responseToJs %@", jsStr);
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}


#pragma mark -- 输入密码签名  (优化界面)
- (void)generateScatterSignature{
    walletModel *wallet = self.wallet;
    SCWalletEnterView *passwv = [SCWalletEnterView shareInstance];
    passwv.title = self.signatureForMessageModel.whatfor;
    passwv.placeholderStr = self.choosedAccountName;
    NSString *signatureStr = @"";
    __block NSString *signatureStrB = signatureStr;
    WeakSelf(weakSelf);
    [passwv setReturnTextBlock:^(NSString *showText) {
        signatureStrB = [self.excuteMultipleActionsService excuteMultipleActionsForScatterWithScatterResult:self.dappDetailService.requestSignature_scatterResult andAvailable_keysArray:@[VALIDATE_STRING(wallet.account_active_public_key), VALIDATE_STRING(wallet.account_owner_public_key) ] andPassword:showText];
        [weakSelf handleEccSignature:signatureStrB];
    }];

    
}

#pragma mark - 根据dapp 返回的需求操作
- (void)js_pushMessage_method_getEosAccount{
    WeakSelf(weakSelf);
    [self.dappDetailService getEosAccount:^(id service, BOOL isSuccess) {
        [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:weakSelf.dappPushMessageModel.serialNumber andMessage:(NSString *)service];
    }];
}

//请求签名交易 返回代理方法 DappDetailServiceDelegate
- (void)js_pushMessage_method_requestSignature{
    WeakSelf(weakSelf);
    self.dappDetailService.scatter_request_signatureStr = self.dappPushMessageModel.params;
    [self.dappDetailService requestScatterSignature:^(id service, BOOL isSuccess) {
        
        //        [weakSelf responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:weakSelf.dappPushMessageModel.serialNumber andMessage:(NSString *)service];
    }];
}

- (void)js_pushMessage_method_pushTransfer{
    self.dappTransferModel = (DappTransferModel *)[DappTransferModel mj_objectWithKeyValues: [self.dappPushMessageModel.params mj_JSONObject] ];
//    [self.view addSubview:self.loginPasswordView];
}

- (void)generateSignatureForMessage{
    
    self.signatureForMessageModel = [SignatureForMessageModel mj_objectWithKeyValues:self.dappPushMessageModel.params];
    NSString *accountName = [[self.signatureForMessageModel.data componentsSeparatedByString:@" "] firstObject];
    
    walletModel *wallet = self.wallet;
 
    if (![wallet.account_active_public_key isEqualToString:self.signatureForMessageModel.publicKey]) {
        NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
        [resultDict setValue: NSLocalizedString(@"请求授权账户和本地账户不同,请谨慎操作", nil)  forKey:@"data"];
        [resultDict setValue: @1 forKey:@"code"];
        [resultDict setValue:@"error" forKey:@"message"];
        
        [self responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:self.dappPushMessageModel.serialNumber andMessage: [resultDict mj_JSONString]];
        return;
    }
    WeakSelf(weakSelf);
    //MARK: -- : 输入密码授权 后期修改界面
    SCWalletEnterView *passwv = [SCWalletEnterView shareInstance];
    passwv.title = self.signatureForMessageModel.whatfor;
    passwv.placeholderStr = self.choosedAccountName;
    [passwv setReturnTextBlock:^(NSString *showText) {
        [weakSelf accountAuthorizationViewPassWord:showText];
    }];
//    [self.view addSubview: self.accountAuthorizationView];
//    OptionModel *model = [[OptionModel alloc] init];
//    model.optionName = self.choosedAccountName;
//    model.detail = self.signatureForMessageModel.whatfor;
//
//    [self.accountAuthorizationView updateViewWithModel:model];
}

- (NSMutableDictionary *)handleResponseToJsErrorInfoWithErrorMessage:(NSString *)errorMessage{
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    [dataDict setValue: VALIDATE_STRING(self.dappPushMessageModel.serialNumber) forKey:@"serialNumber"];
    [dataDict setValue: VALIDATE_STRING(errorMessage) forKey:@"errorMsg"];
    [resultDict setValue:VALIDATE_NUMBER(@1) forKey:@"code"];
    [resultDict setValue:VALIDATE_STRING(errorMessage) forKey:@"message"];
    [resultDict setValue:dataDict forKey:@"data"];
    return resultDict;
}

//确定授权签名
- (void)accountAuthorizationViewPassWord:(NSString *)password{
    // 验证密码输入是否正确
    walletModel *current_wallet = self.wallet;
    if (![AESCrypt decrypt:current_wallet.password password:password]) {
        [TKCommonTools showToast:LocalizedString(@"密码输入错误!")];
        if ([self.WKScriptMessageName isEqualToString:JS_INTERACTION_METHOD_PUSHMESSAGE]) {
            [self responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:self.dappPushMessageModel.serialNumber andMessage: [ [self handleResponseToJsErrorInfoWithErrorMessage:@"ERROR:Password is invalid. Please check it."] mj_JSONString]];
        }
        return;
    }
    NSString *actor = self.choosedAccountName;
    NSString *message = self.signatureForMessageModel.data;
    
    NSString *signatureStr = [self.excuteMultipleActionsService excuteSignatureMessageForScatterWithActor:actor signatureMessage:message andPassword: password];
    NSMutableDictionary *finalDict = [NSMutableDictionary dictionary];
    [finalDict setObject:@0 forKey:@"code"];
    [finalDict setObject:VALIDATE_STRING(signatureStr) forKey:@"data"];
    [finalDict setObject:@"Signed" forKey:@"message"];
    SCLog(@"ScatterResponseToJSfinalJson %@", [finalDict mj_JSONString]);
    
    [self responseToJsWithJSMethodName:JS_METHODNAME_CALLBACKRESULT SerialNumber:self.dappPushMessageModel.serialNumber andMessage:[finalDict mj_JSONString]];
 
}

#pragma mark - 签名确认
- (void)scatterBuildExcuteActionsDataSourceDidSuccess:(NSArray *)scatterActions{
    
    [self.view addSubview:self.dAppExcuteMutipleActionsBaseView];
    [self.dAppExcuteMutipleActionsBaseView updateViewWithArray:scatterActions];
}


@end
