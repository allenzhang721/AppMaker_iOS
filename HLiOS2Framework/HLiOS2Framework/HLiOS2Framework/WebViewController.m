//
//  WebViewController.m
//  MoueeIOS2Core
//
//  Created by Allen on 12-12-4.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize webView;
@synthesize closeBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void) setupView
{
    if (self.closeBtn == nil)
    {
        self.closeBtn = [[[UIButton alloc] init] autorelease];
        self.closeBtn.backgroundColor = [[UIColor clearColor] autorelease];
        [self.closeBtn addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
        [self.closeBtn setImage:[UIImage imageNamed:@"close_btn.jpg"]  forState:UIControlStateNormal];
        [self.closeBtn setImage:[UIImage imageNamed:@"close_btn_hg.jpg"] forState:UIControlStateHighlighted];
        self.closeBtn.frame = CGRectMake(self.view.frame.size.width - 31, 0, 31, 31);
    }
}

-(void) close
{
    if (self.webView != nil)
    {
        [self.webView stopLoading];
    }
}

-(void) onClose
{
    [self.webView stopLoading];
    [self.closeBtn removeFromSuperview];
    [self.webView removeFromSuperview];
    [self.webView release];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) loadUrl:(NSString *) url
{
    [self.webView removeFromSuperview];
    [self.closeBtn removeFromSuperview];
    self.webView          = [[[UIWebView alloc] init] autorelease];
    self.webView.frame    = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
    NSURL *weburl         = [[NSURL alloc] initWithString:url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:weburl];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.closeBtn];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (self.webView != nil)
    {
        [self.webView release];
    }
    if (self.closeBtn != nil)
    {
        [self.closeBtn release];
    }
    [super dealloc];
}

@end
