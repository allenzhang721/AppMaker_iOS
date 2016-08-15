//
//  FileUtility.h
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/19/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLFileUtility : NSObject


+(void)createDirectoryAtPath:(NSString *)dirPath;
+(Boolean) checkFileAtPaht:(NSString *) filePath;
+(void) delFileAtPath:(NSString *) filePath;
@end
