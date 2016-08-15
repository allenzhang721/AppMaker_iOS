//
//  FileUtility.m
//  MoueeReleaseVertical
//
//  Created by user on 11-10-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FileUtility.h"

@implementation FileUtility

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(Boolean)createDirectoryAtPath:(NSString *)dirPath
{
    if (!dirPath) 
    {
        return NO;
    }
	NSFileManager *fm  = [[NSFileManager alloc] init] ;
    bool isExist       = [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fm release];
	return isExist;
}



+(bool) checkFile:(NSString *)path fileName:(NSString*)fileName
{
	NSFileManager *fm  = [[NSFileManager alloc]init] ;
    NSString *filePath = path;
    if (fileName) 
    {
        filePath = [path stringByAppendingPathComponent:fileName];
    }
    bool isExist       = [fm fileExistsAtPath:filePath];
    [fm release];
	return isExist;
}

+(NSString*) loadBookmark
{
    NSFileManager* fm = [[NSFileManager alloc]init];
    NSArray*  myPathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* rootPath = [myPathList  objectAtIndex:0];
    NSString* filepath = [rootPath stringByAppendingPathComponent:@"bookmark.txt"];
    if ([fm fileExistsAtPath:filepath]) 
    {
        [fm release];
        return [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:NULL];
    }
    else
    {
        [fm release];
        return nil;
    }
}

+(Boolean) checkFileAtPaht:(NSString *) filePath
{
    NSFileManager *fm  = [[[NSFileManager alloc] init] autorelease];
    return [fm fileExistsAtPath:filePath];
}



+(void) saveBookmark:(NSString*)pageid
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSArray*  myPathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* rootPath = [myPathList  objectAtIndex:0];
    NSString* filepath = [rootPath stringByAppendingPathComponent:@"bookmark.txt"];
    [pageid writeToFile: filepath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    [pool release];
}

@end
