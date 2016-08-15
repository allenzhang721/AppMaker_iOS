//
//  LinkageEntity.h
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-10-25.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkageEntity : NSObject
{
    NSString *linkID;
    float rate;
}
@property (nonatomic,retain) NSString *linkID;
@property (nonatomic,assign) float rate;
@end
