//
//  ScorllImageComponent.m
//  Core
//
//  Created by MoueeSoft on 12-12-5.
//
//

#import "ScrollImageComponent.h"

@interface ScrollImageComponent ()
{
    UIScrollView *_scrollView;
}

@end

@implementation ScrollImageComponent

- (id)initWithEntity:(HLContainerEntity*)entity
{
    self = [super init];
    if (self)
    {
        entity.isPlayAudioOrVideoAtBegining = YES;
        self.scrollEntity = (ScrollImageEntity*)entity;
        self.rootPath = entity.rootPath;
        
        _scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue])] autorelease];
        _scrollView.backgroundColor = [UIColor clearColor];
        
        
        self.uicomponent = _scrollView;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
    }
    return self;
}

- (void)play
{
    for (int i = 0; i < self.scrollEntity.images.count; i++)
    {
        NSString *path = [self.rootPath stringByAppendingPathComponent:[self.scrollEntity.images objectAtIndex:i]];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        UIImageView *imv = [[[UIImageView alloc] init] autorelease];
        imv.frame = CGRectMake(0, i * [self.scrollEntity itemHeight], self.scrollEntity.itemWidth ,self.scrollEntity.itemHeight);
        imv.image = image;
        [_scrollView addSubview:imv];
    }
    
    _scrollView.contentSize = CGSizeMake([self.scrollEntity.width floatValue], [self.scrollEntity itemHeight] * self.scrollEntity.images.count);
}

- (void)dealloc
{
    self.rootPath = nil;
    self.scrollEntity = nil;
    self.uicomponent = nil;
    [super dealloc];
}

@end
