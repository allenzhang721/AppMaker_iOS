//
//  ImageComponent.h
//  MoueeReleaseVertical
//
//  Created by user on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Component.h"
#import "ImageEntity.h"

@interface ImageComponent : Component<UIScrollViewDelegate>
{
    UIImageView *imv;
    float lastScale;
}
@property (nonatomic,assign) UIImageView *imv;
@property (nonatomic,retain) NSString *imagePath;
@property (nonatomic, retain)ImageEntity *im;
@property (nonatomic, assign) CGRect uicomponentOriginFrame;        //陈星宇，11.19，图片放大可以移动
@property (nonatomic ,assign) float linkSizeRate;

-(void) setImageSize;
@end
