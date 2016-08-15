//
//  BookEntity.h
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileDownloader.h"
#import "CoverDownloader.h"
#import "BookNameDownloader.h"
#import "XMLWriter.h"
#import "EMTBXML.h" 

@class ShellCell;

@interface ShelfBookEntity : NSObject<FileDownloaderDelegate,CoverDownloaderDelegate,BookNameDownloaderDelegate>
{
    
}

@property (nonatomic,retain) NSString *tempid;
@property (nonatomic,retain) NSString *downloadurl;
@property (nonatomic,retain) NSString *coverurl;
@property (nonatomic,retain) NSString *bookNameUrl;
@property (nonatomic,retain) FileDownloader  *fileDownloader;
@property (nonatomic,retain) CoverDownloader *coverDownloader;
@property (nonatomic,retain) BookNameDownloader *bookNameDownloader;
@property (nonatomic,assign) ShellCell *cell;
@property Boolean isBookNameDownloaded;     //Mr.chen, 2.25
@property Boolean isDownloaded;
@property Boolean isCoverDownloaded;
@property Boolean isUnziped;
@property Boolean canOpen;
@property Boolean isFail;
@property float progress;
-(void) update;
-(NSString *) getBookPath;
-(void) encode:(XMLWriter*) writer;
-(void) decode:(TBXMLElement *)element;
-(void) refreshCover;
-(void) refreshBookName;        //Mr.chen, 2.25
-(void) remove;


@end
