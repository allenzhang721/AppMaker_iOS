//
//  ShelfViewController.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "ShelfViewController.h"
#import "App.h"
#import "FileDownloader.h"
#import "AboutViewController.h"

@interface ShelfViewController ()

@end

@implementation ShelfViewController
@synthesize headerViewController;
@synthesize shelfGridView;
@synthesize shelfController;
@synthesize alertView;
@synthesize shelfEntity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headerViewController = [[App instance] getHeaderViewController];
    self.headerViewController.view.frame = CGRectMake(0, 0, self.headerViewController.view.frame.size.width, self.headerViewController.view.frame.size.height);
    [self.view addSubview:self.headerViewController.view];
    self.headerViewController.delegate = self;
    self.shelfController = [[[ShelfController alloc] init] autorelease];
    self.shelfGridView.frame = CGRectMake(0, 0, self.shelfGridView.frame.size.width, self.shelfGridView.frame.size.height);
    self.shelfController.gridView = self.shelfGridView;
    [self.shelfController setup];
    [self.shelfController reload];
    self.shelfEntity     = [[App instance] getShelfEntity];
    self.alertView = [URBAlertView dialogWithTitle:@"" message:@""];
    [self.alertView setBackgroundImage:[UIImage imageNamed:@"ipad_input.png"]];
    self.alertView.blurBackground = NO;
    //    [self.alertView setButtonBackgroundImage:[UIImage imageNamed:@"ipad_btn.png"]];
    [self.alertView addButtonWithTitle:@"取消" sideLeft:YES];
	[self.alertView addButtonWithTitle:@"确定" sideLeft:NO];
    UIColor *buttonTitleColor = [UIColor colorWithRed:0.2549 green:0.4824 blue:0.8431 alpha:1];
    [self.alertView setButtonTextAttributes:@{UITextAttributeTextColor:[UIColor blackColor]} forState:UIControlStateNormal];
    [self.alertView setButtonTextAttributes:@{UITextAttributeTextColor:buttonTitleColor} forState:UIControlStateHighlighted];
    [self.alertView setTitleFont:[UIFont systemFontOfSize:25]];
    //    [self.alertView addTextFieldWithPlaceholder:@"请输入书籍的ip地址" secure:NO];
    [self.alertView addTextFieldWithPlaceholder:@"" secure:NO];
    
    __WEAK typeof(self) weakSelf = self;
    [self.alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
     {
         if (buttonIndex == 1)
         {
             [self.alertView hideWithCompletionBlock:^
              {
                  NSString *url = [self.alertView textForTextFieldAtIndex:0];
                  
                  if ([weakSelf ipAddress:url]) {
                      
                      [[NSUserDefaults standardUserDefaults] setValue:url forKey:@"userinput"];
                      if ((url != nil) &&([url length] > 0))
                      {
                          ShelfBookEntity *bookEntity = [[[ShelfBookEntity alloc] init] autorelease];
                          NSString *http = @"http://";
                          NSString *coverurl     = @"";
                          NSString *bookNameurl  = @"";
                          
                          NSString *tagStr = [[url substringToIndex:5] substringFromIndex:4];
                          BOOL isZhongban = [tagStr isEqualToString:@":"] ? YES : NO;//中版要求输入地址全路径
                          if (isZhongban)
                          {
                              coverurl      = [url stringByAppendingString:@"cover.png"];
                              url           = [url stringByAppendingString:@"book.zip"];
                              bookNameurl   = [url stringByAppendingString:@"bookName.txt"];
                          }
                          else
                          {
                              NSString *appendurl    = [NSString stringWithUTF8String:DOWNLOADURL];
                              NSString *appendcover  = [NSString stringWithUTF8String:COVERURL];
                              NSString *appendbooknameurl  = [NSString stringWithUTF8String:BOOKNAMEURL];
                              
                              coverurl      = [http stringByAppendingString:url];
                              bookNameurl   = [http stringByAppendingString:url];
                              url           = [http stringByAppendingString:url];
                              coverurl      = [coverurl stringByAppendingString:@":9426"];
                              bookNameurl   = [bookNameurl stringByAppendingString:@":9426"];
                              url           = [url stringByAppendingString:@":9426"];
                              coverurl      = [coverurl stringByAppendingString:appendcover];
                              bookNameurl   = [bookNameurl stringByAppendingString:appendbooknameurl];
                              url           = [url stringByAppendingString:appendurl];
                              
                              //                         bookNameurl   = [bookNameurl stringByAppendingString:appendbooknameurl];
                              //                         url           = [url stringByAppendingString:appendbooknameurl];
                          }
                          
                          NSLog(@"%@",url);
                          bookEntity.downloadurl  = url;
                          bookEntity.coverurl     = coverurl;
                          bookEntity.bookNameUrl  = bookNameurl;
                          [self.shelfEntity.books insertObject:bookEntity atIndex:0];
                          [self.shelfController addNewBook];
                      }
                      
                      
                  } else {
                      
                      if (url != nil && ![@"" isEqualToString:url]) {
                          
                          ShelfBookEntity *bookEntity = [[[ShelfBookEntity alloc] init] autorelease];
                          bookEntity.downloadurl  = url;
                          bookEntity.coverurl     = @"";
                          bookEntity.bookNameUrl  = @"";
                          [self.shelfEntity.books insertObject:bookEntity atIndex:0];
                          [self.shelfController addNewBook];
                          
                          
                      }
                      
                      
                  }
                  
              }];
         }
         else
         {
             [self.alertView hideWithCompletionBlock:^{}];
         }
     }];
}

