//
//  ImageSliderComponent.m
//  Core
//
//  Created by mac on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageSliderComponent.h"
#import "HLContainer.h"
#import "ImageSliderEntity.h"


@interface ImageSliderComponent()
{
    NSMutableArray *imageDownloads;
    NSMutableArray *imageViews;
    NSMutableSet *OwnIndexs;
    NSInteger curIndex;
    UIScrollView *sView;
    float lastOffset;
    HLPageControl *curPageControl;
}

@property (nonatomic, retain) ImageSliderEntity *sliderEntity;
@property (nonatomic, retain) NSString *entityPath;
@property (nonatomic, retain) NSString *pageID;
@property (nonatomic, retain) NSMutableArray *imageArray;
 

@end

@implementation ImageSliderComponent

@synthesize isVertical;
@synthesize sliderEntity;
@synthesize entityPath;
@synthesize pageID;
@synthesize imageArray;
@synthesize ime;

int currentIndex = 0;

- (UIImage *)scaledImage:(UIImage*)image
{
    if (!image)
    {
        return nil;
    }
    UIScreen *mainScreen = [UIScreen mainScreen];
    UIImage *scaledImg = nil;
    CGSize size = CGSizeMake([self.sliderEntity.width floatValue], [self.sliderEntity.height floatValue]);
    size.width *= mainScreen.scale;
    size.height *= mainScreen.scale;
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    scaledImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImg;
}

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self != nil)
    {
        self.ime = (ImageSliderEntity*)entity;
        
        float width  = [ime.width floatValue];
        float height = [ime.height floatValue];
        if (self.ime.isShowPageControl)
        {
            if (ime.isVertical)
            {
                width -= 60;
            }
            else
            {
                height -= 60;
            }
        }
        NSMutableArray *images = ime.images;
        self.pageID = entity.entityid;
        self.sliderEntity = (ImageSliderEntity*)entity;
        self.entityPath = [entity.rootPath stringByAppendingPathComponent:entity.dataid];
        self.isVertical = ((ImageSliderEntity*)entity).isVertical;
        self.imageArray = ((ImageSliderEntity*)entity).images;
        imageCount = [((ImageSliderEntity*)entity).images count];
        imageWidth = width;
        imageHeight = height;
        imageDownloads = [[NSMutableArray alloc] initWithCapacity:4];
        OwnIndexs = [[NSMutableSet alloc] initWithCapacity:4];
        imageViews = [[NSMutableArray alloc] initWithCapacity:imageCount];
        
        curScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)] autorelease];
        curScrollView.bouncesZoom   = NO;
        curScrollView.bounces = NO;
        curScrollView.pagingEnabled = YES;
        curScrollView.showsVerticalScrollIndicator = NO;
        curScrollView.showsHorizontalScrollIndicator = NO;
        
        NSString *path = [entity.rootPath stringByAppendingPathComponent:entity.dataid];
        
        
        if (ime.isVertical == YES)
        {
            curScrollView.contentSize   = CGSizeMake(width, height*[images count]);
        }
        else
        {
            curScrollView.contentSize   = CGSizeMake(width*[images count], height);
        }
        
        for (int i = 0; i < [images count]; i++)
        {
            NSString *imagePath = [images objectAtIndex:i];
            imagePath = [path stringByAppendingPathComponent:imagePath];
            UIImage *image   = nil; //[UIImage imageWithContentsOfFile:imagePath];
            if (i < 2)
            {
                UIImage* tmpImg = [UIImage imageWithContentsOfFile:imagePath];
                image = [self scaledImage:tmpImg];
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:image forState:UIControlStateNormal];
            button.adjustsImageWhenHighlighted = NO;
            [button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            if (ime.isVertical)
            {
                button.frame        = CGRectMake(0, height * i, width, height);
            }
            else
            {
                button.frame        = CGRectMake(width*i, 0, width, height);
            }
            [curScrollView addSubview:button];
            [imageViews addObject:button];
        }
        
        curScrollView.delegate = self;
        sView = curScrollView;
        
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)] autorelease];
        [view addSubview:curScrollView];
                
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouch)];
        [self.uicomponent addGestureRecognizer:tgr];
        [tgr release];
        lastOffset = 0;
        
        if (self.ime.isShowPageControl)
        {
            textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, height + 6, width, 15)] autorelease];
            textLabel.textAlignment = NSTextAlignmentCenter;
            
            [view addSubview:textLabel];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.font = [UIFont systemFontOfSize:15];
            if (ime.isVertical == YES)
            {
                view.frame = CGRectMake(0, 0, width + 80, height);
                curPageControl = [[[HLPageControl alloc] initWithFrame:CGRectMake(width + 26, 0, 24, height) pageCount:images.count isHorizon:NO] autorelease];
                textLabel.numberOfLines = 0;
                textLabel.lineBreakMode = NSLineBreakByCharWrapping;
            }
            else
            {
                view.frame = CGRectMake(0, 0, width, height + 80);
                curPageControl = [[[HLPageControl alloc] initWithFrame:CGRectMake(0, height + 26, width, 24) pageCount:images.count isHorizon:YES] autorelease];
                textLabel.numberOfLines = 1;
                textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            }
            curPageControl.deleage = self;
            [curPageControl setCurIndex:0];
            [view addSubview:curPageControl];
        }
        self.uicomponent = view;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
    }
    return self;
}

