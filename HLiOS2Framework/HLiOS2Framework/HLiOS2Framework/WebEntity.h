//
//  WebEntity.h
//  MoueeiPad
//
//  Created by mac on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLContainerEntity.h"
@interface WebEntity : HLContainerEntity
{
    NSString *url;
}

@property (nonatomic , retain) NSString *url;

@end
