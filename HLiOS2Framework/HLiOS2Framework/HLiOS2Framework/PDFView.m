//
//  PDFView.m
//  Core
//
//  Created by mac on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PDFView.h"
#import "PDFComponent.h"
#import "DejalActivityView.h"

@implementation PDFView

@synthesize pdfFile;
@synthesize pageIndex;
@synthesize com;
@synthesize needLoad;

static CGPDFDocumentRef doc;
static NSURL *pdfURL;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) load
{
    NSURL *url = [NSURL fileURLWithPath:pdfFile];
    if (!url) 
    {
        return;
    }
    if (!pdfURL) 
    {
        pdfURL = url;
        [pdfURL retain];
    }
    else if(![pdfURL isEqual:url])
    {
        [pdfURL release];
        pdfURL = url;
        [pdfURL retain];
        if (doc) 
        {
            CGPDFDocumentRelease(doc);
            doc = nil;
        }
    }
    if (!doc) 
    {
        [DejalBezelActivityView activityViewForView:self.superview.superview withLabel:@"载入中..."];
        doc =  CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
        [DejalBezelActivityView removeViewAnimated:YES];
    }
     pdfPage = CGPDFDocumentGetPage(doc, pageIndex);
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if (self.needLoad) 
    {
        [self load];
        self.needLoad = NO;
    }
    if (doc != NULL)
    {
        CGContextSaveGState(ctx);
        CGContextTranslateCTM(ctx, 0.0, layer.bounds.size.height);
        CGContextScaleCTM(ctx, 1.0, -1.0);
        CGRect pdfRect  = CGPDFPageGetBoxRect(pdfPage,kCGPDFCropBox);
        CGRect selfRect = self.bounds;
        selfRect.size = CGSizeMake(selfRect.size.width, selfRect.size.height);
        CGContextScaleCTM(ctx,selfRect.size.width/pdfRect.size.width,selfRect.size.height/pdfRect.size.height);
//        CGAffineTransform transform = CGPDFPageGetDrawingTransform(pdfPage, kCGPDFCropBox, self.bounds, -rotationAngle, YES);
//        transform = CGAffineTransformScale(transform ,selfRect.size.width/pdfRect.size.width,selfRect.size.height/pdfRect.size.height);
//        CGContextConcatCTM(ctx, transform);
//        CGContextSetRenderingIntent(ctx, kCGRenderingIntentDefault); 
 //       CGContextSetInterpolationQuality(ctx, kCGInterpolationDefault);
        CGContextSetRGBFillColor( ctx, 1.0, 1.0, 1.0, 1.0 );
        CGContextFillRect( ctx, CGContextGetClipBoundingBox( ctx ));
        CGContextDrawPDFPage(ctx, pdfPage);
        CGContextRestoreGState(ctx);
//        [self.com hideIndicator];
    }
}

- (void)dealloc 
{
    //NSLog(@"doc de");
    //CGPDFDocumentRelease(doc);
    [super dealloc];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
