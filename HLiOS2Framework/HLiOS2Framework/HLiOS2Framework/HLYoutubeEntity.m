//
//  HLYoutubeEntity.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 26/09/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLYoutubeEntity.h"

@implementation HLYoutubeEntity

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shareURL = @"";
        self.VideoID = @"";
    }
    return self;
}

-(void) decodeData:(TBXMLElement *)data
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    /*
     <Data>
        <ShareURL><![CDATA[https://youtu.be/vKH7p4v8Cww]]></ShareURL>
        <VideoID><![CDATA[vKH7p4v8Cww]]></VideoID>
     </Data>
     */
    
    TBXMLElement *shareURL = [EMTBXML childElementNamed:@"ShareURL" parentElement:data];
    if (shareURL) {
        self.shareURL = [EMTBXML textForElement:shareURL];
    }
    
    TBXMLElement *videoID = [EMTBXML childElementNamed:@"VideoID" parentElement:data];
    if (videoID) {
        self.videoID = [EMTBXML textForElement:videoID];
    }

    [pool release];
}

@end
