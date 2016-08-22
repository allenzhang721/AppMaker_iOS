//
//  ViewController.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "ViewController.h"
#import "App.h"
#import "URBAlertView.h"
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import "LocalizationDefine.h"

@interface ViewController ()
{
    AppDelegate *_appDelegate;
}

@end

@implementation ViewController
@synthesize shelfViewController;
@synthesize isFirstLaunch;
@synthesize launchViewController;

- (id)init
{
    self = [super init];
    
    if (self) {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    
    return self;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height > 480)
        {
            self.launchViewController = [[[LaunchViewController alloc] initWithNibName:@"LaunchViewController_iphone" bundle:nil] autorelease];

        }
        else
        {
            self.launchViewController = [[[LaunchViewController alloc] initWithNibName:@"LaunchViewController_iphone4" bundle:nil] autorelease];

        }
    }
    else
    {
        self.launchViewController = [[[LaunchViewController alloc] initWithNibName:@"LaunchViewController" bundle:nil] autorelease];
    }
    self.isFirstLaunch = YES;
    
    /******************************
     *********书架范例书籍***********
     ******************************/
    
    BOOL showDemoBook = NO;
    if (showDemoBook)
    {
        //不需要示例书刊则注释
        Boolean needAddBook = YES;
        for (int i = 0 ; i < [[[App instance] getShelfEntity].books count]; i++)
        {
            ShelfBookEntity *bookEntity = [[[App instance] getShelfEntity].books objectAtIndex:i];
            if ([bookEntity.tempid isEqualToString:@"smartApps"] == YES)
            {
                needAddBook = NO;
                break;
            }
        }
        if (needAddBook == YES)
        {
            ShelfBookEntity *bookEntity = [[[ShelfBookEntity alloc] init] autorelease];
            bookEntity.tempid = @"smartApps";
            bookEntity.downloadurl = @"";
            bookEntity.coverurl = @"";
            bookEntity.bookNameUrl = @"";
            bookEntity.isDownloaded = YES;
            bookEntity.isUnziped    = YES;
            bookEntity.canOpen      = YES;
            [[[App instance] getShelfEntity].books insertObject:bookEntity atIndex:0];
            [[[App instance] getShelfEntity] save];
        }
    }
}

-(void) afterLaunch
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.launchViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.launchViewController.view removeFromSuperview];
        [self.launchViewController release];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isFirstLaunch == YES)
    {
        [self.view addSubview:self.launchViewController.view];
        self.isFirstLaunch = NO;

        [App instance].rootViewController = self;
        self.shelfViewController = [[App instance] getShelfViewController];
        self.shelfViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.apBook = [[App instance] getAppMaker];
        self.apBook.rootViewController = self;
        self.apBook.delegate = self;
        [self.view addSubview:self.shelfViewController.view];
        [self.view sendSubviewToBack:self.shelfViewController.view];
        
        [self performSelector:@selector(afterLaunch) withObject:nil afterDelay:3.0f];
        
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//    {
//        return UIInterfaceOrientationMaskAll;
//    }
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        return YES;
    } 
    else
    {
        return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
    }
    return YES;
}

-(void)onCloseBook
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];      //Mr.chen , 2.8 , statusBar hidden or not
    self.shelfViewController = [[App instance] getShelfViewController];
    self.shelfViewController.view.frame = self.view.frame;
    [self presentViewController:self.shelfViewController animated:NO completion:nil];
}

-(void)shareToWeibo:(NSString *)content image:(NSString *)image type:(HLWeiboType)type
{
    ShareType shareType = ShareTypeSinaWeibo;
    switch (type) {
        case WeiboTypeSina:
            shareType = ShareTypeSinaWeibo;
            break;
        case WeiboTypeTencent:
            shareType = ShareTypeTencentWeibo;
            break;
        case WeiboTypeQQSpace:
            shareType = ShareTypeQQSpace;
            break;
        case WeiboTypeDouban:
            shareType = ShareTypeDouBan;
            break;
        case WeiboTypeRenren:
            shareType = ShareTypeRenren;
            break;
        case WeiboTypeWeixin://只有微信朋友圈
            shareType = ShareTypeWeixiTimeline;
            break;
        case WeiboTypeFaceBook:
            shareType = ShareTypeFacebook;
            break;
        case WeiboTypeTwitter:
            shareType = ShareTypeTwitter;
            break;
        default:
            break;
    }
        
    [self shareToWeiboClickHandler:image content:content type:shareType];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.launchViewController release];
//    [_xs release];
//    [_asd release];
    [super dealloc];
}

//- (void)shareToWeiboClickHandler:(NSString *)imagePath content:(NSString *)content type:(ShareType)type
//{
//    //added by Adward 13-11-26判断当前设备有没有安装微信，如果没有安装的话弹出alertView
////    if ((type == ShareTypeWeixiTimeline)&&![WXApi isWXAppSupportApi])
////    {
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAttention message:kNotice delegate:self cancelButtonTitle:kCancel otherButtonTitles:kConfire, nil];
////        [alert show];
////        [alert release];
////        return;
////    }
//    //创建分享内容
//    id<ISSContent> publishContent = [ShareSDK content:content
//                                       defaultContent:@""
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:nil
//                                                  url:nil
//                                          description:nil
//                                            mediaType:SSPublishContentMediaTypeText];
//    
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
//    
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:YES
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:_appDelegate.viewDelegate];
//    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(type),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
//    
//    //显示分享菜单
//    [ShareSDK showShareViewWithType:type
//                          container:container
//                            content:publishContent
//                      statusBarTips:YES
//                        authOptions:authOptions
//                       shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
//                                                           oneKeyShareList:[ShareSDK getShareListWithType:type, nil]
//                                                            qqButtonHidden:YES
//                                                     wxSessionButtonHidden:YES
//                                                    wxTimelineButtonHidden:YES
//                                                      showKeyboardOnAppear:NO
//                                                         shareViewDelegate:_appDelegate.viewDelegate
//                                                       friendsViewDelegate:_appDelegate.viewDelegate
//                                                     picViewerViewDelegate:nil]
//                             result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                 if (state == SSPublishContentStateSuccess)
//                                 {
//                                     NSLog(@"发表成功");
//                                 }
//                                 else if (state == SSPublishContentStateFail)
//                                 {
//                                     NSLog(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
//                                 }
//                             }];
//}

- (void)viewDidUnload {
    [self setXs:nil];
    [self setAsd:nil];
    [super viewDidUnload];
}
@end
