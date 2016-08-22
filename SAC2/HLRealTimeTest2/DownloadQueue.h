//
//  DownloadQueue.h
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"


@interface DownloadQueue : NSObject
{
    ASINetworkQueue *downloadQueue;
}

-(void) addDownloadRequest:(ASIHTTPRequest *) request;
@end
