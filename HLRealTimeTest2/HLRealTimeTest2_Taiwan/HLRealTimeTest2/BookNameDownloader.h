//
//  BookNameDownloader.h
//  HLRealTimeTest2
//
//  Created by 星宇陈 on 14-2-25.
//  Copyright (c) 2014年 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol BookNameDownloaderDelegate <NSObject>

- (void) bookNameDidDownloadsucesses:(NSString *)path;
- (void) bookNameDidDownloadError;

@end

@interface BookNameDownloader : NSObject
{
    ASIHTTPRequest *request;
}

@property (nonatomic,assign) id<BookNameDownloaderDelegate> delegate;
-(void) download:(NSString *) url :(NSString *) fileid;

@end
