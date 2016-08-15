//
//  BookController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookViewController.h"
#import "HLBookEntity.h"
#import "FlipBaseViewController.h"
#import "FlipBaseController.h"
#import "BasicControlPanelViewController.h"
#import "BaseControlPanelViewController.h"
#import "MagazineViewController.h"
#import "ReaderDocument.h"
#import "ReaderViewController.h"
#import "EPubViewController.h"
#import "appMaker.h"
#import "CoverBaseController.h"         //12.31
#import "CoverBaseViewController.h"

@class appMaker;
@class EPubViewController;
@class BookViewController;  //11.27


@interface BookController : NSObject
{
    
}

@property (nonatomic , retain) NSString                         *rootPath;
@property (nonatomic , retain) NSString                         *bookmode;
@property (nonatomic , retain) EPubViewController               *ePubViewController;
@property (nonatomic , retain) ReaderViewController             *readerViewController;
@property (nonatomic , retain) BookViewController               *bookviewcontroller;
@property (nonatomic , retain) BaseControlPanelViewController   *controlPanelViewController;
@property (nonatomic , retain) FlipBaseViewController           *flipBaseViewController;
@property (nonatomic , assign) FlipBaseController               *flipController;
@property (nonatomic , retain) HLBookEntity                       *entity;
@property (nonatomic , assign) appMaker                          *apBook;
@property BOOL isHideBackBtn;
@property BOOL isHideWeiboBtn;
@property BOOL isJapaneseLanguage;

-(Boolean) loadBookEntity:(NSString *) root;
-(void) openBook;
-(void) strartView;
-(void) loadPage:(NSString *) pageid;
-(void) setup:(CGRect) rect;
-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(void) changeToOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(void) close;
-(NSString *)getCurPageIndex;
-(BookType)getBookType;
@end
