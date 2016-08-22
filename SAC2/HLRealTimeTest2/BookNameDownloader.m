//
//  BookNameDownloader.m
//  HLRealTimeTest2
//
//  Created by 星宇陈 on 14-2-25.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#import "BookNameDownloader.h"
#import "FileUtility.h"

@implementation BookNameDownloader

-(void) download:(NSString *) url :(NSString *) fileid
{
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *filefolder = [self getFilePath:fileid];
    [FileUtility createDirectoryAtPath:filefolder];
    [request setDownloadDestinationPath:[filefolder stringByAppendingPathComponent:@"bookName.txt"]];
    [request setTemporaryFileDownloadPath:[filefolder stringByAppendingPathComponent:@"bookNametmp.txt"]];
    [request setAllowResumeForFileDownloads:NO];
    request.allowCompressedResponse = NO;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(downloadFail:)];
    [request setDidFinishSelector:@selector(downloadComplete:)];
    [request setDownloadProgressDelegate:self];
    [request setShowAccurateProgress:YES];
    [request startAsynchronous];
}

- (void)downloadFail:(ASIHTTPRequest *)request
{
    NSLog(@"bookName fail");
    if (self.delegate != nil)
    {
        [self.delegate bookNameDidDownloadError];
    }
}

- (void)downloadComplete:(ASIHTTPRequest *)re
{
    NSLog(@"bookName success");
    if (self.delegate != nil)
    {
        [self.delegate bookNameDidDownloadsucesses:re.downloadDestinationPath];
    }
}



-(NSString *)getFilePath:(NSString *)fileid
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    filePath = [filePath stringByAppendingPathComponent:fileid];
    return filePath;
}

@end
