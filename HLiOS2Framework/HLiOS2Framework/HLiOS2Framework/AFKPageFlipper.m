//
//  AFKPageFlipper.m
//  AFKPageFlipper
//
//  Created by Marco Tabini on 10-10-12.
//  Copyright 2010 AFK Studio Partnership. All rights reserved.
//
//  Modified by Reefaq Mohammed on 16/07/11.
 
//
#import "AFKPageFlipper.h"


#pragma mark -
#pragma mark UIView helpers


@interface UIView(Extended) 

- (UIImage *) imageByRenderingView;

@end


@implementation UIView(Extended)


- (UIImage *) imageByRenderingView {
	CGFloat oldAlpha = self.alpha;
	
	self.alpha = 1;
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	self.alpha = oldAlpha;
	
	return resultingImage;
}

@end


#pragma mark -
#pragma mark Private interface


//@interface AFKPageFlipper()
//
//@property (nonatomic,assign) UIView *currentView;
//@property (nonatomic,assign) UIView *newView;
//
//@end


@implementation AFKPageFlipper


#pragma mark -
#pragma mark Flip functionality
@synthesize thenewView;

@synthesize pageDifference,numberOfPages,animating;

- (void) initFlip {
	NSAutoreleasePool* newpool = [[NSAutoreleasePool alloc] init];
	// Create screenshots of view
	UIImage *currentImage = [self.currentView imageByRenderingView];
	UIImage *newImage = [self.thenewView imageByRenderingView] ;
	
	
	// Hide existing views
	[self.currentView setHidden:TRUE];
	[self.thenewView setHidden:TRUE];	
	self.currentView.alpha = 0;
	self.thenewView.alpha = 0;
	
	// Create representational layers
	
	CGRect rect = self.bounds;
	rect.size.width /= 2;
	
	backgroundAnimationLayer = [CALayer layer];
	backgroundAnimationLayer.frame = self.bounds;
	backgroundAnimationLayer.zPosition = -300000;
	
	CALayer *leftLayer = [CALayer layer];
	leftLayer.frame = rect;
	leftLayer.masksToBounds = YES;
	leftLayer.contentsGravity = kCAGravityLeft;
	
	[backgroundAnimationLayer addSublayer:leftLayer];
	
	rect.origin.x = rect.size.width;
	
	CALayer *rightLayer = [CALayer layer];
	rightLayer.frame = rect;
	rightLayer.masksToBounds = YES;
	rightLayer.contentsGravity = kCAGravityRight;
	
	[backgroundAnimationLayer addSublayer:rightLayer];
	
	if (flipDirection == AFKPageFlipperDirectionRight) {
		leftLayer.contents = (id) [newImage CGImage];
		rightLayer.contents = (id) [currentImage CGImage];
	} else {
		leftLayer.contents = (id) [currentImage CGImage];
		rightLayer.contents = (id) [newImage CGImage];
	}
	
	[self.layer addSublayer:backgroundAnimationLayer];
	
	rect.origin.x = 0;
	
	flipAnimationLayer = [CATransformLayer layer];
	flipAnimationLayer.anchorPoint = CGPointMake(1.0, 0.5);
	flipAnimationLayer.frame = rect;
	
	
	
	[self.layer addSublayer:flipAnimationLayer];
	

		
	CALayer *backLayer = [CALayer layer];
	backLayer.frame = flipAnimationLayer.bounds;
	backLayer.doubleSided = NO;
	backLayer.masksToBounds = YES;
	[flipAnimationLayer addSublayer:backLayer];
	
	CALayer *frontLayer = [CALayer layer];
	frontLayer.frame = flipAnimationLayer.bounds;
	frontLayer.doubleSided = NO;
	frontLayer.masksToBounds = YES;
	frontLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
	[flipAnimationLayer addSublayer:frontLayer];
	
	if (flipDirection == AFKPageFlipperDirectionRight) {
		
		backLayer.contents = (id) [currentImage CGImage];
		backLayer.contentsGravity = kCAGravityLeft;
		
		frontLayer.contents = (id) [newImage CGImage];
		frontLayer.contentsGravity = kCAGravityRight;
		
		CATransform3D transform = CATransform3DMakeRotation(0.0, 0.0, 1.0, 0.0);
		transform.m34 = 1.0f / 2500.0f;
		
		flipAnimationLayer.transform = transform;
		transform.m34 = 1.0f / 1500.0f;
		
		
		currentAngle = startFlipAngle = 0;
		endFlipAngle = -M_PI;
	} else {
		
		backLayer.contentsGravity = kCAGravityLeft;
		backLayer.contents = (id) [newImage CGImage];
		
		frontLayer.contents = (id) [currentImage CGImage];
		frontLayer.contentsGravity = kCAGravityRight;
		
		CATransform3D transform = CATransform3DMakeRotation(-M_PI / 1.1 , 0.0, 1.0, 0.0);
		transform.m34 = -1.0f / 2500.0f;
		
		flipAnimationLayer.transform = transform;
		transform.m34 = -1.0f / 1500.0f;
		
		
				
		currentAngle = startFlipAngle = -M_PI ;
		endFlipAngle = 0;
	}
	[newpool release];
   
}


