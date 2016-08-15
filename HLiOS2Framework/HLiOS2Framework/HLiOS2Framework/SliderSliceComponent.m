//
//  SliderSliceComponent.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-7-5.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "SliderSliceComponent.h"

@implementation SliderSliceComponent

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        leftArray = [[NSMutableArray alloc] init];
        rightArray = [[NSMutableArray alloc] init];
        self.sliceEntity = (SliceEntity *)entity;
        count = self.sliceEntity.imagePathArr.count;
        
        width = [entity.width intValue];
        height = [entity.height intValue];
        
        scrollBgView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)] autorelease];
        
        UITapGestureRecognizer *leftTapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapGesture)] autorelease];
        UITapGestureRecognizer *rightTapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapGesture)] autorelease];
        
        leftScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width / 2, height)] autorelease];
        [leftScrollView addGestureRecognizer:leftTapGesture];
        leftScrollView.pagingEnabled = YES;
        leftScrollView.showsVerticalScrollIndicator = NO;
        leftScrollView.showsHorizontalScrollIndicator = NO;
        leftScrollView.delegate = self;
        
        rightScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(width / 2, 0, width / 2, height)] autorelease];
        [rightScrollView addGestureRecognizer:rightTapGesture];
        rightScrollView.pagingEnabled = YES;
        rightScrollView.showsVerticalScrollIndicator = NO;
        rightScrollView.showsHorizontalScrollIndicator = NO;
        rightScrollView.delegate = self;
        
        
        leftScrollView.contentSize = CGSizeMake(leftScrollView.frame.size.width, leftScrollView.frame.size.height * (count + 2));
        rightScrollView.contentSize = leftScrollView.contentSize;
        
        leftScrollView.contentOffset = CGPointMake(0, height);
        rightScrollView.contentOffset = CGPointMake(0, height * count);
        
        [scrollBgView addSubview:leftScrollView];
        [scrollBgView addSubview:rightScrollView];
                
        for (int j = 0; j < 2; j++)
        {
            for (int i = 0; i < count + 2; i++)
            {

                UIImageView *imgView = [[[UIImageView alloc] initWithImage:nil] autorelease];
                
                if (j == 0)
                {
                    imgView.frame = CGRectMake(0, i * height, width, height);
                    [leftScrollView addSubview:imgView];
                    [leftArray addObject:imgView];
                }
                else
                {
                    imgView.frame = CGRectMake(-width / 2, i * height, width, height);
                    [rightScrollView addSubview:imgView];
                    [rightArray addObject:imgView];
                }
            }
        }
        lastIndex = -1;
        [self loadImgWithIndex:1];
        self.uicomponent = scrollBgView;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
    }
    return self;
}

- (void)loadImgWithIndex:(int)index
{
    if (lastIndex == index) {
        return;
    }
    lastIndex = index;
    if (index == 0 || index == count + 1) {
        return;
    }
    NSMutableArray *leftShowArry = [NSMutableArray array];
    NSString *path = [self.sliceEntity.rootPath stringByAppendingPathComponent:self.sliceEntity.dataid];
    int leftIndex = index;
    for (int i = index - 1; i <= index + 1; i++)
    {
        if (i == 0)
        {
            leftIndex = count - 1;
        }
        else if(i == count + 1)
        {
            leftIndex = 0;
        }
        else
        {
            leftIndex = i - 1;
        }
        [leftShowArry addObject:[NSNumber numberWithInt:i]];
        UIImageView *imgLeft = [leftArray objectAtIndex:i];
        if (!imgLeft.image)
        {
            NSString *imagePath = [self.sliceEntity.imagePathArr objectAtIndex:leftIndex];
            imagePath = [path stringByAppendingPathComponent:imagePath];
            [imgLeft setImage:[UIImage imageWithContentsOfFile:imagePath]];
        }
    }
    NSMutableArray *rightShowArry = [NSMutableArray array];
    int rightIndex = index;
    for (int i = (count + 1 - index) - 1; i <= (count + 1 - index) + 1; i++)
    {
        if (i > 0 && i < count + 1)
        {
            rightIndex = count - 1 - (i - 1);
        }
        else if(i == count + 1)
        {
            rightIndex = count - 1;
        }
        else
        {
            rightIndex = 0;
        }
        [rightShowArry addObject:[NSNumber numberWithInt:i]];
        UIImageView *imgRight = [rightArray objectAtIndex:i];
        if (!imgRight.image)
        {
            NSString *imagePath = [self.sliceEntity.imagePathArr objectAtIndex:rightIndex];
            imagePath = [path stringByAppendingPathComponent:imagePath];
            [imgRight setImage:[UIImage imageWithContentsOfFile:imagePath]];
        }
    }
    for (int i = 0; i < leftArray.count; i++)
    {
        if (![leftShowArry containsObject:[NSNumber numberWithInt:i]])
        {
            UIImageView *imgLeft = [leftArray objectAtIndex:i];
            [imgLeft setImage:nil];
        }
        if (![rightShowArry containsObject:[NSNumber numberWithInt:i]])
        {
            UIImageView *imgRight = [rightArray objectAtIndex:i];
            [imgRight setImage:nil];
        }
        
    }
}

- (void)leftTapGesture
{
    if (!isTouch)
    {
        isTouch = YES;
        rightScrollView.scrollEnabled = NO;
    }
}

- (void)rightTapGesture
{
    if (!isTouch)
    {
        isTouch = YES;
        leftScrollView.scrollEnabled = NO;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!isTouch)
    {
        isTouch = YES;
        if (scrollView == leftScrollView) {
            rightScrollView.scrollEnabled = NO;
        }
        else
        {
            leftScrollView.scrollEnabled = NO;
        }
    }
    if (scrollView.contentOffset.y <= 0 || scrollView.contentOffset.y >= (count + 1) * height)
    {
        leftScrollView.userInteractionEnabled = NO;
        rightScrollView.userInteractionEnabled = NO;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    leftScrollView.userInteractionEnabled = NO;
    rightScrollView.userInteractionEnabled = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isTouch = NO;
    
    int index = leftScrollView.contentOffset.y / leftScrollView.frame.size.height;
    [self loadImgWithIndex:index];
    
    leftScrollView.userInteractionEnabled = YES;
    rightScrollView.userInteractionEnabled = YES;
    leftScrollView.scrollEnabled = YES;
    rightScrollView.scrollEnabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == 0)
    {
        scrollView.contentOffset = CGPointMake(0, count * height);
        int index = leftScrollView.contentOffset.y / leftScrollView.frame.size.height;
        [self loadImgWithIndex:index];
    }
    else if (scrollView.contentOffset.y == (count + 1) * height)
    {
        scrollView.contentOffset = CGPointMake(0, height);
        int index = leftScrollView.contentOffset.y / leftScrollView.frame.size.height;
        [self loadImgWithIndex:index];
    }
    
    if (scrollView == leftScrollView)
    {
        rightScrollView.contentOffset = CGPointMake(0, (count + 1) * height - leftScrollView.contentOffset.y);
    }
    else
    {
        leftScrollView.contentOffset = CGPointMake(0, (count + 1) * height - rightScrollView.contentOffset.y);
    }
}

- (void)dealloc
{
    [rightArray release];
    [leftArray release];
    [self.sliceEntity release];
    [self.uicomponent removeFromSuperview];     //陈星宇，11.4
	[self.uicomponent release];
    [super dealloc];
}

@end
