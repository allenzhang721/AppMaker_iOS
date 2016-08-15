//
//  SYPageControl.m
//  SYPaginator
//
//  Created by Sam Soffes on 3/20/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import "SYPageControl.h"

static NSInteger const kSYPageControlMaxNumberOfDots = 12;

@interface SYPageControl ()
- (void)_pageControlChanged:(id)sender;
@end

@implementation SYPageControl

@synthesize numberOfPages = _numberOfPages;
@synthesize currentPage = _currentPage;
@synthesize hidesForSinglePage = _hidesForSinglePage;
@synthesize pageControl = _pageControl;

- (void)setNumberOfPages:(NSInteger)numberOfPages {
	_numberOfPages = numberOfPages;
	if (numberOfPages == 1 && _hidesForSinglePage) {
		[_pageControl removeFromSuperview];
		return;
	}
	
	if (numberOfPages <= kSYPageControlMaxNumberOfDots) {
		_pageControl.numberOfPages = numberOfPages;
		if (!_pageControl.superview) {
			[self addSubview:_pageControl];
		}
	} else {
		_pageControl.numberOfPages = 0;
		[_pageControl removeFromSuperview];
		
	}
	
	[self setNeedsLayout];
}


- (void)setCurrentPage:(NSInteger)currentPage {
	currentPage = (NSInteger)fminf(fmaxf(0.0f, (CGFloat)currentPage), (CGFloat)_numberOfPages - 1.0f);
	if (currentPage == _currentPage) {
		return;
	}
	
	_currentPage = currentPage;
	
	if (_numberOfPages <= kSYPageControlMaxNumberOfDots) {
		_pageControl.currentPage = currentPage;
	} else {
//		[self _updateTextLabel];
	}
}


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		_pageControl = [[[UIPageControl alloc] initWithFrame:CGRectZero] autorelease];
		[_pageControl addTarget:self action:@selector(_pageControlChanged:) forControlEvents:UIControlEventValueChanged];
		
	}
	return self;
}


- (void)layoutSubviews {
	_pageControl.frame = self.bounds;
}


#pragma mark - Private
- (void)dealloc
{
    [_pageControl removeFromSuperview];
    _pageControl = nil;
    [super dealloc];
}



- (void)_pageControlChanged:(id)sender {
	self.currentPage = _pageControl.currentPage;
	[self sendActionsForControlEvents:UIControlEventValueChanged];	
}


- (void)_labelTapped:(UITapGestureRecognizer *)gestureRecognizer {
	BOOL increment = [gestureRecognizer locationInView:self].x >= self.bounds.size.width / 2.0f;
	self.currentPage += increment ? 1 : -1;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