- (void) cleanupFlip {
	[backgroundAnimationLayer removeFromSuperlayer];
	[flipAnimationLayer removeFromSuperlayer];

	backgroundAnimationLayer = Nil;
	flipAnimationLayer = Nil;
	
	animating = NO;
	
	if (setNewViewOnCompletion) 
    {
		[self.currentView removeFromSuperview];
		self.currentView = self.thenewView;
        [self.thenewView release];
	} 
    else 
    {
		[self.thenewView removeFromSuperview];
        [self.thenewView release];
	}
	
	setNewViewOnCompletion = NO;
	[self.currentView setHidden:FALSE];
	self.currentView.alpha = 1;
}





- (void) setFlipProgress:(float) progress setDelegate:(BOOL) setDelegate animate:(BOOL) animate {
	
	float newAngle = startFlipAngle + progress * (endFlipAngle - startFlipAngle);
	float duration = animate ? 0.5 * fabs((newAngle - currentAngle) / (endFlipAngle - startFlipAngle)) : 0;
	
	currentAngle = newAngle;
	
	CATransform3D endTransform = CATransform3DIdentity;
	endTransform.m34 = 1.0f / 2500.0f;
	endTransform = CATransform3DRotate(endTransform, newAngle, 0.0, 1.0, 0.0);	
	
	[flipAnimationLayer removeAllAnimations];
	
    NSValue *v1 = nil;
    NSValue *v2 = nil;
    v1 = [NSValue valueWithCATransform3D:flipAnimationLayer.transform];
    v2 = [NSValue valueWithCATransform3D:endTransform];
    CABasicAnimation *rd = [CABasicAnimation animationWithKeyPath:@"transform"];
    [rd setFromValue:v1];
    [rd setToValue:v2];
    [rd setDuration:duration];
    [rd setFillMode:kCAFillModeForwards];
    rd.removedOnCompletion = NO;
    rd.delegate = self;
    [flipAnimationLayer addAnimation:rd forKey:@"FLIP1"];
    [self performSelector:@selector(cleanupFlip) withObject:Nil afterDelay:duration];

}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    self.hidden = YES;
    [self.dataSource flipEnd];
}

- (void) flipPage 
{
	[self setFlipProgress:1.0 setDelegate:YES animate:YES];
}



#pragma mark -
#pragma mark Properties

@synthesize currentView;







@synthesize currentPage;


- (BOOL) doSetCurrentPage:(NSInteger) value {
	if (value == currentPage) {
		return FALSE;
	}
	flipDirection = value < currentPage ? AFKPageFlipperDirectionRight : AFKPageFlipperDirectionLeft;
	currentPage = value;
	self.thenewView = [self.dataSource viewForPage:value inFlipper:self];
	[self addSubview:self.thenewView];
	
	return TRUE;
}	

- (void) setCurrentPage:(NSInteger) value {
	if (![self doSetCurrentPage:value]) {
		return;
	}
	setNewViewOnCompletion = YES;
	animating = NO;
	[self.thenewView setHidden:FALSE];	
    [self.currentView removeFromSuperview];
    self.currentView = self.thenewView;
    [self.thenewView release];

	
} 


- (void) setCurrentPage:(NSInteger) value animated:(BOOL) animated {
	
	
	pageDifference = fabs(value - currentPage);
	
	if (![self doSetCurrentPage:value]) {
		return;
	}
	
	setNewViewOnCompletion = YES;
	animating = YES;
	
	if (animated) 
    {
		[self setDisabled:TRUE];
		[self initFlip];
		[self performSelector:@selector(flipPage) withObject:Nil afterDelay:0.000];
	} 
    
	
}


@synthesize dataSource;


- (void) setDataSource:(NSObject <AFKPageFlipperDataSource>*) value {
	
//	if (dataSource) {
//		[dataSource release];
//	}
	
//	dataSource = [value retain];
    dataSource = value;
	numberOfPages = [dataSource numberOfPagesForPageFlipper:self];
	self.currentPage = 1;
}


@synthesize disabled;




- (void) setFrame:(CGRect) value {
	super.frame = value;
	
	numberOfPages = [dataSource numberOfPagesForPageFlipper:self];
	
	if (self.currentPage > numberOfPages) {
		self.currentPage = numberOfPages;
	}
	
}


#pragma mark -
#pragma mark Initialization and memory management


+ (Class) layerClass {
	return [CATransformLayer class];
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) 
    {
			
		animating = FALSE;
    }
    return self;
}

-(void)  begin
{
    
    animating = FALSE;
}


- (void)dealloc {
	self.dataSource = Nil;
	self.currentView = Nil;
	self.thenewView = Nil;
    [super dealloc];
}


@end
