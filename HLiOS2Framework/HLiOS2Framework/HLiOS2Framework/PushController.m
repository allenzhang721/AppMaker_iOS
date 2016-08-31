//
//  PushController.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 8/26/16.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "PushController.h"
#import "PushView.h"

@implementation PushMessage

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        //msg_id, dttile, dtcont, crdate
        self.ID = dic[@"msg_id"];
        self.title = dic[@"dttile"];
        self.content = dic[@"dtcont"];
        self.url = dic[@"url"];
        self.createDate = dic[@"crdate"];
    }
    return self;
}

@end

@implementation PushController

+(PushView *)newPushViewWithMessage:(nullable PushMessage *)message {
    NSString *mainBundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"appMakerResources.bundle"];
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:mainBundlePath];
    PushView *v = [[PushView alloc] initWithFrame:CGRectMake(0, 0, 100, 300)];
    [v setConent:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. " title:@"New notification" date:@"2016/8/31"];
    return  v;
}

@end
