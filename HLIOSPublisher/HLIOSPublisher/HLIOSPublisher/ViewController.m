//
//  ViewController.m
//  HLIOSPublisher
//
//  Created by 星宇陈 on 14/7/7.
//  Copyright (c) 2014年 Emiaostein. All rights reserved.
//

#import "ViewController.h"
#import "appMakerSDK/appMaker.h"

static NSString* const demoBookDirName = @"book";

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSString *demoBookPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:demoBookDirName];
    
    [appMaker openBookWithRootViewController:self
                          bookDirectoryPath:demoBookPath
                                theDelegate:(id<appMakerDelegate>)self
                             hiddenBackIcon:YES
                            hiddenShareIcon:YES];
}

@end
