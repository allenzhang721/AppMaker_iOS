//
//  DownloadQueue.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "DownloadQueue.h"

@implementation DownloadQueue


- (id)init
{
    self = [super init];
    if (self)
    {
        downloadQueue = [[ASINetworkQueue alloc] init];
        [downloadQueue reset];
    }
    return self;
}

-(void) addDownloadRequest:(ASIHTTPRequest *) request
{
    [downloadQueue addOperation:request];
    [downloadQueue go];
}


- (void)dealloc
{
    [downloadQueue release];
    [super dealloc];
}
@end