- (void)pageControlValueChange:(int)index
{
    textLabel.text = [self.ime.imageDesDic objectForKey:[self.ime.images objectAtIndex:index]];
    if (ime.isVertical == YES)
    {
        if (textLabel.text.length > 17)
        {
            NSString *str = [NSString stringWithString:[textLabel.text substringToIndex:15]];
            textLabel.text = [NSString stringWithFormat:@"%@...",str];
        }
        [curScrollView setContentOffset:CGPointMake(0, curScrollView.frame.size.height * index) animated:YES];
        CGSize size = [textLabel.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(15, curScrollView.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
        textLabel.frame = CGRectMake(curScrollView.frame.size.width + 6, (curScrollView.frame.size.height - size.height) / 2.0, 15, size.height);
    }
    else
    {
        [curScrollView setContentOffset:CGPointMake(curScrollView.frame.size.width * index, 0) animated:YES];
    }
    [self arrangeImages:index];
    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CHANGE_COMPLETE"] == YES)
        {
            if (index == [behavior.behaviorValue intValue])
            {
                if ([self.container runBehaviorWithEntity:behavior])
                {
                    return;
                }
            }
        }
    }
}

- (void)setPageImage:(NSInteger)index
{
    if (index >= 0 && index < imageArray.count && index < imageViews.count)
    {
        UIButton *button = [imageViews objectAtIndex:index];
        if (!button.currentImage)
        {
            NSString *imagePath = [imageArray objectAtIndex:index];
            imagePath = [entityPath stringByAppendingPathComponent:imagePath];
            UIImage *image  = [UIImage imageWithContentsOfFile:imagePath];
            UIImage *scaleImg = [self scaledImage:image];
            [button setImage:scaleImg forState:UIControlStateNormal];
        }
    }
}

- (void)arrangeImages:(NSInteger)scrollIndex
{
    if (self.sliderEntity.fromUrl)
    {
        return;
    }
    NSInteger index = scrollIndex - 2;
    if (index >= 0 && index < imageArray.count && index < imageViews.count)
    {
        UIButton *button = [imageViews objectAtIndex:index];
        [button setImage:nil forState:UIControlStateNormal];
    }
    index = scrollIndex + 2;
    if (index >= 0 && index < imageArray.count && index < imageViews.count)
    {
        UIButton *button = [imageViews objectAtIndex:index];
        [button setImage:nil forState:UIControlStateNormal];
    }

    index = scrollIndex;
    [self setPageImage:index];
    
    index = scrollIndex - 1;
    [self setPageImage:index];
    
    index = scrollIndex + 1;
    [self setPageImage:index];
}

//-(void) onTouch
//{
//    [super onTouch];
//    int index = sView.contentOffset.x / imageWidth + 0.1f;
//    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
//    {
//        BehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
//        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CLICK"] == YES)
//        {
//            if (index == [behavior.behaviorValue intValue])
//            {
//                if ([self.container runBehaviorWithEntity:behavior])
//                {
//                    return;
//                }
//            }
//        }
//    }
//}

- (void)itemClicked:(UIButton *)sender
{
    int index = sender.tag;
    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CLICK"] == YES)
        {
            if (index == [behavior.behaviorValue intValue])
            {
                if ([self.container runBehaviorWithEntity:behavior])
                {
                    return;
                }
            }
        }
    }
}

