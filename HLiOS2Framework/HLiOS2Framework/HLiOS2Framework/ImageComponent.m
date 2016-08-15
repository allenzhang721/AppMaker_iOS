//
//  ImageComponent.m
//  MoueeReleaseVertical
//
//  Created by user on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageComponent.h"
#import "HLContainer.h"
#import "HLImage.h"
#import "HLScrollView.h"
#import "AnimationDecoder.h"

#define kMaxScale 2.5
#define kMinScale 1

@implementation ImageComponent

@synthesize imv;
@synthesize im;
@synthesize imagePath;
@synthesize isbyUserScale;
@synthesize linkSizeRate;

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
	if (self != nil)
	{
        self.im                    = (ImageEntity*)entity;
        float width                = [entity.width floatValue];
        float height               = [entity.height floatValue];
        self.imagePath             = [entity.rootPath stringByAppendingPathComponent:entity.dataid];
        HLImage *imageView         = nil;
        UIImage *image             = [UIImage imageWithContentsOfFile:self.imagePath];
        imageView                  = [[HLImage alloc] initWithImage:image];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;        //陈星宇，10.24，图片3.5和4.0的适配

        imageView.com              = self;
        imageView.isEnableMoveable = ((ImageEntity*)entity).isStroyTelling;
        imageView.isMoveScale      = ((ImageEntity*)entity).isMoveScale;
        HLScrollView *sc           = [[HLScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        sc.isMoveScale             = ((ImageEntity*)entity).isMoveScale;
        if (((ImageEntity*)entity).isZoomByUser == NO)
        {
            if (im.type != nil)
            {
//                float sx = [AnimationDecoder getSX];
//                float sy = [AnimationDecoder getSY];
                if ([im.type isEqualToString:@"text_hor_image"] == YES)//文字横向 只能往下滑
                {
                    sc.com                    = self;
                    sc.delegate               = self;
                    sc.alwaysBounceHorizontal = NO;
                    sc.alwaysBounceVertical   = YES;
                    [sc addSubview:imageView];
                    self.uicomponent          = sc;
                    self.imv                  = imageView;
                    CGSize uiComponentsize    = self.uicomponent.frame.size;//陈星宇，11.27
                    CGSize imgSize            = self.imv.image.size;
                    float rate                = 0;
                    rate                      = uiComponentsize.width / imgSize.width;
                    float textHeight          = 0;
                    textHeight                = imgSize.height * rate;
                    self.imv.frame            = CGRectMake(0, 0, uiComponentsize.width, textHeight);
                    sc.contentSize            = CGSizeMake(sc.frame.size.width, imageView.frame.size.height);
//                    [sc release];
                }
                else
                {
                    if ([im.type isEqualToString:@"text_ver_image"] == YES)
                    {
                        sc.delegate               = self;
                        sc.com                    = self;
                        sc.alwaysBounceHorizontal = YES;
                        sc.alwaysBounceVertical   = NO;
                        [sc addSubview:imageView];
                        self.uicomponent          = sc;
                        self.imv                  = imageView;
                        CGSize uiComponentsize    = self.uicomponent.frame.size;//陈星宇，11.27
                        CGSize imgSize            = self.imv.image.size;
                        float rate                = 0;
                        rate                      = uiComponentsize.height / imgSize.height;
                        float textWidth           = 0;
                        textWidth                 = imgSize.width * rate;
                        self.imv.frame            = CGRectMake(0, 0, textWidth, uiComponentsize.height);
                        sc.contentSize            = CGSizeMake(imageView.frame.size.width, sc.frame.size.height);
                        sc.contentOffset          = CGPointMake(imageView.frame.size.width - width, 0);
//                        [sc release];
                    }
                    else
                    {
                        self.uicomponent = imageView;
                        self.imv         = imageView;
                    }
                }
            }
            
            
            else
            {
                self.uicomponent = imageView;
                self.imv         = imageView;
            }
        }
        else    //可以缩放
        {
            sc.isEnableMoveable = ((ImageEntity*)entity).isStroyTelling;     //陈星宇，11.6     isMoveable -> isStroytelling
            if (self.im.isZoomInner)    //内缩    //陈星宇，11.4       if (!self.im.isZoomInner)
            {
                sc.maximumZoomScale= 4.0;
            }
            else
            {
                [sc addGestureRecognizer:[[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinGestureRecognizer:)] autorelease]];
                //外缩   //外部缩放，走这个方法  //默认的外缩
            }
            sc.com           = self;
            sc.delegate      = self;
            [sc addSubview:imageView];
            self.imv         = imageView;
            self.imv.frame   = CGRectMake(0, 0, (int)width, (int)height);
            self.uicomponent = sc;
//            [sc release];
        }
        if (entity.isHideAtBegining)
        {
            [imageView setImage:nil];
        }
        self.uicomponentOriginFrame = self.uicomponent.frame;       //陈星宇，11.19
//        [sc release];         //陈星宇，11.19，内存
        
        [imageView release];

    }
    return self;
}

