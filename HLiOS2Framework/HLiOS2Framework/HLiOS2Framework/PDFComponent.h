//
//  PDFComponent.h
//  Core
//
//  Created by mac on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "PDFView.h"
#import "HLReaderViewController.h"
#import "PDFEntity.h"

@interface PDFComponent : Component<UIScrollViewDelegate>
{
    PDFView  *pdfView;
    UIImageView *imgView;
    PDFView  *oldView;
    HLReaderViewController *readerViewController;
    HLReaderDocument *document;
}
@property (nonatomic , retain) PDFEntity   *pdfEntity;
@property (nonatomic , retain) PDFView   *pdfView;
@property (nonatomic , retain) UIImageView *imgView;
@property (nonatomic , retain) PDFView   *oldView;

//-(id) initWithPath:(NSString*) file:(int) index:(float) width:(float) height:(NSString *) img;

@end
