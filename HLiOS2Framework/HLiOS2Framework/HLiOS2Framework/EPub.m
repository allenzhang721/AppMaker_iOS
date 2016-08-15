//
//  EPub.m
//  AePubReader
//
//  Created by Federico Frappi on 05/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EPub.h"
#import "HLZipArchive.h"
#import "Chapter.h"
#import "CXMLNode_XPathExtensions.h"

@interface EPub()

- (void) parseEpub;
- (void) unzipAndSaveFileNamed:(NSString*)fileName;
- (NSString*) applicationDocumentsDirectory;
- (NSString*) parseManifestFile;
- (void) parseOPF:(NSString*)opfPath;

@end

@implementation EPub

@synthesize spineArray;

- (id) initWithEPubPath:(NSString *)path{
	if((self=[super init])){
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"curBookIndex"]) {
            curBookIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"curBookIndex"] intValue] + 1;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:curBookIndex] forKey:@"curBookIndex"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"curBookIndex"];
            curBookIndex = 0;
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
		epubFilePath = [path retain];
		spineArray = [[NSMutableArray alloc] init];
		[self parseEpub];
	}
	return self;
}

- (void) parseEpub{
	[self unzipAndSaveFileNamed:epubFilePath];

	NSString* opfPath = [self parseManifestFile];
	[self parseOPF:opfPath];
}

- (void)unzipAndSaveFileNamed:(NSString*)fileName{
	
	HLZipArchive* za = [[HLZipArchive alloc] init];
//	NSLog(@"%@", fileName);
//	NSLog(@"unzipping %@", epubFilePath);
	if( [za UnzipOpenFile:epubFilePath]){
		NSString *strPath=[NSString stringWithFormat:@"%@/UnzippedEpub%d",[self applicationDocumentsDirectory], curBookIndex];
//		NSLog(@"%@", strPath);
		//Delete all the previous files
		NSFileManager *filemanager=[[NSFileManager alloc] init];
		if ([filemanager fileExistsAtPath:strPath]) {
			NSError *error;
			[filemanager removeItemAtPath:strPath error:&error];
		}
		[filemanager release];
		filemanager=nil;
		//start unzip
		BOOL ret = [za UnzipFileTo:[NSString stringWithFormat:@"%@/",strPath] overWrite:YES];
		if( NO==ret ){
			// error handler here
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error"
														  message:@"Error while unzipping the epub"
														 delegate:self
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
			[alert show];
			[alert release];
			alert=nil;
		}
		[za UnzipCloseFile];
	}					
	[za release];
}

- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString*) parseManifestFile{
	NSString* manifestFilePath = [NSString stringWithFormat:@"%@/UnzippedEpub%d/META-INF/container.xml", [self applicationDocumentsDirectory], curBookIndex];
//	NSLog(@"%@", manifestFilePath);
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if ([fileManager fileExistsAtPath:manifestFilePath]) {
		//		NSLog(@"Valid epub");
		HLCXMLDocument* manifestFile = [[[HLCXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:manifestFilePath] options:0 error:nil] autorelease];
		HLCXMLNode* opfPath = [manifestFile nodeForXPath:@"//@full-path[1]" error:nil];
//		NSLog(@"%@", [NSString stringWithFormat:@"%@/UnzippedEpub/%@", [self applicationDocumentsDirectory], [opfPath stringValue]]);
		return [NSString stringWithFormat:@"%@/UnzippedEpub%d/%@", [self applicationDocumentsDirectory], curBookIndex, [opfPath stringValue]];
	} else {
//		NSLog(@"ERROR: ePub not Valid");
		return nil;
	}
	[fileManager release];
}

