//
//  ScorllImageComponent.h
//  Core
//
//  Created by MoueeSoft on 12-12-5.
//
//

#import "Component.h"
#import "ScrollImageEntity.h"

@interface ScrollImageComponent : Component

@property (nonatomic, retain) ScrollImageEntity *scrollEntity;
@property (nonatomic, retain) NSString *rootPath;


@end
