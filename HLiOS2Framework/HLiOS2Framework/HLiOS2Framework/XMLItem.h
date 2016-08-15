//
//  XMLItem.h
//  readXml
//
//  Created by user on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLItem : NSObject
{
    int start;
    int end;
    NSString *itemid;
}

@property int start;
@property int end;
@property (nonatomic , retain) NSString *itemid;
@end
