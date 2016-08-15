//
//  XMLManager.h
//  readXml
//
//  Created by user on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLItem.h"

@interface XMLManager : NSObject
{
    NSMutableArray *items;
    NSData *data;
    NSInteger offset;
}
@property (nonatomic , retain) NSMutableArray *items;
@property (nonatomic , retain) NSData *data;
@property (nonatomic) NSInteger offset;

-(void) decode:(NSString *) xml;
-(XMLItem *) getXMLItem:(NSString *) itemid;
-(NSString *) getStringByID:(NSString *) itemid; 
+(NSString *) getMD5:(NSString *) value;
//-(NSString *) getenstr;
- (NSString *)stringL;
- (NSString *)stringH;
-(NSString *) getMD5WithData:(NSData *) value;
-(NSData *) getendata;
@end
