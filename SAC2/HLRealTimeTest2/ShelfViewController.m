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
    self.shelfController.shelfViewController = self;
    self.shelfController.gridView = self.shelfGridView;
    [self.shelfController setup];
    [self.shelfController reload];
    self.shelfEntity     = [[App instance] getShelfEntity];

//    self.alertView = [URBAlertView dialogWithTitle:@"" message:@""];
//    [self.alertView setBackgroundImage:[UIImage imageNamed:@"TW_image_input_bg"]];
//    self.alertView.blurBackground = NO;
////    [self.alertView setButtonBackgroundImage:[UIImage imageNamed:@"ipad_btn.png"]];
//    [self.alertView addButtonWithTitle:@"取消" sideLeft:YES];
//	[self.alertView addButtonWithTitle:@"確定" sideLeft:NO];
//    UIColor *buttonTitleColor = [UIColor colorWithRed:0.549 green:0.024 blue:0.082 alpha:1];
//    [self.alertView setButtonTextAttributes:@{UITextAttributeTextColor:buttonTitleColor} forState:UIControlStateNormal];
//    [self.alertView setButtonTextAttributes:@{UITextAttributeTextColor:buttonTitleColor} forState:UIControlStateHighlighted];
//    [self.alertView setTitleFont:[UIFont systemFontOfSize:25]];
////    [self.alertView addTextFieldWithPlaceholder:@"请输入书籍的ip地址" secure:NO];
//    [self.alertView addTextFieldWithPlaceholder:@"" secure:NO];
//    [self.alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView)
//    {
//        if (buttonIndex == 1)
//        {
//            [self.alertView hideWithCompletionBlock:^
//             {
//                 NSString *url = [self.alertView textForTextFieldAtIndex:0];
//                 [[NSUserDefaults standardUserDefaults] setValue:url forKey:@"userinput"];
//                 if ((url != nil) &&([url length] > 0))
//                 {
//                     ShelfBookEntity *bookEntity = [[[ShelfBookEntity alloc] init] autorelease];
//                     NSString *http = @"http://";
//                     NSString *coverurl     = @"";
//                     NSString *bookNameurl  = @"";
//                     
//                     NSString *tagStr = [[url substringToIndex:5] substringFromIndex:4];
//                     BOOL isZhongban = [tagStr isEqualToString:@":"] ? YES : NO;//中版要求输入地址全路径
//                     if (isZhongban)
//                     {
//                         coverurl      = [url stringByAppendingString:@"cover.png"];
//                         url           = [url stringByAppendingString:@"book.zip"];
//                         bookNameurl   = [url stringByAppendingString:@"bookName.txt"];
//                     }
//                     else
//                     {
//                         NSString *appendurl    = [NSString stringWithUTF8String:DOWNLOADURL];
//                         NSString *appendcover  = [NSString stringWithUTF8String:COVERURL];
//                         NSString *appendbooknameurl  = [NSString stringWithUTF8String:BOOKNAMEURL];
//                         
//                         coverurl      = [http stringByAppendingString:url];
//                         bookNameurl   = [http stringByAppendingString:url];
//                         url           = [http stringByAppendingString:url];
//                         coverurl      = [coverurl stringByAppendingString:@":9426"];
//                         bookNameurl   = [bookNameurl stringByAppendingString:@":9426"];
//                         url           = [url stringByAppendingString:@":9426"];
//                         coverurl      = [coverurl stringByAppendingString:appendcover];
//                         bookNameurl   = [bookNameurl stringByAppendingString:appendbooknameurl];
//                         url           = [url stringByAppendingString:appendurl];
//                         
////                         bookNameurl   = [bookNameurl stringByAppendingString:appendbooknameurl];
////                         url           = [url stringByAppendingString:appendbooknameurl];
//                     }
//                     
//                     NSLog(@"%@",url);
//                     bookEntity.downloadurl  = url;
//                     bookEntity.coverurl     = coverurl;
//                     bookEntity.bookNameUrl  = bookNameurl;
//                     [self.shelfEntity.books insertObject:bookEntity atIndex:0];
//                     [self.shelfController addNewBook];
//                 }
//                 
//             }];
//        }
//        else
//        {
//            [self.alertView hideWithCompletionBlock:^{}];
//        }
//	}];
}

-(void) addBook {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"請輸入IP地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:nil];
    
    UITextField *textfiled = alert.textFields[0];
    
    NSString *text =  [[NSUserDefaults standardUserDefaults] valueForKey:@"userinput"];
    if (text != nil && text.length > 0) {
        textfiled.text = text;
    }
    
    __block typeof(textfiled) wt = textfiled;
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [wt resignFirstResponder];
    }];
    
    
    __block typeof(self) ws = self;
    __block typeof(alert) walert = alert;
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"確定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSString *IP = walert.textFields[0].text;
        
        [wt resignFirstResponder];
        if (IP == nil || IP.length <= 0) {
            return;
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:IP forKey:@"userinput"];
        [ws downloadBookWithIP: IP];
    }];
    
    [alert addAction:cancel];
    [alert addAction:done];
    
    [self presentViewController:alert animated:true completion:nil];
}

-(void) downloadBookWithIP:(NSString *)url {
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
        }
        
        NSLog(@"%@",url);
        bookEntity.downloadurl  = url;
        bookEntity.coverurl     = coverurl;
        bookEntity.bookNameUrl  = bookNameurl;
        [self.shelfEntity.books insertObject:bookEntity atIndex:0];
        [self.shelfController addNewBook];
    }
}

-(void) onAddBtn {
    [self addBook];
}

-(void) onSettingBtn:(id)sender {
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

-(void) showAlertRemoveBookAt:(NSUInteger)i {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否確定刪除所選對象？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    __block typeof(self) ws = self;
    __block typeof(alert) walert = alert;
    __block typeof(shelfController) wc = shelfController;
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"確定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [wc removeBookAt:i];
    }];
    
    [alert addAction:cancel];
    [alert addAction:done];
    
    [self presentViewController:alert animated:true completion:nil];
    
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
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [self.shelfController.infoAlertView setBackgroundImage:[UIImage imageNamed:@"TW_image_about"]];
    }
    else
    {
        [self.shelfController.infoAlertView setBackgroundImage:[UIImage imageNamed:@"TW_image_about_iPad"]];
    }
    [self.shelfController.infoAlertView showWithAnimation:URBAlertAnimationFlipVertical];
    
//    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:self];
//    
//    [self presentViewController:pop animated:true completion:nil];
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























