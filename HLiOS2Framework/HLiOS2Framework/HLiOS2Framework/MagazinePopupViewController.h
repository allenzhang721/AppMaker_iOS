//
//  MagazinePopupViewController.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/28/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseControlPanelViewController;
@class SharePopupViewController;

@interface MagazinePopupViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{}
@property (nonatomic,retain) UITableView *listTableView;
@property (nonatomic,assign) BaseControlPanelViewController *popupController;
@property (nonatomic,retain) NSString *snappath;
@property (nonatomic,retain) SharePopupViewController *sharePopupViewController;
-(void) setup;
-(void) closeWBSharePopup;
@end