- (void) parseOPF:(NSString*)opfPath{
	HLCXMLDocument* opfFile = [[HLCXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
	NSArray* itemsArray = [opfFile nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
//	NSLog(@"itemsArray size: %d", [itemsArray count]);
    
    NSString* ncxFileName;
	
    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
	for (HLCXMLElement* element in itemsArray) {
		[itemDictionary setValue:[[element attributeForNamePublic:@"href"] stringValue] forKey:[[element attributeForNamePublic:@"id"] stringValue]];
        if([[[element attributeForNamePublic:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
            ncxFileName = [[element attributeForNamePublic:@"href"] stringValue];
//          NSLog(@"%@ : %@", [[element attributeForNamePublic:@"id"] stringValue], [[element attributeForNamePublic:@"href"] stringValue]);
        }
        
        if([[[element attributeForNamePublic:@"media-type"] stringValue] isEqualToString:@"application/xhtml+xml"]){
            ncxFileName = [[element attributeForNamePublic:@"href"] stringValue];
//          NSLog(@"%@ : %@", [[element attributeForNamePublic:@"id"] stringValue], [[element attributeForNamePublic:@"href"] stringValue]);
        }
	}
	
    int lastSlash = [opfPath rangeOfString:@"/" options:NSBackwardsSearch].location;
	NSString* ebookBasePath = [opfPath substringToIndex:(lastSlash +1)];
    HLCXMLDocument* ncxToc = [[HLCXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, ncxFileName]] options:0 error:nil];
    NSMutableDictionary* titleDictionary = [[NSMutableDictionary alloc] init];
    for (HLCXMLElement* element in itemsArray) {
        NSString* href = [[element attributeForNamePublic:@"href"] stringValue];
        NSString* xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", href];
        NSArray* navPoints = [ncxToc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
        if([navPoints count]!=0){
            HLCXMLElement* titleElement = [navPoints objectAtIndex:0];
           [titleDictionary setValue:[titleElement stringValue] forKey:href];
        }
    }

	
	NSArray* itemRefsArray = [opfFile nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
//	NSLog(@"itemRefsArray size: %d", [itemRefsArray count]);
	NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    int count = 0;
	for (HLCXMLElement* element in itemRefsArray) {
        NSString* chapHref = [itemDictionary valueForKey:[[element attributeForNamePublic:@"idref"] stringValue]];

        Chapter* tmpChapter = [[Chapter alloc] initWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, chapHref]
                                                       title:[titleDictionary valueForKey:chapHref] 
                                                chapterIndex:count++];
		[tmpArray addObject:tmpChapter];
		
		[tmpChapter release];
	}
	
	self.spineArray = [NSArray arrayWithArray:tmpArray]; 
	
	[opfFile release];
	[tmpArray release];
	[ncxToc release];
	[itemDictionary release];
	[titleDictionary release];
}

- (void)dealloc {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
        for (int i = 0; i < fileArray.count; i++)
        {
            if ([[fileArray objectAtIndex:i] length] >= 12)
            {
                NSString *itemName = [[fileArray objectAtIndex:i] substringToIndex:12];
                if ([itemName isEqualToString:@"UnzippedEpub"])
                {
                    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", path, [fileArray objectAtIndex:i]] error:nil];
                }
            }
        }
    }
    [spineArray release];
	[epubFilePath release];
    [super dealloc];
}

//- (void) parseOPF:(NSString*)opfPath{
//	CXMLDocument* opfFile = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
//	NSArray* itemsArray = [opfFile nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
//    //	NSLog(@"itemsArray size: %d", [itemsArray count]);
//    
//    NSString* ncxFileName;
//	
//    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
//	for (CXMLElement* element in itemsArray) {
//		[itemDictionary setValue:[[element attributeForNamePublic:@"href"] stringValue] forKey:[[element attributeForNamePublic:@"id"] stringValue]];
//        if([[[element attributeForNamePublic:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
//            ncxFileName = [[element attributeForNamePublic:@"href"] stringValue];
//            //          NSLog(@"%@ : %@", [[element attributeForNamePublic:@"id"] stringValue], [[element attributeForNamePublic:@"href"] stringValue]);
//        }
//        
//        if([[[element attributeForNamePublic:@"media-type"] stringValue] isEqualToString:@"application/xhtml+xml"]){
//            ncxFileName = [[element attributeForNamePublic:@"href"] stringValue];
//            //          NSLog(@"%@ : %@", [[element attributeForNamePublic:@"id"] stringValue], [[element attributeForNamePublic:@"href"] stringValue]);
//        }
//	}
//	
//    int lastSlash = [opfPath rangeOfString:@"/" options:NSBackwardsSearch].location;
//	NSString* ebookBasePath = [opfPath substringToIndex:(lastSlash +1)];
//    CXMLDocument* ncxToc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, ncxFileName]] options:0 error:nil];
//    NSMutableDictionary* titleDictionary = [[NSMutableDictionary alloc] init];
//    for (CXMLElement* element in itemsArray) {
//        NSString* href = [[element attributeForNamePublic:@"href"] stringValue];
//        NSString* xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", href];
//        NSArray* navPoints = [ncxToc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
//        if([navPoints count]!=0){
//            CXMLElement* titleElement = [navPoints objectAtIndex:0];
//            [titleDictionary setValue:[titleElement stringValue] forKey:href];
//        }
//    }
//    
//	
//	NSArray* itemRefsArray = [opfFile nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
//    //	NSLog(@"itemRefsArray size: %d", [itemRefsArray count]);
//	NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
//    int count = 0;
//	for (CXMLElement* element in itemRefsArray) {
//        NSString* chapHref = [itemDictionary valueForKey:[[element attributeForNamePublic:@"idref"] stringValue]];
//        
//        Chapter* tmpChapter = [[Chapter alloc] initWithPath:[NSString stringWithFormat:@"%@%@", ebookBasePath, chapHref]
//                                                      title:[titleDictionary valueForKey:chapHref]
//                                               chapterIndex:count++];
//		[tmpArray addObject:tmpChapter];
//		
//		[tmpChapter release];
//	}
//	
//	self.spineArray = [NSArray arrayWithArray:tmpArray];
//	
//	[opfFile release];
//	[tmpArray release];
//	[ncxToc release];
//	[itemDictionary release];
//	[titleDictionary release];
//}

@end
