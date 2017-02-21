//
//  appBook.h
//  MoueeIOS2Core
//
//  Created by Allen on 12-11-29.
//  Copyright (c) 2012年 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum BookType
{
    BookTypeEpub,
    BookTypePDF,
    BookTypeMedia
}BookType;

typedef enum WeiboType
{
    WeiboTypeSina,
    WeiboTypeTencent,
    WeiboTypeQQSpace,
    WeiboTypeRenren,
    WeiboTypeDouban,
    WeiboTypeWeixin,
    WeiboTypeFaceBook,
    WeiboTypeTwitter,
    WeiboTypeDefault
}HLWeiboType;

@class HLBookController;

@protocol appMakerDelegate <NSObject>

@optional

-(void)onCloseBook;     //after viewcontroller dismiss
-(void)onCloseingBook;  //before viewcontroller dismiss
-(void)shareToWeibo:(NSString *)content image:(NSString *)image type:(HLWeiboType)type;
-(void)bookPageIsCollected:(BOOL)isCollected;

@end

@interface appMaker : NSObject

@property (nonatomic, retain) HLBookController      *bookController;

@property (nonatomic, assign) UIViewController    *rootViewController;

@property (nonatomic, assign) id<appMakerDelegate> delegate;

-(Boolean) loadBookEntity:(NSString *) root;

-(void) setup;

-(void) openBook;

-(void) startView;

-(void) closeBook;

-(void) displayWatermark:(Boolean) value;

-(void) hideBackButton;

-(void) hideWeiboButton;

-(UIView *) getBookContentView;

-(NSString *) getBookCurPageIndex;

-(BookType)getBookType;

-(Boolean) isFree;

-(Boolean) checkOrientation:(UIInterfaceOrientation)interfaceOrientation;

-(void) setJapaneseLanguage;

- (BOOL) openBookWithRootViewController:(UIViewController *)root bookDirectoryPath:(NSString *)bookPath theDelegate:(id<appMakerDelegate>)theDelegate hiddenBackIcon:(BOOL)hideBack hiddenShareIcon:(BOOL)hideShare;

+ (BOOL) openBookWithRootViewController:(UIViewController *)root bookDirectoryPath:(NSString *)bookPath theDelegate:(id<appMakerDelegate>)theDelegate hiddenBackIcon:(BOOL)hideBack hiddenShareIcon:(BOOL)hideShare;

@end
