//
//  PDFComponent.m
//  Core
//
//  Created by mac on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PDFComponent.h"
#import "HLContainer.h"
#import "DejalActivityView.h"
#import "PDFEntity.h"
#import "HLReaderDocument.h"


@implementation PDFComponent

@synthesize pdfView;
@synthesize imgView;
@synthesize oldView;

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.pdfEntity = (PDFEntity *)entity;
        NSString *path = [entity.rootPath stringByAppendingPathComponent:entity.fileName];
        NSString *phrase = nil;
        document = [HLReaderDocument withDocumentFilePath:path password:phrase isReload:NO];
        readerViewController = [[HLReaderViewController alloc] initWithReaderDocument:document frame:CGRectMake([entity.x intValue], [entity.y intValue], [entity.width intValue], [entity.height intValue]) index:((PDFEntity *)entity).index isPDFBook:NO];
        
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;

        self.uicomponent = readerViewController.view;
    }
    return self;
}



- (void)dealloc 
{
    //NSLog(@"PDF");
    [readerViewController.view removeFromSuperview];
    [readerViewController release];
    document = nil;
	[self.uicomponent release];
    [super dealloc];
}
@end
