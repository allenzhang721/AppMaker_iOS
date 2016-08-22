//
//  ShelfEntity.h
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/19/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShelfEntity : NSObject
@property (nonatomic,retain) NSMutableArray *books;


-(void) save;
-(void) load;
@end
