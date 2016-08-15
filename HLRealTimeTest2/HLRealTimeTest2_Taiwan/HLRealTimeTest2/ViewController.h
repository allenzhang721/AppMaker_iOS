//
//  ViewController.h
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShelfViewController.h"
#import "LaunchViewController.h"
#import <HLiOS2Framework/appMaker.h>

@interface ViewController : UIViewController<appMakerDelegate>
{}

@property (nonatomic,assign) ShelfViewController  *shelfViewController;

@property (nonatomic,assign) appMaker *apBook;

@property (nonatomic,retain) LaunchViewController *launchViewController;

@property Boolean isFirstLaunch;
@end
