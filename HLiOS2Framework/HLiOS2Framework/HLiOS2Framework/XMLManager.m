//
//  XMLManager.m
//  readXml
//
//  Created by user on 12-3-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XMLManager.h"
#import "TBXML.h"
#import "CommonFunc.h"
#import <CommonCrypto/CommonDigest.h>

static  NSStringEncoding const secrtEncoding = NSNEXTSTEPStringEncoding;
                                                                                /* available encoding
     
                                                                                 NSASCIIStringEncoding              x
                                                                                 NSNEXTSTEPStringEncoding           v
                                                                                 NSJapaneseEUCStringEncoding        x
                                                                                 NSUTF8StringEncoding               x
                                                                                 NSISOLatin1StringEncoding          v
                                                                                 NSSymbolStringEncoding             v
                                                                                 NSNonLossyASCIIStringEncoding      x
                                                                                 NSShiftJISStringEncoding           v
                                                                                 NSISOLatin2StringEncoding          v
                                                                                 NSUnicodeStringEncoding            x
                                                                                 NSWindowsCP1251StringEncoding      v
                                                                                 NSWindowsCP1252StringEncoding      v
                                                                                 NSWindowsCP1253StringEncoding      v
                                                                                 NSWindowsCP1254StringEncoding      v
                                                                                 NSWindowsCP1250StringEncoding      v
                                                                                 NSISO2022JPStringEncoding          x
                                                                                 NSMacOSRomanStringEncoding         v
                                                                                 NSUTF16StringEncoding              x
                                                                                 NSUTF16BigEndianStringEncoding     x
                                                                                 NSUTF16LittleEndianStringEncoding  x
                                                                                 NSUTF32StringEncoding              x
                                                                                 NSUTF32BigEndianStringEncoding     x
                                                                                 NSUTF32LittleEndianStringEncoding  x

                                                                                 */

typedef enum{
    L = 0,
    H
}XMLManagerType;

@interface XMLManager ()


- (NSString *)key;

@end

@implementation XMLManager
@synthesize items;
@synthesize data;
@synthesize offset;
- (id)init
{
    self = [super init];
    if (self)
    {
        self.items = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    }
    return self;
}


-(void) decode:(NSString *) xml
{
    [self.items removeAllObjects];
    //NSLog(@"%@",xml);
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    TBXML* tbxml = [[TBXML newTBXMLWithXMLString:xml error:nil] autorelease];
    TBXMLElement *root = tbxml.rootXMLElement;
    if (root)
    {
        TBXMLElement *xmlIndexs = [TBXML childElementNamed:@"xmlIndex" parentElement:root];
        while (xmlIndexs != nil)
        {
            XMLItem *item = [[XMLItem alloc] init];
            item.itemid   = [TBXML textForElement:[TBXML childElementNamed:@"id" parentElement:xmlIndexs]];
            item.start    = [[TBXML textForElement:[TBXML childElementNamed:@"startnumber" parentElement:xmlIndexs]] intValue];
            item.end      = [[TBXML textForElement:[TBXML childElementNamed:@"endnumber" parentElement:xmlIndexs]] intValue];
            xmlIndexs = [TBXML nextSiblingNamed:@"xmlIndex" searchFromElement:xmlIndexs];
            [self.items addObject:item];
            [item release];
        }
    }
    [pool release];
}

-(XMLItem *) getXMLItem:(NSString *) itemid
{
    for (int i = 0 ; i < [self.items count]; i++)
    {
        XMLItem *item =  [self.items objectAtIndex:i];
        if ([item.itemid compare:itemid] == NSOrderedSame)
        {
            return item;
        }
    }
    return nil;
}

//- (NSString *) getenstrByInterval:(id)Interval type:(XMLManagerType)atype
//{
//    NSData *theData = nil;
//    switch (atype) {
//        case L:
//        {
//            if (!data)
//            {
//                return @"";
//            }
//
//            theData = [data subdataWithRange:NSMakeRange(4, [data length] - 4)];
//        }
//            break;
//
//        case H:
//            break;
//    }
//
//    if (!theData) {
//        return @"";
//    }
//    int length = [theData length];
//    int step = 1;
//    int interval = [Interval intValue];
//    if (length > interval)
//    {
//        step = length / interval;
//    }
//
//    int point = 0;
//    NSString *result = @"";
//    NSString *cha = @"";
//    for (int i = 0 ; i < interval; i++)
//    {
//        NSData *chData = [theData subdataWithRange:NSMakeRange(point, 1)];
//        if (chData) {
//            cha = [[NSString alloc] initWithData:chData encoding:NSUTF8StringEncoding];
//            result = [result stringByAppendingFormat:@"%@",cha];
//            [cha release];
//        }
//        point = point+step;
//        if ( point >= length)
//        {
//            point = point % length;
//        }
//    }
//    return result;
//}