- (BOOL) ipAddress:(NSString *)ipstring {
    
    NSString *phoneRegex = @ "^((\\d|[1-9]\\d|1\\d\\d|2[0-4]\\d|25[0-5]|[*])\\.){3}(\\d|[1-9]\\d|1\\d\\d|2[0-4]\\d|25[0-5]|[*])$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:ipstring];
}

-(void) onAddBtn
{
    [self.alertView showWithAnimation:URBAlertAnimationFlipVertical];
}

-(void) onSettingBtn:(id)sender
{
    UIButton *btn = sender;
    [btn setSelected:!btn.selected];
    if (btn.selected == YES)
    {
        [self.shelfController openEditing];
    }
    else
    {
        [self.shelfController closeEditing];
    }
}

-(void) onInfoBtn
{
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    //    {
    ////        UIImageView *about = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iphone_about.png"]];
    //        AboutViewController *about = [[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil] autorelease];
    //        pv = [PopoverView showPopoverAtPoint:CGPointMake(5, 20)
    //                                      inView:self.view
    //                             withContentView:about.view
    //                                    delegate:self];
    //    }
    //    else
    //    {
    ////        UIImageView *about = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about.png"]];
    //        AboutViewController *about = [[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil] autorelease];
    //        pv = [PopoverView showPopoverAtPoint:CGPointMake(17, 40)
    //                                      inView:self.view
    //                             withContentView:about.view
    //                                    delegate:self];
    //    }
    //    [pv retain];
    [self.shelfController.infoAlertView showWithAnimation:URBAlertAnimationFlipVertical];
}

- (void)popoverView:(PopoverView *)popoverView didSelectItemAtIndex:(NSInteger)index
{
    
}

- (void)popoverViewDidDismiss:(PopoverView *)popoverView
{
    [pv release], pv = nil;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (pv)
    {
        [pv dismiss:NO];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.shelfGridView removeFromSuperview];
    if (self.shelfController != nil)
    {
        self.shelfController.isClean = YES;
        [self.shelfGridView reloadData];
    }
    [self.shelfGridView release];
    [self.shelfController removeBlockHandle];
    [self.shelfController release];
    //    [self.headerViewController.view removeFromSuperview];
    [super dealloc];
}

@end























