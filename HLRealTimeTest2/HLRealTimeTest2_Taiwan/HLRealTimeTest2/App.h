//
//  App.h
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaderViewController.h"
#import "ShelfViewController.h"
#import "DownloadQueue.h"
#import "ShelfEntity.h"
#import <HLiOS2Framework/appMaker.h>

#define DOWNLOADURL "/publish/book/file.hl?bookID=1000&fileName=book.zip"
#define COVERURL    "/publish/book/file.hl?bookID=1000&fileName=cover.png"
#define BOOKNAMEURL "/publish/book/file.hl?bookID=1000&fileName=bookName.txt"

@class ViewController;

@interface App : NSObject
{
    HeaderViewController *headerViewController;
    ShelfViewController  *shelfViewController;
    DownloadQueue        *downloadQueue;
    ShelfEntity          *shelfEntity;
    appMaker              *apBook;
}

+(App *) instance;

-(HeaderViewController *) getHeaderViewController;
-(ShelfViewController  *) getShelfViewController;
-(DownloadQueue        *) getDownloadQueue;
-(ShelfEntity          *) getShelfEntity;
-(appMaker              *) getAppMaker;
-(void) closeShelf;

@property (nonatomic,assign) ViewController *rootViewController;
@end
