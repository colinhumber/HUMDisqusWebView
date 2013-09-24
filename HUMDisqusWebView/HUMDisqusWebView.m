//
//  HUMDisqusWebView.m
//  test
//
//  Created by Colin Humber on 8/26/13.
//  Copyright (c) 2013 Colin Humber. All rights reserved.
//

#import "HUMDisqusWebView.h"

static NSString *const kHUMLoginSuccessUrl			= @"disqus.com/next/login-success";
static NSString *const kHUMLoginSuccessGoogleUrl	= @"disqus.com/_ax/twitter/complete";
static NSString *const kHUMLoginSuccessTwitterUrl	= @"disqus.com/_ax/google/complete";
static NSString *const kHUMLoginSuccessFacebookUrl	= @"disqus.com/_ax/facebook/complete";
static NSString *const kHUMLoginCancelUrlFormat		= @"disqus.com/next/login/?forum=%@#";

@interface HUMDisqusWebView () <UIWebViewDelegate> {
	struct {
		unsigned int delegateShouldStartLoadWithRequest:1;
		unsigned int delegateDidStartLoad:1;
		unsigned int delegateDidFinishLoad:1;
		unsigned int delegateDidFailLoadWithError:1;
	} _delegateFlags;
}

@property (nonatomic, strong) NSString *disqusHTML;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation HUMDisqusWebView

#pragma mark - UIView
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self setup];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.webView.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

#pragma mark - Accessors
- (UIWebView *)webView {
	if (!_webView) {
		_webView = [[UIWebView alloc] initWithFrame:self.bounds];
		_webView.autoresizingMask = self.autoresizingMask;
		_webView.delegate = self;
	}
	
	return _webView;
}

- (void)setDelegate:(id<HUMDisqusWebViewDelegate>)delegate {
	_delegate = delegate;
	
	_delegateFlags.delegateShouldStartLoadWithRequest = [_delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)];
	_delegateFlags.delegateDidStartLoad = [_delegate respondsToSelector:@selector(webViewDidStartLoad:)];
	_delegateFlags.delegateDidFinishLoad = [_delegate respondsToSelector:@selector(webViewDidFinishLoad:)];
	_delegateFlags.delegateDidFailLoadWithError = [_delegate respondsToSelector:@selector(webView:didFailLoadWithError:)];
}


#pragma mark - Helpers
- (NSString *)formattedDisqusHTML {
	return [NSString stringWithFormat:self.disqusHTML, self.originalArticleUrl, self.originalArticleTitle, self.disqusShortname, self.originalArticleIdentifier];
}

- (NSString *)cancelUrlString {
	return [NSString stringWithFormat:kHUMLoginCancelUrlFormat, self.disqusShortname];
}

- (BOOL)didCompleteLogin:(NSURL *)url {
	NSString *urlPath = url.absoluteString;
	
	return [urlPath rangeOfString:kHUMLoginSuccessUrl].location != NSNotFound ||
			[urlPath rangeOfString:kHUMLoginSuccessTwitterUrl].location != NSNotFound ||
			[urlPath rangeOfString:kHUMLoginSuccessGoogleUrl].location != NSNotFound ||
			[urlPath rangeOfString:kHUMLoginSuccessFacebookUrl].location != NSNotFound;
}

- (BOOL)didCancelLogin:(NSURL *)url {
	NSString *urlPath = url.absoluteString;

	return [urlPath rangeOfString:[self cancelUrlString]].location != NSNotFound;
}

#pragma mark - Comments
- (void)loadComments {
	NSAssert(self.disqusShortname != nil, @"You must provide the shortname for your Disqus forum.");
	NSAssert(self.originalArticleUrl != nil, @"You must provide the original article URL.");
	NSAssert(self.originalArticleTitle != nil, @"You must provide the original article title.");
	NSAssert(self.originalArticleIdentifier != nil, @"You must provide the original article identifier.");
	
	[self.webView loadHTMLString:self.formattedDisqusHTML
						 baseURL:nil];
}

#pragma mark - UIWebView
- (void)reload {
	[self loadComments];
}

- (BOOL)canGoBack {
	return [self.webView canGoBack];
}

- (BOOL)canGoForward {
	return [self.webView canGoForward];
}

- (void)setDataDetectorTypes:(UIDataDetectorTypes)types {
	[self.webView setDataDetectorTypes:types];
}

- (UIDataDetectorTypes)dataDetectorTypes {
	return [self.webView dataDetectorTypes];
}

- (BOOL)isLoading {
	return [self.webView isLoading];
}

- (NSURLRequest *)request {
	return [self.webView request];
}

- (BOOL)scalesPageToFit {
	return [self.webView scalesPageToFit];
}

- (void)setScalesPageToFit:(BOOL)scales {
	[self.webView setScalesPageToFit:scales];
}

- (void)goBack {
	[self.webView goBack];
}

- (void)goForward {
	[self.webView goForward];
}

- (void)stopLoading {
	[self.webView stopLoading];
}

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)string {
	return [self.webView stringByEvaluatingJavaScriptFromString:string];
}

- (UIScrollView *)scrollView {
	return self.webView.scrollView;
}

- (BOOL)allowsInlineMediaPlayback {
	return self.webView.allowsInlineMediaPlayback;
}

- (void)setAllowsInlineMediaPlayback:(BOOL)allow {
	self.webView.allowsInlineMediaPlayback = allow;
}

- (BOOL)mediaPlaybackRequiresUserAction {
	return self.webView.mediaPlaybackRequiresUserAction;
}

- (void)setMediaPlaybackRequiresUserAction:(BOOL)requires {
	self.webView.mediaPlaybackRequiresUserAction = requires;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	BOOL shouldStart = YES;
	
	if (_delegateFlags.delegateShouldStartLoadWithRequest) {
		shouldStart = [_delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
	}
	
	if ([self didCompleteLogin:request.URL] || [self didCancelLogin:request.URL]) {
		[self loadComments];
		return NO;
	}
	
	return YES;
}

- (void)webViewDidStartLoad:(HUMDisqusWebView *)webView {
	if (_delegateFlags.delegateDidStartLoad) {
		[_delegate webViewDidStartLoad:self];
	}
}

- (void)webViewDidFinishLoad:(HUMDisqusWebView *)webView {
	if (_delegateFlags.delegateDidFinishLoad) {
		[_delegate webViewDidFinishLoad:self];
	}
}

- (void)webView:(HUMDisqusWebView *)webView didFailLoadWithError:(NSError *)error {
	if (_delegateFlags.delegateDidFailLoadWithError) {
		[_delegate webView:self didFailLoadWithError:error];
	}
}

#pragma mark - Private
- (void)setup {
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.backgroundColor = [UIColor whiteColor];
	self.opaque = YES;
	
	[self addSubview:self.webView];
	
	NSError *error;
	NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"disqus" ofType:@"html"];
	self.disqusHTML = [NSString stringWithContentsOfFile:htmlPath
												encoding:NSUTF8StringEncoding
												   error:&error];
	
	if (error) {
		NSLog(@"Unable to read disqus.html. Did you add it to the application bundle? Error: %@", error);
		return;
	}
}


@end
