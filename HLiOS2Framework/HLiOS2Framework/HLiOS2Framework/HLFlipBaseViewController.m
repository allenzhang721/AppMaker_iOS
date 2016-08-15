//
//  FlipBaseViewController.m
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLFlipBaseViewController.h"
#import "HLCurverFlipController.h"
#import "HLSliderFlipController.h"
#import "HLAFKFlip.h"
#import "HLCoreConfig.h"
#import "HLCurlFlipController.h"
#import "HLCoverBaseController.h"

@interface HLFlipBaseViewController ()

@end

@implementation HLFlipBaseViewController

@synthesize flipController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void) initStrategy:(NSString *) flipStrategy
{
//    flipStrategy = @"FLIP_SLIDE";//参数控制
//    flipStrategy = @"CURL";//参数控制
    if([flipStrategy compare:@"FLIP_CURVERFLIP"] == NSOrderedSame)
    {
        self.flipController = [[HLCurverFlipController alloc] init];
        [self.flipController release];
        self.flipController.viewController = self;
    }
    else
    {
        if([flipStrategy compare:@"FLIP_SLIDE"] == NSOrderedSame)
        {
            self.flipController = [[HLSliderFlipController alloc] init];
            [self.flipController release];
            self.flipController.viewController = self;
        }
        else
        {
            if ([flipStrategy compare:@"CURL"] == NSOrderedSame)
            {
                self.flipController = [[HLCurlFlipController alloc] init];
                [self.flipController release];
                self.flipController.viewController = self;
            }
            else
            {
                self.flipController = [[HLAFKFlip alloc] init];
                [self.flipController release];
                self.flipController.viewController = self;
            }
        }
    }
    
    self.flipController.bookEntity = self.bookEntity;
}

- (BOOL)shouldAutorotate
{
    return YES;
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
//    NSLog(@"1[flipController retainCount] = %d",[flipController retainCount]); //陈星宇，11.2
    [self.flipController release];
    [super dealloc];
}

@end












