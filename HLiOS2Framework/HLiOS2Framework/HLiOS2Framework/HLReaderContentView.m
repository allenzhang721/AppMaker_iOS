//
//	ReaderContentView.m
//	Reader v2.6.1
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2013 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ReaderConstants.h"
#import "HLReaderContentView.h"
#import "HLReaderContentPage.h"
#import "HLReaderThumbCache.h"

#import <QuartzCore/QuartzCore.h>

@implementation HLReaderContentView
{
	HLReaderContentPage *theContentView;

	HLReaderContentThumb *theThumbView;

	UIView *theContainerView;

	CGFloat zoomAmount;
}

#pragma mark Constants

#define ZOOM_LEVELS 4

#if (READER_SHOW_SHADOWS == TRUE) // Option
	#define CONTENT_INSET 4.0f
#else
	#define CONTENT_INSET 0.0f
#endif // end of READER_SHOW_SHADOWS Option

#define PAGE_THUMB_LARGE 249
#define PAGE_THUMB_SMALL 144

static void *ReaderContentViewContext = &ReaderContentViewContext;

#pragma mark Properties

@synthesize message;
@synthesize isPDFBookType;
@synthesize isHorizon;

#pragma mark ReaderContentView functions

static inline CGFloat ZoomScaleThatFits(CGSize target, CGSize source)
{
	CGFloat w_scale = (target.width / source.width);

	CGFloat h_scale = (target.height / source.height);

	return ((w_scale < h_scale) ? w_scale : h_scale);
}

#pragma mark ReaderContentView instance methods

- (void)updateMinimumMaximumZoom
{
	CGRect targetRect = CGRectInset(self.bounds, CONTENT_INSET, CONTENT_INSET);

//	CGFloat zoomScale = ZoomScaleThatFits(targetRect.size, theContentView.bounds.size);
    
    CGFloat w_scale = (targetRect.size.width / theContentView.bounds.size.width);
    
	CGFloat h_scale = (targetRect.size.height / theContentView.bounds.size.height);
    
	CGFloat zoomScale =  ((w_scale < h_scale) ? w_scale : h_scale);
    
//    if (isPDFBookType)
//    {
//        if (w_scale < h_scale)
//        {
//            float top = (h_scale - w_scale) * targetRect.size.height / 2.0;
//            theContainerView.frame = CGRectMake(theContainerView.frame.origin.x, top, theContainerView.frame.size.width, theContainerView.frame.size.height);
//        }
//        else
//        {
//            float left = (w_scale - h_scale) * targetRect.size.width / 2.0;
//            theContainerView.frame = CGRectMake(left, theContainerView.frame.origin.y, theContainerView.frame.size.width, theContainerView.frame.size.height);
//        }
//    }

	self.minimumZoomScale = zoomScale; // Set the minimum and maximum zoom scales

	self.maximumZoomScale = (zoomScale * ZOOM_LEVELS); // Max number of zoom levels

	zoomAmount = ((self.maximumZoomScale - self.minimumZoomScale) / ZOOM_LEVELS);
}

- (id)initWithFrame:(CGRect)frame fileURL:(NSURL *)fileURL page:(NSUInteger)page password:(NSString *)phrase isPDFBook:(BOOL)isPDFBook
{
	if ((self = [super initWithFrame:frame]))
	{
		self.scrollsToTop = NO;
		self.delaysContentTouches = NO;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor whiteColor];
		self.userInteractionEnabled = YES;
		self.autoresizesSubviews = NO;
		self.bouncesZoom = YES;
		self.delegate = self;

        isPDFBookType = isPDFBook;
        
		theContentView = [[HLReaderContentPage alloc] initWithURL:fileURL page:page password:phrase];
        if (theContentView.bounds.size.width < theContentView.bounds.size.height) {
            isHorizon = NO;
        }
        else
        {
            isHorizon = YES;
        }
		if (theContentView != nil) // Must have a valid and initialized content view
		{
			theContainerView = [[UIView alloc] initWithFrame:theContentView.bounds];

			theContainerView.autoresizesSubviews = NO;
			theContainerView.userInteractionEnabled = NO;
			theContainerView.contentMode = UIViewContentModeRedraw;
			theContainerView.autoresizingMask = UIViewAutoresizingNone;
			theContainerView.backgroundColor = [UIColor whiteColor];

#if (READER_SHOW_SHADOWS == TRUE) // Option

			theContainerView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
			theContainerView.layer.shadowRadius = 4.0f; theContainerView.layer.shadowOpacity = 1.0f;
			theContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:theContainerView.bounds].CGPath;

#endif // end of READER_SHOW_SHADOWS Option

			self.contentSize = theContentView.bounds.size; // Content size same as view size
//			self.contentOffset = CGPointMake((0.0f - CONTENT_INSET), (0.0f - CONTENT_INSET)); // Offset
//			self.contentInset = UIEdgeInsetsMake(CONTENT_INSET, CONTENT_INSET, CONTENT_INSET, CONTENT_INSET);

#if (READER_ENABLE_PREVIEW == TRUE) // Option

			theThumbView = [[HLReaderContentThumb alloc] initWithFrame:CGRectMake(0, 0, theContentView.bounds.size.width, theContentView.bounds.size.height - 1)]; // Page thumb view

			[theContainerView addSubview:theThumbView]; // Add the thumb view to the container view

#endif // end of READER_ENABLE_PREVIEW Option

			[theContainerView addSubview:theContentView]; // Add the content view to the container view

			[self addSubview:theContainerView]; // Add the container view to the scroll view

			[self updateMinimumMaximumZoom]; // Update the minimum and maximum zoom scales

			self.zoomScale = self.minimumZoomScale; // Set zoom to fit page content
		}

		[self addObserver:self forKeyPath:@"frame" options:0 context:ReaderContentViewContext];

		self.tag = page; // Tag the view with the page number
	}

	return self;
}

