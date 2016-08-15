//
//  ShelfController.h
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"
#import "ShelfBookEntity.h"
#import "ShelfEntity.h"
#import "URBAlertView.h"

@interface ShelfController : NSObject<GMGridViewDataSource,GMGridViewActionDelegate,GMGridViewSortingDelegate>
{}

@property (nonatomic,retain) UIView *bgView;
@property (nonatomic,assign) GMGridView *gridView;
@property (nonatomic,assign) ShelfEntity *shelfEntity;
@property (nonatomic,retain) URBAlertView *alertView;
@property (nonatomic,retain) URBAlertView *infoAlertView;

@property Boolean isClean;
-(void) setup;
-(void) reload;
-(void) openEditing;
-(void) closeEditing;
-(void) addNewBook;
-(void) removeBlockHandle;
@end
