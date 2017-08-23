//
//  UIWebView+JavaScriptAlert.m
//  ExampleApp
//
//  Created by 刘雨轩 on 2017/8/23.
//  Copyright © 2017年 ShannonChen. All rights reserved.
//

#import "UIWebView+JavaScriptAlert.h"

static BOOL diagStat = NO;
static NSInteger bIdx = -1;

@implementation UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    UIAlertView* dialogue = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"标题", nil) message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [dialogue show];
}

- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    
    diagStat = NO;
    
    bIdx = -1;
    
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定",  nil];
    
    [confirmDiag show];
    
    while (bIdx==-1) {
        //[NSThread sleepForTimeInterval:0.2];
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    }
    if (bIdx == 0){//取消;
        diagStat = NO;
    }
    else if (bIdx == 1) {//确定;
        diagStat = YES;
    }
    return diagStat;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    bIdx = buttonIndex;
}

- (NSString *)webView:(UIWebView *)view runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)text initiatedByFrame:(id)frame{
    
    diagStat = NO;
    
    bIdx = -1;
    
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                          message:prompt
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定",  nil];
    
    
    [confirmDiag setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    UITextField *textField = [confirmDiag textFieldAtIndex:0];
    textField.placeholder = @"请输入信息";
    textField.keyboardType = UIKeyboardTypeDefault;
    
    
    [confirmDiag show];
    
    while (bIdx==-1) {
        //[NSThread sleepForTimeInterval:0.2];
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    }
    if (bIdx == 0){//取消;
        diagStat = NO;
    }
    else if (bIdx == 1) {//确定;
        diagStat = YES;
    }
    return textField.text;
    
}

@end
