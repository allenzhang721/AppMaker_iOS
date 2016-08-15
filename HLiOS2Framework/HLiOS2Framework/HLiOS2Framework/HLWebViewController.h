//
//  WebViewController.h
//  MoueeIOS2Core
//
//  Created by Allen on 12-12-4.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLWebViewController : UIViewController
{
    
}

@property (nonatomic , retain) UIWebView *webView;
@property (nonatomic , retain) UIButton  *closeBtn;

-(void) setupView;
-(void) loadUrl:(NSString *) url;
-(void) close;
@end
