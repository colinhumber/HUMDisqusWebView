//
//  HUMDisqusWebView.h
//  test
//
//  Created by Colin Humber on 8/26/13.
//  Copyright (c) 2013 Colin Humber. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HUMDisqusWebViewDelegate;

@interface HUMDisqusWebView : UIView

@property (nonatomic, strong) NSString *disqusShortname;
@property (nonatomic, strong) NSString *originalArticleUrl;
@property (nonatomic, strong) NSString *originalArticleTitle;
@property (nonatomic, strong) NSString *originalArticleIdentifier;
@property (nonatomic, weak) id<HUMDisqusWebViewDelegate> delegate;

- (void)loadComments;
- (void)reload;

@end


@protocol HUMDisqusWebViewDelegate <NSObject>
@optional
- (BOOL)webView:(HUMDisqusWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(HUMDisqusWebView *)webView;
- (void)webViewDidFinishLoad:(HUMDisqusWebView *)webView;
- (void)webView:(HUMDisqusWebView *)webView didFailLoadWithError:(NSError *)error;
@end