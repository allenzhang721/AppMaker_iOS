//
//  AppDelegate.h
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
//#import "WXApi.h"
//#import "WBApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "AGViewDelegate.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
//    enum WXScene _scene;
    AGViewDelegate *_viewDelegate;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (nonatomic,readonly) AGViewDelegate *viewDelegate;

@end
