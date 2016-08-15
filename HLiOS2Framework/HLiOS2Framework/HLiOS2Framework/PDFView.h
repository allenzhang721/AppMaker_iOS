//
//  PDFView.h
//  Core
//
//  Created by mac on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class PDFComponent;
@interface PDFView : UIView
{
    CGPDFPageRef pdfPage;
    //CGPDFDocumentRef doc;
    int pageIndex;
    NSString *pdfFile;
    PDFComponent *com;
}

@property (nonatomic , retain) NSString *pdfFile;
@property (nonatomic , assign) PDFComponent *com;
@property Boolean needLoad;
@property int pageIndex;

-(void) load;
@end
