//
//  CoverDownloader.h
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/21/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@protocol CoverDownloaderDelegate <NSObject>

-(void) onCoverdownloadsuccess:(NSString *)filePath;
-(void) onCoverdownloaderror;

@end
@interface CoverDownloader : NSObject
{
     ASIHTTPRequest *request;
}

@property (nonatomic,assign) id<CoverDownloaderDelegate> delegate;
-(void) download:(NSString *) url :(NSString *) fileid;

@end
