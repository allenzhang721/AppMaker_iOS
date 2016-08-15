//
//  ShelfEntity.m
//  MoueeRealTimeTest2
//
//  Created by Pi Yi on 4/19/13.
//  Copyright (c) 2013 北京谋易软件有限责任公司. All rights reserved.
//

#import "ShelfEntity.h"
#import "XMLWriter.h"
#import "ShelfBookEntity.h"
#import "TBXML.h"

@implementation ShelfEntity

@synthesize  books;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.books = [[NSMutableArray alloc] initWithCapacity:5];
        [self load];
    }
    return self;
}

-(void) save
{
    XMLWriter *writer = [[XMLWriter alloc] init];
    [writer writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [writer writeStartElement:@"ROOT"];
    [writer writeStartElement:@"BOOKS"];
    [writer writeCharacters:@"北京谋易软件有限责任公司版权所有"];
    for (int i = 0 ; i < [self.books count]; i++)
    {
        ShelfBookEntity *entity = [self.books objectAtIndex:i];
        [entity encode:writer];
    }
    
    [writer writeEndElement];
    [writer writeEndElement];
    [writer writeEndDocument];
    
    NSString *xmlContents = [writer toString];
    NSString *rootpath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSString *path = [rootpath stringByAppendingPathComponent:@"books.xml"];
    NSError *err = [[NSError alloc] init];
    Boolean ret = [xmlContents writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!ret)
    {
        NSLog(@"fail to save ownbooks.xml %@", [err localizedDescription]);
    }
    [writer release];
    [err release];
}

-(void) load
{
    NSString *rootpath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSString *path = [rootpath stringByAppendingPathComponent:@"books.xml"];
    NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (data != nil)
    {
        TBXML* tbxml = [[TBXML newTBXMLWithXMLString:data error:nil] retain];
        TBXMLElement *root = tbxml.rootXMLElement;
        if (root)
        {
            TBXMLElement *bks = [TBXML childElementNamed:@"BOOKS" parentElement:root];
            TBXMLElement *book = [TBXML childElementNamed:@"BOOK" parentElement:bks];
            while(book != nil)
            {
                ShelfBookEntity *entity = [[[ShelfBookEntity alloc] init] autorelease];
                [entity decode:book];
                [self.books addObject:entity];
                book =  [TBXML nextSiblingNamed:@"BOOK" searchFromElement:book];
            }
        }
        [tbxml release];
    }
}

@end






