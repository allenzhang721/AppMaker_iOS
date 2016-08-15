//
//  FileUtility.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/19/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "FileUtility.h"

@implementation FileUtility


+(void)createDirectoryAtPath:(NSString *)dirPath
{
	NSFileManager *fm  = [[NSFileManager alloc] init] ;
    if([fm fileExistsAtPath:dirPath] == NO)
    {
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [fm release];
}

+(Boolean) checkFileAtPaht:(NSString *) filePath
{
    NSFileManager *fm  = [[[NSFileManager alloc] init] autorelease];
    return [fm fileExistsAtPath:filePath];
}

+(void) delFileAtPath:(NSString *) filePath
{
    NSFileManager *fm  = [[NSFileManager alloc] init] ;
    if([fm fileExistsAtPath:filePath] == NO)
    {
        [fm removeItemAtPath:filePath error:nil];
    }
    [fm release];
}
@end
