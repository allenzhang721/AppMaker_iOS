//
//  PushHUD.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 9/1/16.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PushMessage;
@class PushCell;

@protocol PushHUDDataSource <NSObject>
@required
- (NSUInteger)numberOfItemInPushHUD;
- (NSUInteger)numberOfdipslayItemInPushHUD;
- (void)pushCell:(PushCell *)cell ForItemAtIndex:(NSUInteger)i;

@end

@protocol PushHUDDelegate <NSObject>
@optional
- (void)willDisplayCell:(PushCell *)cell forItemAtIndex:(NSUInteger)i;
- (void)didEndDisplayCell:(PushCell *)cell forItemAtIndex:(NSUInteger)i;
- (void)closeCell:(PushCell *)cell forItemAtIndex:(NSUInteger)i;

@end

@interface PushHUD : NSObject

@property(assign, nonatomic) id<PushHUDDelegate>delegate;
@property(assign, nonatomic) id<PushHUDDataSource>datasource;

+ (PushHUD*)shareInstance;
+ (void)show;
+ (void)dismiss;
+ (void)showList;
+ (void)dismissList;

@end




