//
//  SharePopupViewController.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/29/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "SharePopupViewController.h"
#import "MagazinePopupViewController.h"
#import "appMaker.h"

@interface SharePopupViewController ()

@end

@implementation SharePopupViewController
@synthesize imgView;
@synthesize textField;
@synthesize btnPublish;
@synthesize btnUser;
@synthesize bgImg;
@synthesize textBgImg;
@synthesize mpViewController;
@synthesize snappath;
@synthesize waitAlert;
@synthesize btnState;
@synthesize btnLogin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bgImg    = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sns_bg.png"]] autorelease];
    self.btnClose = [[[UIButton alloc] init] autorelease];
    self.textField = [[[UITextView alloc] init] autorelease];
    self.textBgImg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"text_bg.png"]] autorelease];
    self.imgView   = [[[UIImageView alloc] init] autorelease];
    [self.btnClose setImage:[UIImage imageNamed:@"close_btn_n.png"] forState:UIControlStateNormal];
    self.btnPublish = [[[UIButton alloc] init] autorelease];
    [self.btnPublish setImage:[UIImage imageNamed:@"sc_send_btn_n.png"] forState:UIControlStateNormal];
    [self.btnPublish addTarget:self action:@selector(onPublish) forControlEvents:UIControlEventTouchUpInside];
    [self.btnClose setImage:[UIImage imageNamed:@"close_btn_h.png"] forState:UIControlStateHighlighted];
    [self.btnClose addTarget:self action:@selector(onClose) forControlEvents:UIControlEventTouchUpInside];
    self.btnState  = [[[UIButton alloc] init] autorelease];
    self.btnState.userInteractionEnabled = NO;
    [self.btnState setImage:[UIImage imageNamed:@"sns_logout.png"] forState:UIControlStateNormal];
    [self.btnState setImage:[UIImage imageNamed:@"sns_login.png"] forState:UIControlStateSelected];
    self.btnLogin  = [[[UIButton alloc] init] autorelease];
    [self.btnLogin setImage:[UIImage imageNamed:@"sns_logout_btn.png"] forState:UIControlStateNormal];
//    self.sinaWeibo = [[[SinaWeibo alloc] initWithAppKey:@"" appSecret:@"" appRedirectURI:@"" andDelegate:self] autorelease];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
//    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
//    {
//        self.sinaWeibo .accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
//        self.sinaWeibo .expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
//        self.sinaWeibo .userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
//    }
//    if ([self.sinaWeibo isAuthValid] == YES)
//    {
//        self.btnState.selected = YES;
//    }
//    else
//    {
//        self.btnState.selected = NO;
//    }
    self.btnLogin.hidden  = !self.btnState.selected;
    [self.btnLogin addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchDown];
	// Do any additional setup after loading the view.
}

-(void) onLogin
{
    [self showWait];
//    [self.sinaWeibo logOut];
   
}

//- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
//{
//    [self.waitAlert dismissWithClickedButtonIndex:0 animated:YES];
//    self.btnLogin.hidden   = YES;
//    self.btnState.selected = NO;
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
//
//}
//

-(void) onPublish
{
//    [self.sinaWeibo logIn];
}

//- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
//{
//    [self showWait];
//    self.btnLogin.hidden   = NO;
//    self.btnState.selected = YES;
//    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
//                              self.sinaWeibo.accessToken, @"AccessTokenKey",
//                              self.sinaWeibo.expirationDate, @"ExpirationDateKey",
//                              self.sinaWeibo.userID, @"UserIDKey",
//                              self.sinaWeibo.refreshToken, @"refresh_token", nil];
//    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//   
//    [self.sinaWeibo requestWithURL:@"statuses/upload.json"
//                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                               self.textField.text, @"status",
//                               [UIImage imageWithContentsOfFile:self.snappath], @"pic", nil]
//                   httpMethod:@"POST"
//                     delegate:self];
//    
//}

-(void) showWait
{
    if(self.waitAlert == nil)
    {
        self.waitAlert = [[[UIAlertView alloc] initWithTitle:@"请稍等"
                                          message:nil
                                          delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil] autorelease];
        UIActivityIndicatorView *act = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        act.frame = CGRectMake(117, 40, 50, 50);
        [act startAnimating];
        [self.waitAlert addSubview:act];
    }
    [self.waitAlert show];
    
}

//- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
//{
//    [self.waitAlert dismissWithClickedButtonIndex:0 animated:YES];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"微博发表失败，请检查网络"
//                                                       delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alertView show];
//    [alertView release];
//}
//- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
//{
//    [self.waitAlert dismissWithClickedButtonIndex:0 animated:YES];
//    [self.mpViewController closeWBSharePopup];
//    if ([request.url hasSuffix:@"statuses/upload.json"])
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"微博发表成功"
//                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
//        [alertView release];
//    }
//}

-(void) onClose
{
    [self.mpViewController closeWBSharePopup];
}

-(void) setup
{
    self.view.frame = CGRectMake(0, 0, 438,258);
    self.view.backgroundColor = [UIColor clearColor];
    self.bgImg.frame = self.view.frame;
    self.btnClose.frame  = CGRectMake(self.view.frame.size.width - 38, 7, 30, 30);
    self.textField.frame = CGRectMake(10, 18, 210, 133);
    self.textField.backgroundColor = [UIColor clearColor];
    self.textBgImg.frame = CGRectMake(self.textField.frame.origin.x, self.textField.frame.origin.y-10, self.textField.frame.size.width, self.textField.frame.size.height+10);
    self.btnPublish.frame = CGRectMake(self.view.frame.size.width - 90, self.view.frame.size.height - 38, 80, 31);
    [self.imgView setImage:[UIImage imageWithContentsOfFile:self.snappath]];
 
    self.imgView.frame = CGRectMake(240, 12, 100, self.imgView.image.size.height*(100/self.imgView.image.size.width));
    self.btnState.frame = CGRectMake(10, self.view.frame.size.height - 40, 80, 28);
    self.btnLogin.frame = CGRectMake(100, self.view.frame.size.height - 35, 60, 18);
    [self.view addSubview:self.bgImg];
    [self.view addSubview:self.btnClose];
    [self.view addSubview:self.textBgImg];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.btnPublish];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.btnState];
    [self.view addSubview:self.btnLogin];
    
}

- (void)dealloc
{
    [self.imgView release];
    [self.textField release];
    [self.btnPublish release];
    [self.btnUser release];
    [self.bgImg release];
    [self.textBgImg release];
    [self.mpViewController release];
    [self.snappath release];
    [self.waitAlert release];
    [self.btnState release];
    [self.btnLogin release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
