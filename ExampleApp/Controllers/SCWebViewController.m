//
//  SCWebViewController.m
//  ExampleApp
//
//  Created by ShannonChen on 2017/7/30.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import "SCWebViewController.h"
#import "WKWebViewJavascriptBridge.h"
#import "SCWebViewMessageHandler.h"

@interface SCWebViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) WKWebViewJavascriptBridge *bridge;

@property (copy, nonatomic) NSString *HTMLFileName;
@property (assign, nonatomic) Class messageHandlerClass;

@end

@implementation SCWebViewController

#pragma mark - Life cycle

- (instancetype)initWithHTMLFileName:(NSString *)fileName messageHandlerClass:(__unsafe_unretained Class)messageHandlerClass {
    self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SCWebViewController"];
    if (self) {
        _HTMLFileName = fileName;
        _messageHandlerClass = messageHandlerClass;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) configuration:configuration];
    self.webView.navigationDelegate = self;
    
    [self.view addSubview:self.webView];
    
    // 创建 WKWebViewJavascriptBridge 对象
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    
    // 注册 handler
    SCWebViewMessageHandler *handler = [[self.messageHandlerClass alloc] init];
    handler.controller = self;
    [handler registerHandlersForJSBridge:self.bridge];
    
    // 加载网页
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.HTMLFileName ofType:@"html"];
    NSString *HTMLString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:HTMLString baseURL:nil];
    
    // 显示 loading
    [self.indicatorView startAnimating];
}


#pragma mark - Action
- (void)shareAction {
    
    // 原生调 JS
    [self.bridge callHandler:@"share" data:nil responseCallback:^(id responseData) {
        NSString *shareContent = [NSString stringWithFormat:@"标题：%@\n 内容：%@ \n url：%@",
                                  responseData[@"title"],
                                  responseData[@"content"],
                                  responseData[@"url"]];
        [self showAlertViewWithTitle:@"调用原生分享菜单" message:shareContent];
    }];
    
}

#pragma mark - Action
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}


#pragma mark - <WKNavigationDelegate>

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.indicatorView stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.indicatorView stopAnimating];
}

@end
