//
//  BookDecoder.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "HLBookDecoder.h"
#import "HLPageDecoder.h"
#import "HLXMLManager.h"
#import "CommonFunc.h"
static HLXMLManager* xmlManager;
static NSString* const myDataPath = @"book.dat";
static NSString* const anotherDataPath = @"hash.dat";

@implementation HLBookDecoder

+(void)initXmlManager:(NSString*)rootpath
{
    NSString *path = [rootpath stringByAppendingPathComponent:myDataPath];
    NSData *myData = [[NSData alloc] initWithContentsOfFile:path];
    xmlManager = [[[HLXMLManager alloc] init] autorelease];
    xmlManager.data = myData;
    [myData release];
}

+(HLBookEntity*) decode:(NSString *)rootpath
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    if (!xmlManager)
    {
        [HLBookDecoder initXmlManager:rootpath];
    }
    
    Boolean free = YES;
    
    NSString *key         = [xmlManager stringL];
    NSString *hash        = [xmlManager stringH];
    NSString *anotherPath = [rootpath stringByAppendingPathComponent:anotherDataPath];
    NSString *sec         = [NSString stringWithContentsOfFile:anotherPath encoding:NSUTF8StringEncoding error:nil];
    sec = [CommonFunc textFromBase64String:sec secretKey:key];
    if (sec != nil && ![@"" isEqualToString:sec] && hash != nil  && [sec compare:hash] == NSOrderedSame)
    {
        free = NO;
    }
    
    HLBookEntity *bookEntity = [[HLBookEntity alloc] init];
    NSString *path           = [rootpath stringByAppendingPathComponent:@"book.xml"];
    NSString *data           = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (free == NO) {
        
        data = [CommonFunc textFromBase64String:data secretKey:key];
    }
    
    EMTBXML* tbxml   = [[[EMTBXML alloc] initWithXMLString:data error:nil] autorelease];
    TBXMLElement *root = tbxml.rootXMLElement;
    if (root)
	{
        TBXMLElement *bookInfo = [EMTBXML childElementNamed:@"BookInfo" parentElement:root];
        if (bookInfo != nil)
        {
            BOOL isAndroid = NO;
            TBXMLElement *platformType = [EMTBXML childElementNamed:@"PlatformType" parentElement:bookInfo];
            if (platformType)
            {
                if ([[EMTBXML textForElement:platformType] isEqualToString:@"android_platform"])
                {
                    isAndroid = YES;
                }
            }
            [HLPageDecoder setAndroidType:isAndroid];
            
            //陈星宇,11.13,屏幕适配
            if ([EMTBXML childElementNamed:@"DeviceType" parentElement:bookInfo]) {
                TBXMLElement *deviceType = [EMTBXML childElementNamed:@"DeviceType" parentElement:bookInfo];
                bookEntity.deviceType = [EMTBXML textForElement:deviceType];
            }
            
            //陈星宇,10.24,支付
            if ([EMTBXML childElementNamed:@"ProductID" parentElement:bookInfo] != nil)
            {
                TBXMLElement *productID = [EMTBXML childElementNamed:@"ProductID" parentElement:bookInfo];
                bookEntity.productID = [EMTBXML textForElement:productID];
            }
            
            if ([EMTBXML childElementNamed:@"ReferenceName" parentElement:bookInfo] != nil)
            {
                TBXMLElement *refernceName = [EMTBXML childElementNamed:@"ReferenceName" parentElement:bookInfo];
                bookEntity.referenceName = [EMTBXML textForElement:refernceName];
            }
            
            if ([EMTBXML childElementNamed:@"ID" parentElement:bookInfo] != nil)
            {
                TBXMLElement *bookid = [EMTBXML childElementNamed:@"ID" parentElement:bookInfo];
                bookEntity.bookid = [EMTBXML textForElement:bookid];
            }
            //Mr.chen,2014-9-10
            /*
             <BookMark>
                 <IsShowBookMark>true</IsShowBookMark>
                 <IsShowBookMarkLabel>true</IsShowBookMarkLabel>
                 <BookMarkLablePositon>center|bottom</BookMarkLablePositon>
                 <BookMarkLabelHorGap>0</BookMarkLabelHorGap>
                 <BookMarkLabelVerGap>10</BookMarkLabelVerGap>
                 <BookMarkLabelText>
                 <![CDATA[ appMaker教育版 禁止用于商业用途 ]]>
                 </BookMarkLabelText>
             </BookMark>
             */
            
            // >>>>>  Mr.chen, 09.10.2014, bookMark
            TBXMLElement *BookMark = [EMTBXML childElementNamed:@"BookMark" parentElement:bookInfo];
            
            if (!BookMark) {
            
                bookEntity.hasBookMarkTag = NO;
                
            } else if (BookMark) {
                
                bookEntity.hasBookMarkTag = YES;
                
                // showBookMark
                TBXMLElement *IsShowBookMark = [EMTBXML childElementNamed:@"IsShowBookMark" parentElement:BookMark];
                if (IsShowBookMark) {
                    
                    NSString *show = [EMTBXML textForElement:IsShowBookMark];
                    bookEntity.showBookMark = [show compare:@"true"] == NSOrderedSame ? YES : NO;
                }
                
                // ShowBookMarkLabel
                TBXMLElement *IsShowBookMarkLabel = [EMTBXML childElementNamed:@"IsShowBookMarkLabel" parentElement:BookMark];
                if (IsShowBookMarkLabel) {
                    
                    NSString *show = [EMTBXML textForElement:IsShowBookMarkLabel];
                    bookEntity.showBookMarkLabel = [show compare:@"true"] == NSOrderedSame ? YES : NO;
                }
                
                //label
                TBXMLElement *BookMarkLabelText = [EMTBXML childElementNamed:@"BookMarkLabelText" parentElement:BookMark];
                if (BookMarkLabelText) {
                    
                    NSString *show = [EMTBXML textForElement:BookMarkLabelText];
                    bookEntity.bookMarkLabelText = show;
                }
                
                //Postion
                TBXMLElement *BookMarkLablePositon = [EMTBXML childElementNamed:@"BookMarkLablePositon" parentElement:BookMark];
                TBXMLElement *BookMarkLabelHorGap = [EMTBXML childElementNamed:@"BookMarkLabelHorGap" parentElement:BookMark];
                TBXMLElement *BookMarkLabelVerGap = [EMTBXML childElementNamed:@"BookMarkLabelVerGap" parentElement:BookMark];
                
                HLBookEntityBookMarkPostion postion;
                postion.horPostion = HLBookEntityLabelHorPostionCenter;
                postion.verPostion = HLBookEntityLabelVerPostionCenter;
                postion.horGap = 0.0f;
                postion.verGap = 0.0f;
                
                if (BookMarkLablePositon) {
                    
                    //left、center、right  vertical
                    
                    //top、middle、bottom hor
                    NSString *string = [EMTBXML textForElement:BookMarkLablePositon];
                    
                    NSArray *postions = [string componentsSeparatedByString:@"|"];
                    
                if (postions.count == 2) {
                        
                    
                    
                    NSString *verstring = postions[0];
                    NSString *horString = postions[1];
                    
                    if ([verstring compare:@"left"] == NSOrderedSame) {
                        
                        postion.verPostion = HLBookEntityLabelVerPostionLeft;
                    } else if([verstring compare:@"center"] == NSOrderedSame) {
                        
                        postion.verPostion = HLBookEntityLabelVerPostionCenter;
                    } else if([verstring compare:@"right"] == NSOrderedSame) {
                        
                         postion.verPostion = HLBookEntityLabelVerPostionRight;
                    }
                    
                    if ([horString compare:@"top"] == NSOrderedSame) {
                        
                        postion.horPostion = HLBookEntityLabelHorPostionTop;
                    } else if([horString compare:@"middle"] == NSOrderedSame) {
                        
                        postion.horPostion = HLBookEntityLabelHorPostionCenter;
                    } else if([horString compare:@"bottom"] == NSOrderedSame) {
                        
                        postion.horPostion = HLBookEntityLabelHorPostionBottom;
                    }
                        
                }
                    
                }
                
                if (BookMarkLabelHorGap) {
                    
                    float horGap = [[EMTBXML textForElement:BookMarkLabelHorGap] floatValue];
                    
                    postion.horGap = horGap;
                }
                
                if (BookMarkLabelVerGap) {
                    float verGap = [[EMTBXML textForElement:BookMarkLabelVerGap] floatValue];
                    
                    postion.verGap = verGap;
                }
                
                bookEntity.bookMarkPostion = postion;
            }
            // <<<<<

            //陈星宇,10.24,支付
            
            TBXMLElement *adPosition = [EMTBXML childElementNamed:@"ADPosition" parentElement:bookInfo];
            if (adPosition != nil)
            {
                bookEntity.adPosition = [EMTBXML textForElement:adPosition];
            }
            TBXMLElement *bookName = [EMTBXML childElementNamed:@"Name" parentElement:bookInfo];
            if (bookName != nil)
            {
                bookEntity.name = [EMTBXML textForElement:bookName];
            }
            NSString *bookType = [EMTBXML textForElement:[EMTBXML childElementNamed:@"BookType" parentElement:bookInfo]];
            bookEntity.bookType = bookType;
            if ([bookType compare:@"interact_book_hor_ver"] == NSOrderedSame)
            {
                bookEntity.isVerHorMode = YES;
            }
            else
            {
                bookEntity.isVerHorMode = NO;
            }
            if ([bookType compare:@"interact_book_ver"] == NSOrderedSame)
            {
                bookEntity.isVerticalMode = YES;
            }
            else
            {
                bookEntity.isVerticalMode = NO;
            }
            
            if ([bookType compare:@"PDF"] == NSOrderedSame || [bookType compare:@"EPUB"] == NSOrderedSame)
            {
                [pool release];
                return bookEntity;
            }
            
            bookEntity.navType = @"threed_navigation_view";
            
            if([EMTBXML childElementNamed:@"BookNavType" parentElement:bookInfo] != nil)
            {
                bookEntity.navType = [EMTBXML textForElement:[EMTBXML childElementNamed:@"BookNavType" parentElement:bookInfo]];
            }
            
            int width = 0;
            int height = 0;
            
            if (bookEntity.isVerticalMode)
            {
                width = 768;
                height = 1024;
            }
            else
            {
                width = 1024;
                height = 768;
            }
            
            TBXMLElement *bookwidth = [EMTBXML childElementNamed:@"BookWidth" parentElement:bookInfo];
            if (bookwidth)
            {
                bookEntity.width        = [[EMTBXML textForElement:bookwidth] intValue];
            }
            else
            {
                bookEntity.width = width;
            }
            [HLPageDecoder setBookWidth:bookEntity.width];
            
            TBXMLElement *bookheight = [EMTBXML childElementNamed:@"BookHeight" parentElement:bookInfo];
            if (bookheight)
            {
                bookEntity.height       = [[EMTBXML textForElement:bookheight] intValue];
            }
            else
            {
                bookEntity.height = height;
            }
            
//            NSLog(@"bookEntity.width = %d,bookEntity.height = %d",bookEntity.width, bookEntity.height);
            
            [HLPageDecoder setBookHeight:bookEntity.height];
            
            TBXMLElement *isFree = [EMTBXML childElementNamed:@"IsFree" parentElement:bookInfo];
            if (isFree != nil)
            {
                //                if ([[NSUserDefaults standardUserDefaults] objectForKey:bookEntity.bookid] == nil) {
                bookEntity.isFree = [[EMTBXML textForElement:isFree] boolValue];
                //                    [[NSUserDefaults standardUserDefaults] setBool:bookEntity.isFree forKey:bookEntity.bookid];
                //
                //                } else {
                //
                //                    BOOL isfree = [[[NSUserDefaults standardUserDefaults] objectForKey:bookEntity.bookid] boolValue];
                //                    bookEntity.isFree = isfree;
                //
                //                } //陈星宇
            }
            else
            {
                bookEntity.isFree = NO;
            }
            
            if (free)
            {
                bookEntity.isFree = YES;
            }
            else
            {
                if (!bookEntity.isFree)
                {
                    bookEntity.isFree = NO;
                }
                else
                {
                    bookEntity.isFree = YES;
                }
            }

            
//            bookEntity.isFree = YES;
            
            //陈星宇,10.24,支付 isPaid   内部处理，不需要解析
            //            if ([TBXML childElementNamed:@"IsPaid" parentElement:bookInfo] != nil) {
            //                TBXMLElement *isPaid = [TBXML childElementNamed:@"IsPaid" parentElement:bookInfo];
            //                if (isPaid != nil)
            //                {
            //                    if ([[NSUserDefaults standardUserDefaults] objectForKey:bookEntity.bookid] == nil)
            //                    {
            //                        bookEntity.isPaid = [[TBXML textForElement:isPaid] boolValue];
            //                        [[NSUserDefaults standardUserDefaults] setBool:bookEntity.isPaid forKey:bookEntity.bookid];
            //                    }
            //                    else
            //                    {
            //                        BOOL isPaid = [[[NSUserDefaults standardUserDefaults] objectForKey:bookEntity.bookid] boolValue];
            //                        bookEntity.isPaid = isPaid;
            //                    }
            //                }
            //
            //            }
            //            else
            //            {
            //                bookEntity.isPaid = YES;
            //            }
            
            //陈星宇
            
            
            TBXMLElement *isLoadNavi = [EMTBXML childElementNamed:@"IsLoadNavigation" parentElement:bookInfo];
            if (isLoadNavi != nil)
            {
                bookEntity.isLoadNavi = [[EMTBXML textForElement:isLoadNavi] boolValue];
            }
            
            TBXMLElement *isLoadSnap = [EMTBXML childElementNamed:@"IsLoadSnap" parentElement:bookInfo];
            if (isLoadSnap) {
                NSString *isLoadSnapStr = [EMTBXML textForElement:isLoadSnap];
                if ([isLoadSnapStr compare:@"false"] == NSOrderedSame) {
                    bookEntity.isLoadSnap = NO;
                }
            }
            
            TBXMLElement *buttons = [EMTBXML childElementNamed:@"Buttons" parentElement:bookInfo];
            if (buttons != nil)
            {
                TBXMLElement *button = [EMTBXML childElementNamed:@"Button" parentElement:buttons];
                while (button != nil)
                {
                    NSString *btntype    = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Type" parentElement:button]];
                    HLButtonEntity *btnEntity = [[HLButtonEntity alloc] init];
                    btnEntity.x = [[EMTBXML textForElement:[EMTBXML childElementNamed:@"X" parentElement:button]] floatValue];
                    btnEntity.y = [[EMTBXML textForElement:[EMTBXML childElementNamed:@"Y" parentElement:button]] floatValue];
                    btnEntity.width  = [[EMTBXML textForElement:[EMTBXML childElementNamed:@"Width" parentElement:button]] floatValue];
                    btnEntity.height = [[EMTBXML textForElement:[EMTBXML childElementNamed:@"Height" parentElement:button]] floatValue];
                    NSString *visible         = [EMTBXML textForElement:[EMTBXML childElementNamed:@"isVisible" parentElement:button]];
                    btnEntity.btnImg          = [EMTBXML textForElement:[EMTBXML childElementNamed:@"Source" parentElement:button]];
                    btnEntity.btnHighlightImg = [EMTBXML textForElement:[EMTBXML childElementNamed:@"SelectedSource" parentElement:button]];
                    
                    TBXMLElement *isUserDefNav = [EMTBXML childElementNamed:@"UserDefNav" parentElement:button];
                    if (isUserDefNav != nil)
                    {
                        btnEntity.isUserDef = [[EMTBXML textForElement:isUserDefNav] boolValue];
                    }
                    else if(![btnEntity.btnImg isEqualToString:@""] && ![btnEntity.btnImg isEqualToString:@"－1"])
                    {
                        btnEntity.isUserDef = YES;
                    }
                    else
                    {
                        btnEntity.isUserDef = NO;
                    }
                    if ([visible compare:@"true"] == NSOrderedSame)
                    {
                        btnEntity.isVisible = YES;
                    }
                    else
                    {
                        btnEntity.isVisible = NO;
                    }
                    if( [btntype compare:@"home_page_btn"] == NSOrderedSame)
                    {
                        bookEntity.homeBtn   = btnEntity;
                    }
                    else
                    {
                        if( [btntype compare:@"next_page_btn"] == NSOrderedSame)
                        {
                            bookEntity.rightBtn   = btnEntity;
                        }
                        else
                        {
                            if( [btntype compare:@"pre_page_btn"] == NSOrderedSame)
                            {
                                bookEntity.leftBtn   = btnEntity;
                            }
                            else
                            {
                                if( [btntype compare:@"open_navigate_btn"] == NSOrderedSame)
                                {
                                    bookEntity.snapBtn   = btnEntity;
                                }
                                if( [btntype compare:@"ver_open_navigate_btn"] == NSOrderedSame)
                                {
                                    bookEntity.vsnapBtn   = btnEntity;
                                }
                                if( [btntype compare:@"ver_pre_page_btn"] == NSOrderedSame)
                                {
                                    bookEntity.vleftBtn   = btnEntity;
                                }
                                if( [btntype compare:@"ver_next_page_btn"] == NSOrderedSame)
                                {
                                    bookEntity.vrightBtn   = btnEntity;
                                }
                                if( [btntype compare:@"ver_home_page_btn"] == NSOrderedSame)
                                {
                                    bookEntity.vhomeBtn   = btnEntity;
                                }
                                if( [btntype compare:@"bg_audio_btn"] == NSOrderedSame)
                                {
                                    bookEntity.bgMusicBtn   = btnEntity;
                                }
                                if( [btntype compare:@"search_page_btn"] == NSOrderedSame)
                                {
                                    bookEntity.searchBtn   = btnEntity;
                                }
                            }
                        }
                    }
                    [btnEntity release];
                    button =  [EMTBXML nextSiblingNamed:@"Button" searchFromElement:button];
                }
            }
            NSString *filpType = [EMTBXML textForElement:[EMTBXML childElementNamed:@"BookFlipType" parentElement:bookInfo]];
            bookEntity.filpType   = filpType;
            TBXMLElement *homepageid = [EMTBXML childElementNamed:@"HomePageID" parentElement:bookInfo];
            if (homepageid != nil)
            {
                bookEntity.homepageid    = [EMTBXML textForElement:homepageid];
            }
            TBXMLElement *backgroundMusicId = [EMTBXML childElementNamed:@"BackgroundMusicId" parentElement:bookInfo];
            if (backgroundMusicId != nil)
            {
                bookEntity.backgroundMusic  =  [EMTBXML textForElement:backgroundMusicId];
            }
            TBXMLElement *startpageTime = [EMTBXML childElementNamed:@"StartPageTime" parentElement:bookInfo];
            if (startpageTime)
            {
                NSString *delay =[EMTBXML textForElement:startpageTime];
                if (delay.length > 0)
                {
                    bookEntity.startDelay = [delay floatValue];
                    if (bookEntity.startDelay <= 0.1)
                    {
                        bookEntity.startDelay = 0.1;
                    }
                }
            }
            
        }
		TBXMLElement *snaps = [EMTBXML childElementNamed:@"Snapshots" parentElement:root];
		TBXMLElement *snap  = [EMTBXML childElementNamed:@"Snapshot" parentElement:snaps];
		while(snap != nil)
		{
            SnapshotEntity *snapshot = [[[SnapshotEntity alloc] init] autorelease];
			NSString *snapid = [EMTBXML textForElement:[EMTBXML childElementNamed:@"SnapshotId" parentElement:snap]];
            NSString *pgid   = [EMTBXML textForElement:[EMTBXML childElementNamed:@"PageId" parentElement:snap]];
            TBXMLElement *element = [EMTBXML childElementNamed:@"PageTitle" parentElement:snap];
            if (element)
            {
                NSString *title   = [EMTBXML textForElement:element];
                snapshot.pageTitle = title;
            }
            snapshot.fileid  = snapid;
            snapshot.pageid  = pgid;
			[bookEntity.snapshots addObject:snapshot];
			snap =  [EMTBXML nextSiblingNamed:@"Snapshot" searchFromElement:snap];
		}
		TBXMLElement *pagesRoot  = [EMTBXML childElementNamed:@"Pages" parentElement:root];
		TBXMLElement *pageRoot   = [EMTBXML childElementNamed:@"Page" parentElement:pagesRoot];
		while (pageRoot != nil)
		{
			NSString *pageID = [EMTBXML textForElement:[EMTBXML childElementNamed:@"ID" parentElement:pageRoot]];
			[bookEntity.pages addObject:pageID];
			pageRoot = [EMTBXML nextSiblingNamed:@"Page" searchFromElement:pageRoot];
		}
        TBXMLElement *startPageID   = [EMTBXML childElementNamed:@"StartPageID" parentElement:root];
        bookEntity.launchPage       = [EMTBXML textForElement:startPageID];
        TBXMLElement *sectionsRoot  = [EMTBXML childElementNamed:@"Sections" parentElement:root];
        TBXMLElement *sectionRoot   = [EMTBXML childElementNamed:@"Section"  parentElement:sectionsRoot];
        while (sectionRoot != nil)
        {
            HLSectionEntity *section = [[[HLSectionEntity alloc] init] autorelease];
            TBXMLElement *sectionPagesRoot =  [EMTBXML childElementNamed:@"Pages" parentElement:sectionRoot];
            TBXMLElement *sectionPageRoot  =  [EMTBXML childElementNamed:@"Page"  parentElement:sectionPagesRoot];
            while (sectionPageRoot != nil)
            {
                NSString *sectionPageID =  [EMTBXML textForElement:sectionPageRoot];
                [section.pages addObject:sectionPageID];
                sectionPageRoot =  [EMTBXML nextSiblingNamed:@"Page" searchFromElement:sectionPageRoot];
            }
            [bookEntity.sections addObject:section];
            sectionRoot = [EMTBXML nextSiblingNamed:@"Section" searchFromElement:sectionRoot];
        }
		
	}
    else
    {
        [pool release];
        [bookEntity release];
        xmlManager = nil;
        return nil;
    }

    [pool release];
    xmlManager = nil;
    return [bookEntity autorelease];
}

@end
