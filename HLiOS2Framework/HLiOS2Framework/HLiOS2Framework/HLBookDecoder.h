//
//  BookDecoder.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLBookEntity.h"
#import "SnapshotEntity.h"
#import "HLSectionEntity.h"
#import "EMTBXML.h"

@interface HLBookDecoder : NSObject
{
    
}

+(HLBookEntity*) decode:(NSString *)rootpath;

@end