#pragma UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / imageWidth + 0.1f;
    if (self.isVertical)
    {
        index = scrollView.contentOffset.y / imageHeight + 0.1;
    }
    [curPageControl setCurIndex:index];
    currentIndex = index;
    [self arrangeImages:index];
    curIndex = index - 1;
    if (curIndex < 0) 
    {
        curIndex = imageCount - 1;
    }
    if (isVertical == YES)
    {
        lastOffset = sView.contentOffset.y;
    }
    else
    {
        lastOffset = sView.contentOffset.x;
    }
    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CHANGE_COMPLETE"] == YES)
        {
            if (index == [behavior.behaviorValue intValue])
            {
                if ([self.container runBehaviorWithEntity:behavior])
                {
                    return;
                }
            }
        }
    }
    scrollView.scrollEnabled = YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    scrollView.scrollEnabled = NO;
    int index  = 0;
    if (isVertical == YES)
    {
        index = sView.contentOffset.y / imageHeight + 0.1f;
        if (sView.contentOffset.y > lastOffset)
        {
            index = index + 1;
        }
    }
    else
    {
        index = sView.contentOffset.x / imageWidth + 0.1f;
        if (sView.contentOffset.x > lastOffset)
        {
            index = index + 1;
        }
    }
    if (!(index == 0 && currentIndex == 0))//adward 2.17 第一页往前切换不触发事件
    {
        for (int i = 0; i < [self.container.entity.behaviors count]; i++)
        {
            HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
            if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CHANGE_BEGIN"] == YES)
            {
                if (index == [behavior.behaviorValue intValue])
                {
                    if ([self.container runBehaviorWithEntity:behavior])
                    {
                        return;
                    }
                }
            }
        }
    }
}

-(void) beginView
{
    [super beginView];
}

-(void) change:(int)index
{
    if (ime.isVertical == YES)
    {
        [sView setContentOffset:CGPointMake(0, sView.frame.size.height * index) animated:YES];
    }
    else
    {
        [sView setContentOffset:CGPointMake(sView.frame.size.width * index, 0) animated:YES];
    }
    currentIndex = index;
    [self arrangeImages:index];
    [curPageControl setCurIndex:index];//图片滑动变换时pageControl也跟着变换 adward 13-12-25
    for (int i = 0; i < [self.container.entity.behaviors count]; i++)
    {
        HLBehaviorEntity *behavior = [self.container.entity.behaviors objectAtIndex:i];
        if ([behavior.eventName isEqualToString:@"BEHAVIOR_ON_TEMPLATE_ITEM_CHANGE_COMPLETE"] == YES)
        {
            if (index == [behavior.behaviorValue intValue])
            {
                if ([self.container runBehaviorWithEntity:behavior])
                {
                    return;
                }
            }
        }
    }
}

- (void)dealloc 
{
    [sView removeFromSuperview];
    [self.imageArray release];
    [self.pageID release];
    [OwnIndexs removeAllObjects];
    [OwnIndexs release];
    [self.sliderEntity release];
    [self.entityPath release];
    [imageViews removeAllObjects];
    [imageViews release];
    [imageDownloads removeAllObjects];
    [imageDownloads release];
    [self.uicomponent removeFromSuperview];     //陈星宇，11.4
	[self.uicomponent release];
    [super dealloc];
}

@end
