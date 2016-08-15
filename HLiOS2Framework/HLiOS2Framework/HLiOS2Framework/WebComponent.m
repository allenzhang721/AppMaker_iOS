//
//  WebComponent.m
//  MoueeTest
//
//  Created by Pi Yi on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WebComponent.h"
#import "HLContainer.h"
#import "WebEntity.h"

@implementation WebComponent
@synthesize request;

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        NSURL *url = [[[NSURL alloc] initWithString:((WebEntity*)entity).url] autorelease];
        UIView *view = [[[UIView alloc] initWithFrame:CGRectNull] autorelease];
        NSURLRequest *re = [[[NSURLRequest alloc] initWithURL:url] autorelease];
        self.request = re;
        curWebView = [[[UIWebView alloc] init] autorelease];
        curWebView.delegate = self;
        curWebView.frame = CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue]);
        [view addSubview:curWebView];
        self.uicomponent = view;
        curWebView.hidden = YES;
    }
    return self;
}

//-(id) initWithPath:(NSString*) path width:(float)width height:(float)height
//{
//    self = [super init];
//	if (self != nil) 
//	{
//        NSURL *url = [[[NSURL alloc] initWithString:path] autorelease];
////        NSString *str = @"http://map.sogou.com/m/iphone/";
//        
////        NSString * str1 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        
////        NSURL *url = [[[NSURL alloc] initWithString:str1] autorelease];
//
//        
//        UIView *view = [[[UIView alloc] initWithFrame:CGRectNull] autorelease];
//        NSURLRequest *re = [[[NSURLRequest alloc] initWithURL:url] autorelease];
//        self.request = re;
//        curWebView = [[[UIWebView alloc] init] autorelease];
//        curWebView.delegate = self;
////        self.uicomponent = webView;
//        
//        curWebView.frame = CGRectMake(0, 0, width, height);
//        [view addSubview:curWebView];
//        self.uicomponent = view;
//        curWebView.hidden = YES;
//        
//    }
//	return self;
//}



-(void) beginView
{
    [super beginView];
    [self play];
}

- (void)changeUrl:(NSString *)newUrl
{
    if (!newUrl) 
    {
        return;
    }
    NSURLRequest *re = [[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl]] autorelease];
//    [((UIWebView*)self.uicomponent) loadRequest:re];
    [curWebView loadRequest:re];
}


-(void) play
{
//    [((UIWebView*)self.uicomponent) loadRequest:self.request];
    [curWebView loadRequest:self.request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //    self.uicomponent
    if (!activeView) {
        activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activeView.frame = CGRectMake(webView.frame.size.width / 2 - activeView.frame.size.width / 2, webView.frame.size.height / 2 - activeView.frame.size.height / 2, activeView.frame.size.width, activeView.frame.size.height);
        [self.uicomponent addSubview:activeView];
    }
   [activeView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (!self.hidden) 
    {
        curWebView.hidden = NO;
    }
    if (!webView.isLoading)
    {
        activeView.hidden = YES;
        [activeView stopAnimating];
    }
}

- (void)dealloc 
{
    [activeView stopAnimating];
    [activeView release];
    [self.uicomponent removeFromSuperview];
	[self.uicomponent release];
    [self.request release];
    [super dealloc];
}
@end
