//
//  MagazinePopupViewController.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/28/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLBaseControlPanelViewController;
@class HLSharePopupViewController;

@interface HLMagazinePopupViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{}
@property (nonatomic,retain) UITableView *listTableView;
@property (nonatomic,assign) HLBaseControlPanelViewController *popupController;
@property (nonatomic,retain) NSString *snappath;
@property (nonatomic,retain) HLSharePopupViewController *sharePopupViewController;
-(void) setup;
-(void) closeWBSharePopup;
@end
