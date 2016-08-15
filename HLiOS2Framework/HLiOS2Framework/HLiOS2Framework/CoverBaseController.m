//
//  CoverBaseController.m
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 13-12-31.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "CoverBaseController.h"

@implementation CoverBaseController

-(void) close{};
- (void)clean{};
- (void)beginView{};
- (void)setup:(CGRect)rect{};
- (void)initStrategy:(NSString *)flipStrategy{};
- (void)loadCoverWithCurrentPageEntity:(PageEntity *)pageEntity{};
- (void)loadCoverPageEntity:(PageEntity *)pageEntity direction:(CCoverDirection)aDirection{};
- (void) initEntity:(PageEntity *)pageEntity{};

@end
