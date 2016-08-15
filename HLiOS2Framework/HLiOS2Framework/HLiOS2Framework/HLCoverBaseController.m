//
//  CoverBaseController.m
//  MoueeiOS2Framework
//
//  Created by 星宇陈 on 13-12-31.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLCoverBaseController.h"

@implementation HLCoverBaseController

-(void) close{};
- (void)clean{};
- (void)beginView{};
- (void)setup:(CGRect)rect{};
- (void)initStrategy:(NSString *)flipStrategy{};
- (void)loadCoverWithCurrentPageEntity:(HLPageEntity *)pageEntity{};
- (void)loadCoverPageEntity:(HLPageEntity *)pageEntity direction:(CCoverDirection)aDirection{};
- (void) initEntity:(HLPageEntity *)pageEntity{};

@end
