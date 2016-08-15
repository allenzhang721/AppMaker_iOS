//
//  FileUtility.h
//  MoueeTest
//
//  Created by mac on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtility : NSObject 
{
	
}


+(bool) checkFile:(NSString *)path fileName:(NSString*)fileName;
+(NSString*) loadBookmark;
+(void) saveBookmark:(NSString*)pageid;
+(Boolean) checkFileAtPaht:(NSString *) filePath;
+(Boolean)createDirectoryAtPath:(NSString *)dirPath;

@end
