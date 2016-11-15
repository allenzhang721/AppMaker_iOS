//
//  PushController.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 8/26/16.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "PushController.h"
#import "PushCell.h"

@implementation PushMessage

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        //msg_id, dttile, dtcont, crdate
        self.ID = dic[@"msg_id"];
        self.title = dic[@"dttile"];
        self.content = dic[@"dtcont"];
        self.url = dic[@"url"];
        self.createDate = dic[@"crdate"];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.ID = (NSString *)[coder decodeObjectForKey:@"msg_id"];
        self.title = (NSString *)[coder decodeObjectForKey:@"dttile"];
        self.content = (NSString *)[coder decodeObjectForKey:@"dtcont"];
        self.url = (NSString *)[coder decodeObjectForKey:@"url"];
        self.createDate = (NSString *)[coder decodeObjectForKey:@"crdate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
//    [super encodeWithCoder:coder];
    [coder encodeObject:_ID forKey:@"msg_id"];
    [coder encodeObject:_title forKey:@"dttile"];
    [coder encodeObject:_content forKey:@"dtcont"];
    [coder encodeObject:_url forKey:@"url"];
    [coder encodeObject:_createDate forKey:@"crdate"];
}

@end

@implementation PushController {
    NSMutableArray<PushMessage *> *_allMessages;
    NSMutableArray<PushMessage *> *_displayMessages;
    NSString *_pushID;
}

- (instancetype)initWithPushID:(NSString *)pushID
{
    self = [super init];
    if (self) {
        _pushID = pushID;
        [self loadLocalMessages];
    }
    return self;
}

- (void)loadLocalMessages {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *dataUrl = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject URLByAppendingPathComponent:_pushID];
    NSData *data = [NSData dataWithContentsOfURL:dataUrl];
    if (data == nil) {
        _allMessages = [[NSMutableArray alloc] init];
    } else {
        NSArray *oldm = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        _allMessages = [[NSMutableArray alloc] initWithArray:oldm];
    }
    
    _displayMessages = [[NSMutableArray alloc] init];
}

+(PushCell *)newPushView {
    PushCell *v = [[PushCell alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
    return  v;
}

-(void) removeMessageAt:(NSUInteger)index {
    [_allMessages removeObjectAtIndex:index];
    [self save];
}

-(void) removeAll {
    [_allMessages removeAllObjects];
    [self save];
}

-(void) appendMessages:(NSArray<PushMessage *> *)messages {
    [_allMessages insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, messages.count)]];
    [self save];
}

- (void)setDisplayMessages:(NSArray<PushMessage *> *)messages {
    [_displayMessages addObjectsFromArray:messages];
}

- (void) save {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *dataUrl = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject URLByAppendingPathComponent:_pushID];
    if ([NSKeyedArchiver archiveRootObject:_allMessages toFile:[dataUrl path]]) {
        NSLog(@"Save Successfully.");
    }
}

-(NSUInteger) numberOfMessages {
    return _allMessages.count;
}

-(NSUInteger) numberOFDisplayMessages {
    return _displayMessages.count;
}

-(nullable PushMessage *)messageAtIndex:(NSUInteger)i {
    return _allMessages[i];
}

-(nullable PushMessage *)displayMessageAtIndex:(NSUInteger)i {
    return _displayMessages[i];
}

- (NSUInteger)numberOfItemInPushHUD {
    return [self numberOfMessages];
}

- (NSUInteger)numberOfdipslayItemInPushHUD {
    return [self numberOFDisplayMessages];
}

- (void)pushCell:(PushCell *)cell ForItemAtIndex:(NSUInteger)i {
    PushMessage *message = [self displayMessageAtIndex:i];
    [cell setConent:message.content title:message.title date:message.createDate];
}

@end
