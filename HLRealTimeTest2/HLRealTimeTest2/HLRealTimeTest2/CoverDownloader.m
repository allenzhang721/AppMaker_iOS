//
//  CoverDownloader.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/21/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "CoverDownloader.h"
#import "HLFileUtility.h"


@implementation CoverDownloader

@synthesize delegate;
-(void) download:(NSString *) url :(NSString *) fileid
{
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *filefolder = [self getFilePath:fileid];
    NSLog(@"Coverfilefolder = %@",filefolder);
    [HLFileUtility createDirectoryAtPath:filefolder];
    [request setDownloadDestinationPath:[filefolder stringByAppendingPathComponent:@"cover.png"]];
    [request setTemporaryFileDownloadPath:[filefolder stringByAppendingPathComponent:@"covertmp.png"]];
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
    NSLog(@"cover fail");
    if (self.delegate != nil)
    {
        [self.delegate onCoverdownloaderror];
    }
}

- (void)downloadComplete:(ASIHTTPRequest *)re
{
    NSLog(@"cover success");
    if (self.delegate != nil)
    {
        [self.delegate onCoverdownloadsuccess:re.downloadDestinationPath];
    }
}



-(NSString *)getFilePath:(NSString *)fileid
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    filePath = [filePath stringByAppendingPathComponent:fileid];
    return filePath;
}
@end