/*
 - (NSData *)getenData:(NSData *)data Interval:(NSInteger)interval
 {
 if (!data) {
 
 return nil;
 }
 unsigned char resultByte[16];
 
 Byte *bytes = (Byte *)[data bytes];
 NSInteger dataLength = [data length];
 
 NSInteger step = dataLength > interval ? dataLength/interval : 1;
 NSInteger point = 0;
 for (int i = 0; i < interval ; i++) {
 
 resultByte[i] = bytes[i + point];
 point = point + step;
 if (point >= dataLength) {
 
 point = point % dataLength;
 }
 }
 
 for (int i = 0 ; i < interval ; i++) {
 
 NSLog(@"%d",resultByte[i]);
 }
 
 
 NSData *adata = [[NSData alloc] initWithBytes:resultByte length:interval];
 
 NSLog(@"adata = %@",adata);
 
 return adata;
 }
 */

- (NSString *) getenstrByInterval:(id)interval type:(XMLManagerType)atype
{
    NSData *theData = nil;
    switch (atype)
    {
        case L:
        {
            theData = [data subdataWithRange:NSMakeRange(4, [data length] - 4)];
        }
            break;
            
        default:
            break;
    }
    NSInteger theInterval = [interval integerValue];
    Byte *abytes = (Byte *)[theData bytes];
    NSInteger dataLength = [theData length];
    NSInteger step = dataLength > theInterval ? dataLength/theInterval : 1;
    NSInteger point = 0;
//
    uint8_t resultByte[theInterval];
    for (int i = 0 ; i < theInterval ; i++)
    {
        
        resultByte[i] = abytes[point];
        point = point + step;
        if (point >= dataLength)
        {
            
            point = point % dataLength;
        }
    }
//    
//    for (int i = 0 ; i < theInterval ; i++) {
//        
//        NSLog(@"%d ----> %d",theInterval,resultByte[i]);
//    }
    
    NSString *underString = [[NSString alloc] initWithBytes:resultByte length:theInterval encoding:secrtEncoding];
    NSLog(@"~~%d ----> %@",theInterval,underString);
    
//    NSLog(@"MD5 = %@",[[self md5:underString] lowercaseString]);
//
//    NSLog(@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n");
//    NSData *aData = [NSData dataWithBytes:resultByte length:dataLength];
    
    return underString;
}

- (NSString *)stringL       //book.dat
{
    NSString *underString = [self getenstrByInterval:[self bookKey] type:L];
    
    return [[self md5:underString] lowercaseString];
}

- (NSString *)stringH       //hash.dat
{
    
    NSString *underString = [self getenstrByInterval:[self bookHash] type:L];
    
    return [[self md5:underString] lowercaseString];
//    NSData *orginData = [self getenstrByInterval:[self bookHash] type:L];
//    
//    return [self getMD5WithData:orginData];
}

- (id)bookKey
{
    return @((sqrtf(powf(11 + 165, 2) - sqrtf(pow(30940, 2)))+100+93-17)/sqrtf(pow(13-21,2))*fabs((39589 - 34089)/1375)); //85
}

- (id)bookHash
{
    return @((200-24-fabs(sqrtf(fabs(sqrtf(pow(30940, 2)) - powf(11 + 165, 2)) )))/(sqrtf(pow(13-21,2))/fabs((39589 - 34089)/1375))); //91
}


-(NSString *) getStringByID:(NSString *) itemid
{
    NSString *retStr = @"";
    XMLItem *item = [self getXMLItem:itemid];
    if (item) {
        NSData *iddata = [data subdataWithRange:NSMakeRange(item.start + offset, item.end - item.start)];
        retStr = [[[NSString alloc] initWithData:iddata encoding:NSUTF8StringEncoding] autorelease];
    }
    return retStr;
}

+(NSString *) getMD5:(NSString *) value
{
    const char *cStr = [value UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

-(NSData *) getendata
{
    if (!data) {
        return nil;
    }
    NSData *xmlData = [data subdataWithRange:NSMakeRange(4, [data length] - 4)];
    if (!xmlData) {
        return nil;
    }
    int length = [xmlData length];
    int step = 1;
    if (length > 97)
    {
        step = length / 97;
    }
    
    int point = 0;
    NSMutableData *result = [[NSMutableData alloc] init];
    for (int i = 0 ; i < 97; i++)
    {
        NSData *chData = [xmlData subdataWithRange:NSMakeRange(point, 1)];
        if (chData) {
            [result appendData:chData];
        }
        point = point+step;
        if ( point >= length)
        {
            point = point % length;
        }
    }
    return [result autorelease];
}

-(NSString *) getMD5WithData:(NSData *) value
{
    if (!value)
    {
        return nil;
    }
    unsigned char digest[16];
    void *bytes = malloc([value length]);
    if (!bytes)
    {
        return nil;
    }
    [value getBytes:bytes];
    CC_MD5(bytes, [value length], digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    free(bytes);
    return  output;
}

//md5 16位加密 （大写）

-(NSString *)md5:(NSString *)str {

    if (!str) {
        return Nil;
    }
    const char *cStr = [str cStringUsingEncoding:secrtEncoding];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result);
    return [NSString stringWithFormat:

            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",

            
            result[0], result[1], result[2], result[3],
            
            
            
            result[4], result[5], result[6], result[7],
            
            
            
            result[8], result[9], result[10], result[11],
            
            
            
            result[12], result[13], result[14], result[15]

            ]; 

}

- (void)dealloc
{
    [self.items removeAllObjects];
    [self.items release];
    [self.data release];
    
    [super dealloc];
}
@end
