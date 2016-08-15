//
//  CarouselComponent.m
//  Core
//
//  Created by mac on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CarouselComponent.h"
#import "HLContainer.h"
#import "CarouselEntity.h"

@interface CarouselComponent ()
{
    NSInteger itemCount;
    NSInteger timerInterval;
    CGFloat playDuration;
    NSMutableArray *imageViews;
}

@end

@implementation CarouselComponent
@synthesize imgs;

-(void)loadImage:(id)userObj
{
    int count = [self.imgs count];
    int index = ((UIImageView *)userObj).tag;
    if (index < 0 || index >= count) 
    {
        return;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:[self.imgs objectAtIndex:index]];
    ((UIImageView *)userObj).image = image;
    [userObj release];
}

-(void)loadImages:(NSMutableArray *)imagePaths
{
    [imageViews retain];
    [imagePaths retain];
    for (int i = 0; i < imagePaths.count; ++i) 
    {
        NSString *path = [imagePaths objectAtIndex:i];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        UIImageView *imv = [imageViews objectAtIndex:i];
        imv.contentMode = UIViewContentModeScaleAspectFit;
        imv.image = image;
    }
    [imagePaths release];
    [imageViews release];
    
}

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self != nil)
    {
        isVertical = NO;
        itemCount = [((CarouselEntity*)entity).images count];
        self.imgs = [[NSMutableArray alloc] initWithCapacity:10];
        [self.imgs release];
        imageViews = [[NSMutableArray alloc] initWithCapacity:4];
        for (int i = 0; i < [((CarouselEntity*)entity).images count]; i++)
        {
            NSString *imagePath = [((CarouselEntity*)entity).images objectAtIndex:i];
            imagePath = [[entity.rootPath stringByAppendingPathComponent:entity.dataid] stringByAppendingPathComponent:imagePath];
            [self.imgs addObject:imagePath];
            
            UIImageView *imv = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath]];     //1.13，原来这里写的是个nil，老子服了
            [imageViews addObject:imv];
            [imv release];
        }
        [NSThread detachNewThreadSelector:@selector(loadImages:) toTarget:self withObject:self.imgs];
//        [self loadImages:self.imgs];
        
        iCarousel *cl = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue])];
        cl.type = iCarouselTypeRotary;
        cl.clipsToBounds = YES;
        self.uicomponent = cl;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
        [cl release];

    }
    return self;
}

-(void) beginView
{
    [super beginView];
    [self play];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if([self.container.entity.rotation intValue] == 90)
    {
        if ([self.imgs count]  % 2 == 0) 
        {
            return [self.imgs count]/2;
        }
    }
    return [self.imgs count];
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    //this also affects the appearance of circular-type carousels
    int ret = [self.imgs count];
    return ret;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	if (view == nil)
	{
        if (index < imageViews.count) 
        {
            view = [imageViews objectAtIndex:index];
        }
        if (((CarouselEntity*)self.container.entity).cheight == 0 || ((CarouselEntity*)self.container.entity).cwidth == 0)
        {
            ((CarouselEntity*)self.container.entity).cwidth = [self.container.entity.width floatValue];
            ((CarouselEntity*)self.container.entity).cheight = [self.container.entity.height floatValue];
        }

        UIImageView *img = [imageViews objectAtIndex:0];
        if (img.image.size.height > [self.container.entity.height floatValue])
        {
            view.frame = CGRectMake(0, 0,img.image.size.width / img.image.size.height * [self.container.entity.height floatValue], [self.container.entity.height floatValue]);
        }
        
	}
	return view;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    UIImageView *img = [imageViews objectAtIndex:0];
    return img.image.size.width / img.image.size.height * [self.container.entity.height floatValue];// -300 modified by Adward 13-11-143D画廊显示效果与软件中不一致，软件中5个，ios之前为3个
}

- (CGFloat)carousel:(iCarousel *)carousel itemAlphaForOffset:(CGFloat)offset
{
	//set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _carousel.itemWidth);
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if([self.container.entity.rotation intValue] == 90)
    {
        for (int i = 0; i <  [self.imgs count]/2; i++) 
        {
            UIImageView *cellView  = (UIImageView*)[carousel itemViewAtIndex:i];
            cellView.image = [UIImage imageWithContentsOfFile:[self.imgs objectAtIndex:i]];
        }
        UIImageView *cellView  = (UIImageView*)[carousel itemViewAtIndex:index];
        cellView.image = [UIImage imageWithContentsOfFile:[self.imgs objectAtIndex:[self.imgs count]/2+index]];
    }
    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        if (index == [behavior.behaviorValue integerValue] && [behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CLICK"])
        {
            if ([self.container runBehaviorWithEntity:behavior])
            {
                return;
            }
        }
    }
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    if (((iCarousel*)self.uicomponent).type == iCarouselTypeRotary) 
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    
}

-(void) play
{
    ((iCarousel*)self.uicomponent).dataSource = self;
    ((iCarousel*)self.uicomponent).delegate   = self;
//    [((iCarousel*)self.uicomponent) reloadData];
    if (timerInterval > 0 && itemCount > 1) 
    {
        CGFloat width;
        if (isVertical) 
        {
            width = ((CarouselEntity*)self.container.entity).cheight/((CarouselEntity*)self.container.entity).cwidth*[self.container.entity.width floatValue];
            width = width * itemCount - [self.container.entity.height floatValue];
        }
        else 
        {
            width = ((CarouselEntity*)self.container.entity).cwidth/((CarouselEntity*)self.container.entity).cheight*[self.container.entity.height floatValue];
            width = width * itemCount - [self.container.entity.width floatValue];
        }
        playDuration = width * timerInterval / 1000;
        [((iCarousel*)self.uicomponent) scrollToItemAtIndex:itemCount-1 duration:playDuration];
    }
}

- (void)dealloc 
{
    [imageViews removeAllObjects];
    [imageViews dealloc];
    [self.imgs removeAllObjects];
    ((iCarousel*)self.uicomponent).delegate = nil;
    ((iCarousel*)self.uicomponent).dataSource = nil;
    [((iCarousel*)self.uicomponent) reloadData];
    [self.uicomponent removeFromSuperview];         //陈星宇，11.4
	[self.uicomponent release];
    [self.imgs release];
    [super dealloc];
}
@end
