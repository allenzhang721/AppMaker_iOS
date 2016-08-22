//
//  BookEntity.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/18/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "ShelfBookEntity.h"
#import "ShellCell.h"
#import "ZipArchive.h"
#import "FileUtility.h"
#import "App.h"

@implementation ShelfBookEntity

@synthesize isDownloaded;
@synthesize cell;
@synthesize isUnziped;
@synthesize canOpen;
@synthesize progress;
@synthesize coverurl;
@synthesize isCoverDownloaded;
@synthesize fileDownloader;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tempid = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        self.isDownloaded  = NO;
        self.isUnziped     = NO;
        self.canOpen       = NO;
        self.isFail        = NO;
        self.isCoverDownloaded = NO;
        self.isBookNameDownloaded = NO; //Mr.chen, 2.25,
    }
    return self;
}

-(void) decode:(TBXMLElement *)element
{
    TBXMLElement *ele = [TBXML childElementNamed:@"BOOKID" parentElement:element];
    self.tempid           = [TBXML textForElement:ele];
    ele                   = [TBXML childElementNamed:@"DOWNLOADURL" parentElement:element];
    self.downloadurl      = [TBXML textForElement:ele];
    ele                   = [TBXML childElementNamed:@"COVERURL" parentElement:element];
    self.coverurl      = [TBXML textForElement:ele];
    
    if ([TBXML childElementNamed:@"BOOKNAMEURL" parentElement:element])
    {
        ele                   = [TBXML childElementNamed:@"BOOKNAMEURL" parentElement:element]; //Mr.chen, 2.25,
        self.bookNameUrl      = [TBXML textForElement:ele];
    }
    else
    {
        self.bookNameUrl = @"";
    }
    ele                   = [TBXML childElementNamed:@"ISDOWNLOADED" parentElement:element];
    self.isDownloaded     = [[TBXML textForElement:ele] boolValue];
    ele                   = [TBXML childElementNamed:@"ISUNZIPED" parentElement:element];
    self.isUnziped        = [[TBXML textForElement:ele] boolValue];
    ele                   = [TBXML childElementNamed:@"ISFAIL" parentElement:element];
    self.isFail           = [[TBXML textForElement:ele] boolValue];
    ele                   = [TBXML childElementNamed:@"ISCOVERDOWNLOADED" parentElement:element];
    self.isCoverDownloaded   = [[TBXML textForElement:ele] boolValue];
    
    if ([TBXML childElementNamed:@"ISBOOKNAMEDOWNLOADED" parentElement:element]) {
        
        ele                   = [TBXML childElementNamed:@"ISBOOKNAMEDOWNLOADED" parentElement:element];    //Mr.chen, 2.25,
        self.isBookNameDownloaded   = [[TBXML textForElement:ele] boolValue];
    }
    else
    {
        self.isBookNameDownloaded = YES;
    }
    
    
    if (self.isDownloaded == NO)
    {
        self.isFail = YES;
    }
    if ((self.isDownloaded == YES) && (self.isUnziped == YES))
    {
        self.canOpen = YES;
    }

}

