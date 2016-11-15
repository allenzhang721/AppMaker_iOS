//
//  HLGobalBookID.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 23/09/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLGobalBookID : NSObject

@property (copy) NSString *bookID;

+ (HLGobalBookID *)share;

@end
