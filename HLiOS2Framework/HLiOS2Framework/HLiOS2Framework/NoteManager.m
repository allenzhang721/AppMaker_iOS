//
//  NoteManager.m
//  MoueePDFViewer
//
//  Created by Mouee-iMac on 12-6-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NoteManager.h"
#import "EMTBXML.h"
#import "HLXMLWriter.h"


@implementation NoteButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGesture];
        tapGesture.delegate = (id<UIGestureRecognizerDelegate>)self;
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.cancelsTouchesInView = NO;
        [tapGesture release];
    }
    return self;
}

-(void)handleTap:(id)sender
{
    NSLog(@"note button tapped");
}

@end

@interface NoteManager ()
{
    NSMutableDictionary *notesArray;
}

-(void)load;
-(NSString*)recordFilePath;
-(int)generateNoteId;
-(NSString *)noteTextFilePath:(int)noteid;

@end

@implementation NoteManager

@synthesize pageid;
@synthesize notesArray;
@synthesize noteBtnDic;
@synthesize rangeDic;
@synthesize rootPath;

-(id)initWithId:(NSString *)pageId rootPath:(NSString*)path
{
    self = [super init];
    if (self) 
    {
        self.rootPath = path;
        self.pageid = pageId;
        notesArray = [[NSMutableDictionary alloc] initWithCapacity:4];
        rangeDic = [[NSMutableDictionary alloc] initWithCapacity:4];
        self.noteBtnDic = [[[NSMutableDictionary alloc] initWithCapacity:4] autorelease];
        [self load];
    }
    return self;
}