- (void)pinGestureRecognizer:(UIGestureRecognizer *)gesture
{
    UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)gesture;
    if([pinch state] == UIGestureRecognizerStateBegan)
    {
        lastScale = 1.0;
    }
    CGFloat scale                      = 1.0 - (lastScale - [pinch scale]);
    float curScale                     = [[self.uicomponent.layer valueForKeyPath: @"transform.scale"] floatValue];
    scale                              = MIN(scale, kMaxScale / curScale);
    scale                              = MAX(scale, kMinScale / curScale);
    CGAffineTransform currentTransform = self.uicomponent.transform;
    CGAffineTransform newTransform     = CGAffineTransformScale(currentTransform, scale, scale);
    [self.uicomponent setTransform:newTransform];
    [self.container runLinkageContainerScale:scale rate:1.0];//Added by Adward 13-10-25 联动图片缩放 12.25 modified
    lastScale                          = [pinch scale];
    
    float afterScale  = [[self.uicomponent.layer valueForKeyPath: @"transform.scale"] floatValue];//陈星宇，11.19，缩放判断
    float OriginScale = 1.0;
    if (afterScale - OriginScale != 0)
    {
        self.isbyUserScale = NO;//adward 2.20 图片不设置随手指移动不能移动
    }
    else
    {
        self.isbyUserScale = NO;
    }
}

-(void) setImageSize
{
    self.imv.frame = CGRectMake(0, 0, self.uicomponent.frame.size.width, self.uicomponent.frame.size.height);
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"%f %@ %@", scrollView.layer.contentsScale,NSStringFromCGSize(scrollView.contentSize), NSStringFromCGRect(scrollView.frame));
//    scrollView.frame = CGRectMake([self.im.x intValue] - (scrollView.contentSize.width - [self.im.width intValue]) / 2, [self.im.y intValue] - (scrollView.contentSize.height - [self.im.height intValue]) / 2, scrollView.contentSize.width, scrollView.contentSize.height);
//
//}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imv;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if (scale  < 1.05)
    {
        [scrollView setZoomScale:1 animated:YES];
        scrollView.scrollEnabled = NO;
        ((HLScrollView *)scrollView).isEnableMoveable = YES;        //Mr.chen, reason, 14.03.31
    }
    else
    {
        self.linkSizeRate = scale;
//        [self.container runLinkageContainerScrollView];//控件内缩放暂时不做关联13-11-28
        scrollView.scrollEnabled = YES;
        ((HLScrollView *)scrollView).isEnableMoveable = NO;        //Mr.chen, reason, 14.03.31
    }
}

- (void)show
{
    if (self.imv.image)
    {
        return;
    }
    UIImage *image        = [UIImage imageWithContentsOfFile:self.imagePath];
//    self.imv.image = [MoueeImage scaledImage:image width:[self.container.entity.width floatValue] height:[self.container.entity.height floatValue]];
    self.imv.image = image;
}

//
- (void)hide
{
    self.imv.image = nil;
}

- (void)dealloc
{
	//((UIImageView*)self.uicomponent).image = nil;
    [self.imv removeFromSuperview];                         //陈星宇，11.4，
    [self.im release];
    [self.imagePath release];
    [self.uicomponent removeFromSuperview];                 //陈星宇，11.4，内存不释放的原因
	[self.uicomponent release];
    
    [super dealloc];
}


@end
