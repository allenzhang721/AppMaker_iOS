//
//  ShelfViewController.h
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderViewController.h"
#import "GMGridView.h"
#import "ShelfController.h"
#import "URBAlertView.h"
#import "ShelfEntity.h"
#import "PopoverView.h"

@interface ShelfViewController : UIViewController<HeaderViewControllerDelegate,PopoverViewDelegate>
{
    PopoverView *pv;
}

@property (nonatomic,assign) HeaderViewController *headerViewController;
@property (nonatomic,retain) IBOutlet GMGridView *shelfGridView;
@property (nonatomic,retain) ShelfController *shelfController;
@property (nonatomic,retain) URBAlertView *alertView;
@property (nonatomic,assign) ShelfEntity  *shelfEntity;
@end
