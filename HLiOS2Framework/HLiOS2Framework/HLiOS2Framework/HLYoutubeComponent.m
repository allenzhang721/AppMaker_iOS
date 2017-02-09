//
//  HLYoutubeComponent.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 26/09/2016.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLYoutubeComponent.h"

@implementation HLYoutubeComponent

- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self)
    {
        self.entity    = (HLYoutubeEntity *)entity;
//        self.customHeight = true;
        [self p_setupUI];
    }
    return self;
}

// MARK: - Private Method
- (void)p_setupUI {
    
    YTPlayerView *v = [[YTPlayerView alloc] initWithFrame:CGRectMake(0, 0, _entity.width.floatValue, _entity.height.floatValue)];
    
    self.uicomponent = v;
    
    if ([self.uicomponent isKindOfClass:[YTPlayerView class]]) {
        [(YTPlayerView *)self.uicomponent loadWithVideoId:_entity.VideoID];
    }
}

- (void)clean {
    [super clean];
    [(YTPlayerView *)self.uicomponent stopVideo];
    
}

@end
