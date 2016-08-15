//
//  BookViewController.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLBookViewController.h"
#import "HLBookController.h"
#import "LocalizationDefine.h"
#import "HLBookMaskView.h"

@interface HLBookViewController ()
{
    BOOL _isFirstIn;
}

@property (retain , nonatomic) HLBookMaskView *maskView;

@end

@implementation HLBookViewController

@synthesize bookController;
@synthesize maskLable;
@synthesize hrect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _isFirstIn = YES;
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor  = [UIColor colorWithRed:183.0/255 green:183.0/255 blue:183.0/255 alpha:1];
    self.view.backgroundColor  = [UIColor whiteColor];
   // self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
	// Do any additional setup after loading the view.
}

- (void)addTaiwanMask:(CGRect)rect      //陈星宇，11.18，台湾版提示文字
{
    if (self.maskLable == nil)
    {
        self.maskLable = [[UILabel alloc] init];
        
        self.maskLable.text = @"Smart Apps Creator for Education Only";
        
        self.maskLable.textColor = [UIColor whiteColor];
        self.maskLable.textAlignment = NSTextAlignmentCenter;
        self.maskLable.backgroundColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.11 alpha:0.6];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            self.maskLable.text  = @"Smart Apps Creator for Education Only";
            
            self.maskLable.font  = [UIFont systemFontOfSize:15];
            self.maskLable.frame = CGRectMake(0, rect.size.height - 30*2, rect.size.width, 30);
        }
        else
        {
            self.maskLable.font  = [UIFont systemFontOfSize:15];
            self.maskLable.frame = CGRectMake(0, rect.size.height - 50*2, rect.size.width, 50);
        }
        hrect  = rect;
        CGRect copyRect ;
        copyRect.origin.x = rect.origin.x;
        copyRect.origin.y = rect.origin.y;
        copyRect.size.width = rect.size.width;
        copyRect.size.height = rect.size.height;
        hrect = CGRectZero;
        hrect = copyRect;
        [self.view addSubview:self.maskLable];
    }
    [self.view bringSubviewToFront:self.maskLable];
}

//      >>>>>  Mr.chen , 2.7 , maskView

- (void)addFreeMaskView:(CGRect)rect
{
    if (!self.maskView) {
        
//        self.maskView = [[HLBookMaskView alloc] initWithFrame:rect];
        self.maskView = [[HLBookMaskView alloc] initWithFrame:rect labelText:self.bookController.entity.bookMarkLabelText labelPostion:self.bookController.entity.bookMarkPostion showLabelText:self.bookController.entity.showBookMarkLabel showBookMask:self.bookController.entity.showBookMark];
        self.hrect  = rect;
        [self.view addSubview:self.maskView];
    }
    
    [self.view bringSubviewToFront:self.maskView];
}


//      <<<<<

-(void) addMask:(CGRect) rect
{
    if (self.maskLable == nil)
    {
        self.maskLable = [[UILabel alloc] init];
        
        //For JP
        NSString *maskLable_normal = nil;
        NSString *maskLabel_iphone = nil;
        
#if JAP == 1
       
        maskLable_normal = @"動作検証用サンプル／正規のご利用には本メッセージの解除が必要です。 www.smartedit.jp";
        maskLabel_iphone = @"検証画面／要解除 www.smartedit.jp";
        
#elif SIMP == 1
        
        maskLable_normal = @"appMaker 试用版制作 不得用于商业目的";
        maskLabel_iphone = @"appMaker 试用版制作";
        
#endif
//        self.maskLable.text = @"動作検証用サンプル／正規のご利用には本メッセージの解除が必要です。 www.smartedit.jp";
        
        //For appBook
        self.maskLable.text = maskLable_normal;

        self.maskLable.textColor = [UIColor whiteColor];
        self.maskLable.textAlignment = NSTextAlignmentCenter;
        self.maskLable.backgroundColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.11 alpha:0.6];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            //For JP
//            self.maskLable.text  = @"検証画面／要解除 www.smartedit.jp";
            //For appBook
            self.maskLable.text  = maskLabel_iphone;

            self.maskLable.font  = [UIFont systemFontOfSize:15];
            self.maskLable.frame = CGRectMake(0, rect.size.height - 30*2, rect.size.width, 30);
        }
        else
        {
            self.maskLable.font  = [UIFont systemFontOfSize:15];
            self.maskLable.frame = CGRectMake(0, rect.size.height - 50*2, rect.size.width, 50);
        }
        self.hrect  = rect;
        [self.view addSubview:self.maskLable];
    }
    [self.view bringSubviewToFront:self.maskLable];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
//    if (self.maskLable != nil)
//    {
//        if ((toInterfaceOrientation == UIInterfaceOrientationPortrait) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
//        {
//            if (self.bookController.entity.isVerHorMode == YES)
//            {
//                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//                {
//                    self.maskLable.frame = CGRectMake(0, self.hrect.size.width - 30*2, self.hrect.size.height, 30);
//                }
//                else
//                {
//                    self.maskLable.frame = CGRectMake(0, self.hrect.size.width - 50*2, self.hrect.size.height, 50);
//                }
//            }
//        }
//        else
//        {
//            if (self.bookController.entity.isVerHorMode == YES)
//            {
//                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//                {
//                    self.maskLable.frame =  CGRectMake(0, self.hrect.size.height - 30*2, self.hrect.size.width, 30);
//                }
//                else
//                {
//                    self.maskLable.frame =  CGRectMake(0, self.hrect.size.height - 50*2, self.hrect.size.width, 50);
//                }
//            }
//        }
//    }
    if (self.maskView) {
        
        self.maskView.alpha = 0;
    }
    
    [self.bookController changeToOrientation:toInterfaceOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (self.maskView) {
        
        if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
        {
            if (self.bookController.entity.isVerHorMode)
            {
                self.maskView.frame = CGRectMake(CGRectGetMinX(self.hrect), CGRectGetMinY(self.hrect), CGRectGetHeight(self.hrect), CGRectGetWidth(self.hrect));
            }
        }
        else
        {
            if (self.bookController.entity.isVerHorMode)
            {
                
                self.maskView.frame = self.hrect;
            }
        }
        
            [self.maskView setNeedsDisplay];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (self.maskView) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.maskView.alpha = 1;
        }];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (!self.bookController.entity.isVerticalMode && _isFirstIn && UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        _isFirstIn = NO;
        [bookController.flipController.navView changeToHorizontal];
        return YES;
    }
    BOOL orientation = [self.bookController checkOrientation:interfaceOrientation];
    if (orientation) {
        _isFirstIn = NO;
    }
    return orientation;
//    UIImage
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (([self.bookController checkOrientation: UIInterfaceOrientationPortrait] == YES) && ([self.bookController checkOrientation: UIInterfaceOrientationLandscapeLeft] == YES))
    {
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        if ([self.bookController checkOrientation:UIInterfaceOrientationPortrait] == YES)
        {
            return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
        }
        else
        {
            return UIInterfaceOrientationMaskLandscape;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.maskLable release];
    [_publicCoverBackGroundImageView removeFromSuperview];
    [self.maskView removeFromSuperview];
    [self.maskView release];
    [super dealloc];
}


@end
