//
//  PushController.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 8/26/16.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PushHUD.h"

@class PushCell;

@interface PushMessage : NSObject <NSCoding>

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *createDate;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

@interface PushController : NSObject <PushHUDDataSource>

- (instancetype)initWithPushID:(NSString *)pushID;

- (void)setDisplayMessages:(NSArray<PushMessage *> *)messages;
-(void) appendMessages:(NSArray<PushMessage *> *)messages;
-(void) removeMessageAt:(NSUInteger)index;
-(void) removeAll;
-(NSUInteger) numberOfMessages;
-(nullable PushMessage *)next;
-(nullable PushMessage *)messageAtIndex:(NSUInteger)i;
+(PushCell *)newPushView;

@end
