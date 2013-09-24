HUMDisqusWebView
================

Wrapper around a UIWebView for displaying Disqus comments using Disqus's Javascript embed in native apps mechanism (http://help.disqus.com/customer/portal/articles/472096-javacript-embed-in-native-apps). HUMDisqusWebView handles all the Javascript setup and handling logins.

This class doesn't inherit from UIWebView but forwards the UIWebView's public methods to a wrapped instance.

HUMDisqusWebView is tested on iOS 6+ and requires ARC.

Installation
============
Add the files from HUMDisqusWebView to your project.
- HUMDisqusWebView.h
- HUMDisqusWebView.m
- disqus.html

Usage
=====
Setup an instance of a HUMDisqusWebView by setting the following properties:
- ```disqusShortname```
- ```originalArticleUrl```
- ```originalArticleTitle```
- ```originalArticleIdentifier```

Then call ```-loadComments```. The values set in the above properties will be passed to the disqus.html template and will load the comments.

Details on what each property describes can be found Disqus's [documentation](http://help.disqus.com/customer/portal/articles/472096-javacript-embed-in-native-apps) on embedding comments in native apps.
