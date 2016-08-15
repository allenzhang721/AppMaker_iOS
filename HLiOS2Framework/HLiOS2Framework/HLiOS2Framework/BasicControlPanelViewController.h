//
//  BasicControlPanelViewController.h
//  MoueeIOS2Core
//
//  Created by Allen on 12-11-30.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseControlPanelViewController.h"
#import "SearchViewController.h"

@interface BasicControlPanelViewController : BaseControlPanelViewController
{
    int curIndex;
    SearchViewController *searchViewController;
    NSMutableArray *allPageEntityArr;
}

@property (nonatomic,retain) UIButton *btnOpenBookSnapshots;
@property (nonatomic,retain) UIButton *btnHome;
@property (nonatomic,retain) UIButton *btnNext;
@property (nonatomic,retain) UIButton *btnPre;
@property (nonatomic,retain) UIButton *btnExit;
@property (nonatomic,retain) UIButton *btnBgMusic;
@property (nonatomic,retain) UIButton *btnSearch;
@property BOOL isHideBackBtn;
@property BOOL isPDFType;

-(void) setup:(CGRect )rect;
-(void) refreshPanel:(int)index count:(int)count enableNav:(Boolean )enableNav;
-(void) enable;
-(void) disable;

@end
