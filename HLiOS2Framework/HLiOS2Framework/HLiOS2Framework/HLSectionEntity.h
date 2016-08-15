//
//  SectionEntity.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLBaseEntity.h"

@class HLPageEntity;

@interface HLSectionEntity : HLBaseEntity
{
    NSString *sectionid;
    NSMutableArray *pages;
}


@property (nonatomic , retain) NSString *sectionid;
@property (nonatomic , retain) NSMutableArray *pages;

-(bool) isPageExist:(NSString *) pageid;
-(HLPageEntity *) getPageByID:(NSString *) pageid;

@end
