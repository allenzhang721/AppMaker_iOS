//
//  BookController.h
//  MoueeIOS2Core
//
//  Created by Mouee-iMac on 12-11-12.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLBookViewController.h"
#import "HLBookEntity.h"
#import "HLFlipBaseViewController.h"
#import "HLFlipBaseController.h"
#import "HLBasicControlPanelViewController.h"
#import "HLBaseControlPanelViewController.h"
#import "HLMagazineViewController.h"
#import "HLReaderDocument.h"
#import "HLReaderViewController.h"
#import "EPubViewController.h"
#import "appMaker.h"
#import "HLCoverBaseController.h"         //12.31
#import "HLCoverBaseViewController.h"

@class appMaker;
@class EPubViewController;
@class HLBookViewController;  //11.27


@interface HLBookController : NSObject
{
    
}

@property (nonatomic , retain) NSString                         *rootPath;
@property (nonatomic , retain) NSString                         *bookmode;
@property (nonatomic , retain) EPubViewController               *ePubViewController;
@property (nonatomic , retain) HLReaderViewController             *readerViewController;
@property (nonatomic , retain) HLBookViewController               *bookviewcontroller;
@property (nonatomic , retain) HLBaseControlPanelViewController   *controlPanelViewController;
@property (nonatomic , retain) HLFlipBaseViewController           *flipBaseViewController;
@property (nonatomic , assign) HLFlipBaseController               *flipController;
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