- (void)dealloc
{
//	[self removeObserver:self forKeyPath:@"frame" context:ReaderContentViewContext];

	[self removeObserver:self forKeyPath:@"frame"]; // Maintain iOS 4.x compatability
}

- (void)showPageThumb:(NSURL *)fileURL page:(NSInteger)page password:(NSString *)phrase guid:(NSString *)guid
{
#if (READER_ENABLE_PREVIEW == TRUE) // Option

	BOOL large = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad); // Page thumb size

	CGSize size = (large ? CGSizeMake(PAGE_THUMB_LARGE, PAGE_THUMB_LARGE) : CGSizeMake(PAGE_THUMB_SMALL, PAGE_THUMB_SMALL));

	HLReaderThumbRequest *request = [HLReaderThumbRequest newForView:theThumbView fileURL:fileURL password:phrase guid:guid page:page size:size];

	UIImage *image = [[HLReaderThumbCache sharedInstance] thumbRequest:request priority:YES]; // Request the page thumb

	if ([image isKindOfClass:[UIImage class]]) [theThumbView showImage:image]; // Show image from cache

#endif // end of READER_ENABLE_PREVIEW Option
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (context == ReaderContentViewContext) // Our context
	{
		if ((object == self) && [keyPath isEqualToString:@"frame"])
		{
			CGFloat oldMinimumZoomScale = self.minimumZoomScale;

			[self updateMinimumMaximumZoom]; // Update zoom scale limits

			if (self.zoomScale == oldMinimumZoomScale) // Old minimum
			{
				self.zoomScale = self.minimumZoomScale;
			}
			else // Check against minimum zoom scale
			{
				if (self.zoomScale < self.minimumZoomScale)
				{
					self.zoomScale = self.minimumZoomScale;
				}
				else // Check against maximum zoom scale
				{
					if (self.zoomScale > self.maximumZoomScale)
					{
						self.zoomScale = self.maximumZoomScale;
					}
				}
			}
		}
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGSize boundsSize = self.bounds.size;
	CGRect viewFrame = theContainerView.frame;

	if (viewFrame.size.width < boundsSize.width)
		viewFrame.origin.x = (((boundsSize.width - viewFrame.size.width) / 2.0f) + self.contentOffset.x);
	else
		viewFrame.origin.x = 0.0f;

	if (viewFrame.size.height < boundsSize.height)
		viewFrame.origin.y = (((boundsSize.height - viewFrame.size.height) / 2.0f) + self.contentOffset.y);
	else
		viewFrame.origin.y = 0.0f;

	theContainerView.frame = viewFrame;
}

- (id)processSingleTap:(UITapGestureRecognizer *)recognizer
{
	return [theContentView processSingleTap:recognizer];
}

- (void)zoomIncrement
{
	CGFloat zoomScale = self.zoomScale;

	if (zoomScale < self.maximumZoomScale)
	{
		zoomScale += zoomAmount; // += value

		if (zoomScale > self.maximumZoomScale)
		{
			zoomScale = self.maximumZoomScale;
		}

		[self setZoomScale:zoomScale animated:YES];
	}
}

- (void)zoomDecrement
{
	CGFloat zoomScale = self.zoomScale;

	if (zoomScale > self.minimumZoomScale)
	{
		zoomScale -= zoomAmount; // -= value

		if (zoomScale < self.minimumZoomScale)
		{
			zoomScale = self.minimumZoomScale;
		}

		[self setZoomScale:zoomScale animated:YES];
	}
}

- (void)zoomReset
{
	if (self.zoomScale > self.minimumZoomScale)
	{
		self.zoomScale = self.minimumZoomScale;
	}
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return theContainerView;
}

#pragma mark UIResponder instance methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event]; // Message superclass

	[message contentView:self touchesBegan:touches]; // Message delegate
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event]; // Message superclass
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event]; // Message superclass
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event]; // Message superclass
}

@end

#pragma mark -

//
//	ReaderContentThumb class implementation
//

@implementation HLReaderContentThumb

#pragma mark ReaderContentThumb instance methods

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) // Superclass init
	{
		imageView.contentMode = UIViewContentModeScaleAspectFill;

		imageView.clipsToBounds = YES; // Needed for aspect fill
	}

	return self;
}

@end
