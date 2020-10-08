//
//  WKWebViewConfiguration+config.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "WKWebViewConfiguration+config.h"

@implementation WKWebViewConfiguration (config)

+ (instancetype)makeAddress:(NSString *)address delegate:(id<WKScriptMessageHandler>)handler
{
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    
    NSString *js = @"const TronWeb = require('tronweb')"
         // This provider is optional, you can just use a url for the nodes instead
         "const HttpProvider = TronWeb.providers.HttpProvider;"
         "const fullNode = new HttpProvider('https://api.trongrid.io'); // Full node http endpoint"
         "const solidityNode = new HttpProvider('https://api.trongrid.io');" // Solidity node http endpoint"
         "const eventServer = new HttpProvider('https://api.trongrid.io');" // Contract events http endpoint
    
         "const privateKey = 'da146374a75310b9666e834ee4ad0866d6f4035967bfc76217c5a495fff9f0d0';"
    
         "const tronWeb = new TronWeb("
         "fullNode,"
         "solidityNode,"
         "eventServer,"
         " privateKey"
         ");";
    
//    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"TrustWeb3Provider" ofType:@"bundle"];
//    NSBundle *bundel = [NSBundle bundleWithPath:bundlePath];
//    NSString *filePath = [bundel pathForResource:@"Tron-min" ofType:@"js"];
//
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Tron-min" ofType:@"js"];
//    js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
//    NSString *conStr = [NSString stringWithFormat: @"  const addressHex = %@ const rpcURL = %@  const chainID = 1  function executeCallback (id, error, value) { Trust.executeCallback(id, error, value) } Trust.init(rpcURL, { getAccounts: function (cb) { cb(null, [addressHex]) }, processTransaction: function (tx, cb){ console.log('signing a transaction', tx) const { id = 8888 } = tx Trust.addCallback(id, cb) webkit.messageHandlers.signTransaction.postMessage({\"name\": \"signTransaction\", \"object\": tx, id: id}) }, signMessage: function (msgParams, cb) { const { data } = msgParams const { id = 8888 } = msgParams console.log(\"signing a message\", msgParams) Trust.addCallback(id, cb) webkit.messageHandlers.signMessage.postMessage({\"name\": \"signMessage\", \"object\": { data }, id: id}) }, signPersonalMessage: function (msgParams, cb) { const { data } = msgParams const { id = 8888 } = msgParams console.log(\"signing a personal message\", msgParams) Trust.addCallback(id, cb) webkit.messageHandlers.signPersonalMessage.postMessage({\"name\": \"signPersonalMessage\", \"object\": { data }, id: id}) }, signTypedMessage: function (msgParams, cb) { const { data } = msgParams const { id = 8888 } = msgParams console.log(\"signing a typed message\", msgParams) Trust.addCallback(id, cb) webkit.messageHandlers.signTypedMessage.postMessage({\"name\": \"signTypedMessage\", \"object\": { data }, id: id}) } }, { address: addressHex, networkVersion: chainID }) web3.setProvider = function () { console.debug('Trust Wallet - overrode web3.setProvider') } web3.eth.defaultAccount = addressHex web3.version.getNetwork = function(cb) { cb(null, chainID) } web3.eth.getCoinbase = function(cb) { return cb(null, addressHex) }  ",address.description.lowercaseString,@"https://mainnet.infura.io/llyrtzQ3YhkdESt2Fzrk"];
//
//    js = [NSString stringWithFormat:@"%@%@",js,conStr];
 
    WKUserScript *userScript = [[WKUserScript alloc]initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [config.userContentController addScriptMessageHandler:handler name:@"createAccount"];
    [config.userContentController addScriptMessageHandler:handler name:@"getBalance"];
    [config.userContentController addScriptMessageHandler:handler name:@"sign"];
    [config.userContentController addScriptMessageHandler:handler name:@"login"];
    [config.userContentController addScriptMessageHandler:handler name:@"waitForGlobal"];
    [config.userContentController addScriptMessageHandler:handler name:@"tronApi"];
    [config.userContentController addUserScript:userScript];
    return config;
}

@end
