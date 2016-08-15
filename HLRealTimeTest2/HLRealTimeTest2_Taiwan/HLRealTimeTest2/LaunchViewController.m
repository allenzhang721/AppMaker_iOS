//
//  LaunchViewController.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/21/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "LaunchViewController.h"

@interface LaunchViewController ()

@end



@implementation LaunchViewController
@synthesize imgView;

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
//    NSMutableArray *imgs = [[NSMutableArray alloc] initWithCapacity:5];
//    for (int i = 0 ; i < 75; i++)
//    {
//        NSString *fileName = [NSString stringWithFormat:@"%d.png",i] ;
//        UIImage *img = [UIImage imageNamed:fileName];
//        [imgs addObject:img];
//    }
//    [self.imgView setAnimationImages:imgs];
//    [self.imgView startAnimating];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotate
{
    return YES;
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
    [self.imgView release];
    [super dealloc];
}

@end
