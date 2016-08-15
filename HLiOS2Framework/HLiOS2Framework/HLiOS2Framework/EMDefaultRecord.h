//
//  EMDefaultRecord.h
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 14-4-2.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMDefaultRecord : NSObject

+ (EMDefaultRecord *)shareRecord;

- (NSArray *)allKeys;

- (void) removeAllObjects;

- (void) setObject:(id)obj ForKey:(NSString *)aKey;

- (id) objectForKey:(NSString *)aKey;

- (void) removeObjectForKey:(NSString *)aKey;


@end
