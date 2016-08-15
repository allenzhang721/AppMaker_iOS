//
//  FileDownloader.h
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@protocol FileDownloaderDelegate <NSObject>

-(void) ondownloadsuccess:(NSString *)filePath;
-(void) onProgress:(float)newProgress;
-(void) ondownloaderror;

@end

@interface FileDownloader : NSObject<NSURLConnectionDelegate>
{
    ASIHTTPRequest *request;
}

@property (nonatomic,assign) UIProgressView *indicator;
@property (nonatomic,assign) UILabel        *indicatorLabel;
@property (nonatomic,assign) id<FileDownloaderDelegate> delegate;

-(void) download:(NSString *) url :(NSString *) fileid;
-(void) cancelDownloaderWithURl:(NSString *)url; //Mr.chen, 1.26 ,添加下载删除保护
@end
