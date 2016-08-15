//
//  RollingTextEntity.h
//  Core
//
//  Created by Mouee-iMac on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HLContainerEntity.h"
#import "HLCoreTextNode.h"

@interface RollingTextEntity : HLContainerEntity

@property (nonatomic, retain) NSString *fontFamily;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *backColor;
@property (nonatomic, retain) NSString *textColor;
@property (nonatomic, retain) NSString *textAlign;
@property (nonatomic, assign) NSMutableArray *textNodeArray;
//added by Adward 13-12-12
@property (nonatomic, assign) BOOL borderVisible;
@property (nonatomic, retain) NSString *borderColor;


@property BOOL isStatic;
@property BOOL enableNote;
@property Boolean showBorder;
@property float fontSize;
@property float backAlpha;
@property BOOL isNewTextStyle;

- (void)setStaticFontSize:(int)size;

@end
