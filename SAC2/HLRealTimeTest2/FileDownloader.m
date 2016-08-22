//
//  FileDownloader.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "FileDownloader.h"
#import "App.h"
#import "FileUtility.h"

@implementation FileDownloader

@synthesize indicator;
@synthesize indicatorLabel;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void) download:(NSString *) url :(NSString *) fileid
{
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *filefolder = [self getFilePath:fileid];
    [FileUtility createDirectoryAtPath:filefolder];
    [request setDownloadDestinationPath:[filefolder stringByAppendingPathComponent:@"book.zip"]];
    [request setTemporaryFileDownloadPath:[filefolder stringByAppendingPathComponent:@"booktmp.zip"]];
    [request setAllowResumeForFileDownloads:NO];
    request.allowCompressedResponse = NO;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(downloadFail:)];
    [request setDidFinishSelector:@selector(downloadComplete:)];
    [request setDownloadProgressDelegate:self];
    [request setShowAccurateProgress:YES];
    [request startAsynchronous];
    //[[[App instance] getDownloadQueue] addDownloadRequest:request];
}


- (void)downloadFail:(ASIHTTPRequest *)request
{
    NSLog(@"fail");
    if (self.delegate != nil)
    {
        [self.delegate ondownloaderror];
    }
}

- (void)downloadComplete:(ASIHTTPRequest *)re
{
    NSLog(@"success");
    if (self.delegate != nil)
    {
        [self.delegate ondownloadsuccess:re.downloadDestinationPath];
    }
}

- (void)setProgress:(float)newProgress
{
    NSLog(@"%f",newProgress);
    if (self.delegate != nil)
    {
        [self.delegate onProgress:newProgress];
    }
}

-(NSString *)getFilePath:(NSString *)fileid
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    filePath = [filePath stringByAppendingPathComponent:fileid];
    return filePath;
}


//  >>>>>   Mr.chen , 1.26 ,下载保护
-(void) cancelDownloaderWithURl:(NSString *)url
{
    if (request != nil && !request.isFinished)
    {
        self.delegate = nil;
        [request cancel];
    }
}
//  <<<<<


@end
