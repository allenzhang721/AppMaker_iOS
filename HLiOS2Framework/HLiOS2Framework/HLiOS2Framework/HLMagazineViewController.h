//
//  MagazineViewController.h
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/24/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "HLBaseControlPanelViewController.h"
#import "HLMagazinePopupViewController.h"
#import "HLCollectionTableView.h"

@interface HLMagazineViewController : HLBaseControlPanelViewController <CollectionDelegate>
{
    UIButton    *_collectionButton;
    HLCollectionTableView *_collectionTableView;
    BOOL _isVerOritation;
    int _curIndex;
    int _allCount;
}

@property (nonatomic,assign) UIView   *controlPanel;
@property (nonatomic,assign) UIImageView *bgImg;
@property (nonatomic,assign) UIButton *popBtn;
@property (nonatomic,assign) UIButton *homeBtn;
@property (nonatomic,assign) UIButton *shareBtn;
@property (nonatomic,assign) UIButton *returnBtn;
@property (nonatomic,assign) UIPopoverController *popoverController;
@property (nonatomic,assign) HLMagazinePopupViewController *popupViewController;
@property (nonatomic,assign) BOOL isHideBackBtn;
@property Boolean isPoped;

-(void) setup:(CGRect )rect;

-(void) popDown;
@end