-(NSString*)recordFilePath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    if (self.rootPath)
    {
        NSString *mainBundle = [[NSBundle mainBundle] bundlePath];
        NSRange range = [self.rootPath rangeOfString:mainBundle];
        if (range.length < 1)
        {
            path = [self.rootPath  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-notes.xml", self.pageid]];
            return path;
        }
    }
    path = [path  stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-notes.xml", self.pageid]];
    return path;
}
-(NSString *)noteTextFilePath:(int)noteid
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    if (self.rootPath)
    {
        NSString *mainBundle = [[NSBundle mainBundle] bundlePath];
        NSRange range = [self.rootPath rangeOfString:mainBundle];
        if (range.length < 1)
        {
            path = [self.rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-note%d.txt", self.pageid, noteid]];
            return path;
        }
    }
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-note%d.txt", self.pageid, noteid]];
    return path;
}

-(void)load
{
    NSString *data = [NSString stringWithContentsOfFile:[self recordFilePath] encoding:NSUTF8StringEncoding error:NULL];
    if (data) 
    {
        EMTBXML* tbxml =[[EMTBXML newTBXMLWithXMLString:data error:nil] retain];
        TBXMLElement *root = tbxml.rootXMLElement;
        if (root)
        {
            TBXMLElement *postion = [EMTBXML childElementNamed:@"NOTE" parentElement:root];
            while(postion != nil) 
            {
                CGPoint oPoint;
                NSString *value;
                TBXMLElement *element = [EMTBXML childElementNamed:@"OX" parentElement:postion];
                if (element) 
                {
                    value = [EMTBXML textForElement:element];
                    oPoint.x = [value floatValue];
                }
                element = [EMTBXML childElementNamed:@"OY" parentElement:postion];
                if (element) 
                {
                    value = [EMTBXML textForElement:element];
                    oPoint.y = [value floatValue];
                }
                element = [EMTBXML childElementNamed:@"ID" parentElement:postion];
                int noteid = 0;
                if (element) 
                {
                    value = [EMTBXML textForElement:element];
                    noteid = [value intValue];
                }
                
                element = [EMTBXML childElementNamed:@"RANGE" parentElement:postion];
                NSString *rangeStr = @"";
                if (element)
                {
                    rangeStr = [EMTBXML textForElement:element];
                }
                [notesArray setObject:[NSValue valueWithCGPoint:oPoint] forKey:[NSNumber numberWithInt:noteid]];
                [rangeDic setObject:rangeStr forKey:[NSNumber numberWithInt:noteid]];
                postion =  [EMTBXML nextSiblingNamed:@"NOTE" searchFromElement:postion];
            }
        }
        [tbxml release];
    }
}

-(void)save
{
    HLXMLWriter *writer = [[HLXMLWriter alloc] init];
    [writer writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [writer writeStartElement:@"ROOT"];
    
    for (NSNumber *noteid in notesArray) 
    {
        NSValue *pointValue = [notesArray objectForKey:noteid];
        CGPoint point = [pointValue CGPointValue];
        
        [writer writeStartElement:@"NOTE"];
        
        NSString *value = [NSString stringWithFormat:@"%f", point.x];
        [writer writeStartElement:@"OX"];
        [writer writeCharacters:value];
        [writer writeEndElement];
        
        value = [NSString stringWithFormat:@"%f", point.y];
        [writer writeStartElement:@"OY"];
        [writer writeCharacters:value];
        [writer writeEndElement];
        
        value = [NSString stringWithFormat:@"%d", [noteid intValue]];
        [writer writeStartElement:@"ID"];
        [writer writeCharacters:value];
        [writer writeEndElement];
        
        value = [rangeDic objectForKey:noteid];
        if (value)
        {
            [writer writeStartElement:@"RANGE"];
            [writer writeCharacters:value];
            [writer writeEndElement];
        }
        
        [writer writeEndElement];
        
    }
    [writer writeEndElement];
    
    NSString *xmlContent = [writer toString];
    [xmlContent writeToFile:[self recordFilePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [writer release];
}

-(int)generateNoteId
{
    int i = 0;
    for (; i< 1000; ++i) 
    {
        NSValue *value = [notesArray objectForKey:[NSNumber numberWithInt:i]];
        if (!value) 
        {
            break;
        }
    }
    if (i >= 1000) 
    {
        i = 0;
    }
    return i;
}


-(int)addNote:(NSString *)text atPos:(CGPoint)pos withRange:(NSString *)rangeStr
{
    if (!text || text.length < 1) 
    {
        return -1;
    }
    int noteid = [self generateNoteId];
    [notesArray setObject:[NSValue valueWithCGPoint:pos] forKey:[NSNumber numberWithInt:noteid]];
    [rangeDic setObject:rangeStr forKey:[NSNumber numberWithInt:noteid]];
    NSString *path = [self noteTextFilePath:noteid];
    [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [self save];
    return noteid;
}
-(void)removeNote:(NSInteger)noteId
{
    NSValue *value = [notesArray objectForKey:[NSNumber numberWithInt:noteId]];
    if (value) 
    {
        [notesArray removeObjectForKey:[NSNumber numberWithInt:noteId]];
        UIButton *button = [noteBtnDic objectForKey:[NSNumber numberWithInt:noteId]];
        [button removeFromSuperview];
        [noteBtnDic removeObjectForKey:[NSNumber numberWithInt:noteId]];
        
        [rangeDic removeObjectForKey:[NSNumber numberWithInt:noteId]];
        [self save];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[self noteTextFilePath:noteId] error:nil];
    }
}

-(NSString *)getNoteText:(int)noteid
{
    NSString *text = [NSString stringWithContentsOfFile:[self noteTextFilePath:noteid] encoding:NSUTF8StringEncoding error:nil];
    return text;
}

-(void)saveNote:(int)noteid withText:(NSString *)text
{
    if (!text || text.length < 1) 
    {
        [self removeNote:noteid];
    }
    else 
    {
        [text writeToFile:[self noteTextFilePath:noteid] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

-(void)dealloc
{
    [self.pageid release];
    [notesArray release];
    [rangeDic release];
    [self.noteBtnDic release];
    [super dealloc];
}


@end