-(void) encode:(XMLWriter*) writer
{
    [writer writeStartElement:@"BOOK"];
    
    [writer writeStartElement:@"BOOKID"];
    [writer writeCharacters:self.tempid];
    [writer writeEndElement];
    
    [writer writeStartElement:@"DOWNLOADURL"];
    [writer writeCharacters:self.downloadurl];
    [writer writeEndElement];
    
    [writer writeStartElement:@"COVERURL"];
    [writer writeCharacters:self.coverurl];
    [writer writeEndElement];
    
    if (self.bookNameUrl != nil && ![@"" isEqualToString:self.bookNameUrl])
    {
        [writer writeStartElement:@"BOOKNAMEURL"];//Mr.chen, 2.25,
        [writer writeCharacters:self.bookNameUrl];
        [writer writeEndElement];
    }

    [writer writeStartElement:@"ISDOWNLOADED"];
    if (self.isDownloaded == YES)
    {
        [writer writeCharacters:@"YES"];
    }
    else
    {
        [writer writeCharacters:@"NO"];
    }
    [writer writeEndElement];
    
    [writer writeStartElement:@"ISUNZIPED"];
    if (self.isUnziped == YES)
    {
        [writer writeCharacters:@"YES"];
    }
    else
    {
        [writer writeCharacters:@"NO"];
    }
    [writer writeEndElement];
    
    [writer writeStartElement:@"ISFAIL"];
    if (self.isFail == YES)
    {
         [writer writeCharacters:@"YES"];
    }
    else
    {
         [writer writeCharacters:@"NO"];
    }
    [writer writeEndElement];
    
    [writer writeStartElement:@"ISCOVERDOWNLOADED"];
    if (self.isCoverDownloaded == YES)
    {
        [writer writeCharacters:@"YES"];
    }
    else
    {
        [writer writeCharacters:@"NO"];
    }
    [writer writeEndElement];
    
    [writer writeStartElement:@"ISBOOKNAMEDOWNLOADED"]; //Mr.chen, 2.25,
    
    if (self.isBookNameDownloaded == YES)
    {
        [writer writeCharacters:@"YES"];
    }
    else
    {
        [writer writeCharacters:@"NO"];
    }
    [writer writeEndElement];
    
    [writer writeEndElement];
}

-(void) update
{
    if (self.isFail == NO)
    {
        
        if ((self.bookNameDownloader == nil) && (self.isBookNameDownloaded == NO))      //Mr.chen, 2.25,
        {
            self.bookNameDownloader = [[BookNameDownloader alloc] init];
            self.bookNameDownloader.delegate = self;
            [self.bookNameDownloader download:self.bookNameUrl :self.tempid];
        }
        else
        {
            if ((self.coverDownloader == nil) && (self.isCoverDownloaded == NO))
            {
                self.coverDownloader = [[CoverDownloader alloc] init];
                self.coverDownloader.delegate = self;
                [self.coverDownloader download:self.coverurl :self.tempid];
            }
        }
        
        if(self.cell != nil)
        {
            self.fileDownloader.indicator = self.cell.progressView;
//            self.fileDownloader.indicatorLabel = self.cell.prgogreeLabel;
        }
        [self onProgress:self.progress];
    }
    if ([FileUtility checkFileAtPaht:[self getCoverPath]] == YES)
    {
        [self onCoverdownloadsuccess:[self getCoverPath]];
    }
    
    if ([FileUtility checkFileAtPaht:[self getBookNamePath]] == YES)        //Mr.chen, 2.25,
    {
        [self bookNameDidDownloadsucesses:[self getBookNamePath]];
    }
}

-(void) refreshCover
{
    if ([FileUtility checkFileAtPaht:[self getCoverPath]] == YES)
    {
        [self onCoverdownloadsuccess:[self getCoverPath]];
    }
}

-(void) refreshBookName
{
    if ([FileUtility checkFileAtPaht:[self getBookNamePath]] == YES)        //Mr.chen, 2.25,
    {
        [self bookNameDidDownloadsucesses:[self getBookNamePath]];
    }
}

-(void) downloadBook
{
    if ((self.fileDownloader == nil) && (self.isDownloaded == NO))
    {
        self.fileDownloader = [[FileDownloader alloc] init];
        self.fileDownloader.delegate = self;
        [self.fileDownloader download:self.downloadurl :self.tempid];
    }
}

-(void) downloadCover
{
    if ((self.coverDownloader == nil) && (self.isCoverDownloaded == NO))
    {
        self.coverDownloader = [[CoverDownloader alloc] init];
        self.coverDownloader.delegate = self;
        [self.coverDownloader download:self.coverurl :self.tempid];
    }
}

-(void) unzipfile:(NSString *) filePath
{
    NSString *filefolder = [self getFilePath:self.tempid];
    ZipArchive *zip = [[ZipArchive alloc] init];
    if ([zip UnzipOpenFile:filePath])
    {
        [zip UnzipFileTo: filefolder overWrite:YES];
    }
    [zip UnzipCloseFile];
    [zip release];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:filePath error:nil];
    if (self.cell != nil)
    {
        if (cell.entity == self)
        {
            self.cell.indicator.hidden = YES;
            [self.cell.indicator stopAnimating];
            self.cell.maskImg.hidden = YES;         //Mr.chen , 1.24
        }
    }
    self.isUnziped = YES;
    self.canOpen   = YES;
    [[[App instance] getShelfEntity] save];
}

