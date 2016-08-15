//
//  SharePopupViewController.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/29/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MagazinePopupViewController;
@interface SharePopupViewController : UIViewController
{}

@property (nonatomic,retain) UIImageView *bgImg;
@property (nonatomic,retain) UIImageView *imgView;
@property (nonatomic,retain) UIImageView *textBgImg;
@property (nonatomic,retain) UITextView  *textField;
@property (nonatomic,retain) UIButton    *btnState;
@property (nonatomic,retain) UIButton    *btnLogin;
@property (nonatomic,retain) UIButton    *btnPublish;
@property (nonatomic,retain) UIButton    *btnUser;
@property (nonatomic,retain) UIButton    *btnClose;
@property (nonatomic,retain) UIAlertView *waitAlert;
@property (nonatomic,retain) NSString    *snappath;
@property (nonatomic,assign) MagazinePopupViewController *mpViewController;
-(void) setup;
@end
