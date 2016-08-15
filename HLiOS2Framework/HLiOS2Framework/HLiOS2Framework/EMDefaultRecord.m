//
//  EMDefaultRecord.m
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 14-4-2.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#import "EMDefaultRecord.h"

@interface EMDefaultRecord ()

@property (retain, nonatomic) NSMutableArray *keyArray;

@end

@implementation EMDefaultRecord

+ (EMDefaultRecord *)shareRecord {
    
    static EMDefaultRecord * record = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        record = [[EMDefaultRecord alloc] init];
        record.keyArray = [NSMutableArray array];
    });
    
    return record;
}

- (NSArray *)allKeys {
    
    NSArray *keys = [NSArray arrayWithArray:_keyArray];
    
    return keys;
}

- (void) removeAllObjects {
    
    [_keyArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        NSString *key = obj;
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        
        [_keyArray removeObject:obj];
    }];
    
}

- (void) setObject:(id)obj ForKey:(NSString *)aKey {
    
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:aKey];
    
    if (![_keyArray containsObject:aKey]) {
        
        [_keyArray addObject:[aKey copy]];
    }
}

- (id) objectForKey:(NSString *)aKey {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:aKey];
}

- (void) removeObjectForKey:(NSString *)aKey {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:aKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)dealloc {
    
    [self.keyArray removeAllObjects];
    [self.keyArray release];
    
    [super dealloc];
}

@end
