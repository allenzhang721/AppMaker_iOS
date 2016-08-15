//
//  HeaderViewController.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "HeaderViewController.h"

@interface HeaderViewController ()

@end

@implementation HeaderViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)onAddBtn:(id)sender
{
    if (self.delegate != nil)
    {
        [self.delegate onAddBtn];
    }
}

-(IBAction)onInfoBtn:(id)sender
{
    if (self.delegate != nil)
    {
        [self.delegate onInfoBtn];
    }
}

-(IBAction)onSettingBtn:(id)sender
{
    if (self.delegate != nil)
    {
        [self.delegate onSettingBtn:sender];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

@end
