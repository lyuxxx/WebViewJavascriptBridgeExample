//
//  UIWebView+JavaScriptAlert.h
//  ExampleApp
//
//  Created by 刘雨轩 on 2017/8/23.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (JavaScriptAlert)

//alert
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

//confirm
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;

//prompt
- (NSString *)webView:(UIWebView *)view runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)text initiatedByFrame:(id)frame;

@end
