//
//  HUMViewController.m
//  HUMDisqusWebViewExample
//
//  Created by Colin Humber on 9/24/13.
//  Copyright (c) 2013 Colin Humber. All rights reserved.
//

#import "HUMViewController.h"
#import "HUMDisqusWebView.h"

@interface HUMViewController ()
@property (nonatomic, weak) IBOutlet HUMDisqusWebView *disqusView;
@end

@implementation HUMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.disqusView.disqusShortname = @"<enter your account shortname>";
	self.disqusView.originalArticleUrl = @"<enter the article's URL>";
	self.disqusView.originalArticleTitle = @"<enter the article's title>";
	self.disqusView.originalArticleIdentifier = @"<enter the article identifier>";
	[self.disqusView loadComments];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
