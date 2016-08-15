//
//  SnapshotEntity.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLBaseEntity.h"

@interface SnapshotEntity : HLBaseEntity
{
    NSString *fileid;
    NSString *pageid;
    NSString *pageTitle;
}

@property (nonatomic , retain) NSString* fileid;
@property (nonatomic , retain) NSString* pageid;
@property (nonatomic , retain) NSString* pageTitle;

@end
