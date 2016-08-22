//
//  AboutViewController.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/20/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    // Do any additional setup after loading the view from its nib.
    /******************************
     ***********发布时间************
     ******************************/
    NSString *time = @"140228";
    self.versionLab.text = [NSString stringWithFormat:@"Version 1.0.1(%@)", time];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
