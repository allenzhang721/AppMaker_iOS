//
//  CoverBaseViewController.m
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 13-12-31.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLCoverBaseViewController.h"
#import "ClearView.h"
#import "HLsingleCoverController.h"
#import "HLSliderCoverController.h"
#import "HLCoverBaseViewController.h"

@interface HLCoverBaseViewController ()

@end

@implementation HLCoverBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    self.view = [[HLClearScrollView alloc] init];
    self.view.autoresizingMask = 63;
    ((HLClearScrollView*)self.view).scrollEnabled = NO;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark -
#pragma mark - memory manager
- (void)dealloc
{
    [self.coverController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