-(void) onProgress:(float)newProgress
{
    if (self.cell != nil)
    {
        if (cell.entity == self)
        {
            if (self.cell.indicator != nil)
            {
                self.cell.progressView.progress = newProgress;
               
            }
//            if (self.cell.prgogreeLabel != nil)
//            {
//                self.cell.prgogreeLabel.text = [NSString stringWithFormat:@"%d ",(int)(newProgress*100)];
//                self.cell.prgogreeLabel.text = [self.cell.prgogreeLabel.text stringByAppendingString:@"%"];
//            }
        }
    }
    self.progress = newProgress;
}

-(void) ondownloaderror
{
    if (cell != nil)
    {
//        self.cell.prgogreeLabel.hidden = YES;
        self.cell.progressView.hidden  = YES;
        self.cell.maskImg.hidden = NO;
        self.cell.reDownloadBtn.hidden = NO;
//        self.cell.errorLabel.hidden    = NO;
    }
    self.isFail = YES;
    self.isDownloaded              = YES;
    [[[App instance] getShelfEntity] save];
}

-(void) ondownloadsuccess:(NSString *)filePath;
{
    self.isDownloaded = YES;
    if (self.cell != nil)
    {
        if (cell.entity == self)
        {
            [self.cell update];
            self.cell.indicator.hidden = NO;
            [self.cell.indicator startAnimating];
        }
    }
    [self performSelector:@selector(unzipfile:) withObject:filePath afterDelay:1.0f];

}

-(void) onCoverdownloadsuccess:(NSString *)filePath;
{
    self.isCoverDownloaded = YES;
    if (self.cell != nil)
    {
        if (cell.entity == self)
        {
            self.cell.coverImg.image = [UIImage imageWithContentsOfFile:filePath];
        }
    }
    [self downloadBook];
}

- (void) bookNameDidDownloadsucesses:(NSString *)path    //Mr.chen, 2.25,
{
    self.isBookNameDownloaded = YES;
    if (self.cell != nil)
    {
        if (cell.entity == self)
        {
            self.cell.nameLabel.text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            if (self.cell.nameLabel.text == nil || [self.cell.nameLabel.text isEqualToString:@""]) {
                
                self.cell.nameLabel.text = @"smartApps";
            }
        }
    }
    [self downloadCover];
//    [self downloadBook];
}

-(void) onCoverdownloaderror
{
    self.isCoverDownloaded = YES;
    [self downloadBook];
}

-(void) bookNameDidDownloadError        //Mr.chen, 2.25,
{
    self.isBookNameDownloaded = YES;
//    [self downloadBook];
    [self downloadCover];       //Mr.chen, 2.25,
}

-(void) remove
{
    if (!self.isDownloaded)
    {
        [self.fileDownloader cancelDownloaderWithURl:self.downloadurl];       // 1.15 ,添加下载删除保护
    }
    
    [FileUtility delFileAtPath:[self getFilePath:self.tempid]];
}

-(NSString *) getCoverPath
{
    NSString *filefolder = [self getFilePath:self.tempid];
    filefolder = [filefolder stringByAppendingString:@"/cover.png"];
    return filefolder;
}

- (NSString *)getBookNamePath       //Mr.chen, 2.25,
{
    NSString *fildfolder = [self getFilePath:self.tempid];
    fildfolder = [fildfolder stringByAppendingString:@"/bookName.txt"];
    return fildfolder;
}

-(NSString *) getBookPath
{
    NSString *filefolder = [self getFilePath:self.tempid];
    filefolder = [filefolder stringByAppendingString:@"/book"];
    return filefolder;
}

-(NSString *)getFilePath:(NSString *)fileid
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    filePath = [filePath stringByAppendingPathComponent:fileid];
    return filePath;
}



@end
