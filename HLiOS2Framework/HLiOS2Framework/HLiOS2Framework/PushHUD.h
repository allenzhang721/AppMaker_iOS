//
//  PushHUD.h
//  HLiOS2Framework
//
//  Created by Emiaostein on 9/1/16.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushHUD : NSObject

+ (void)show;
+ (void)dismiss;

@end

@protocol PushViewDataSource <NSObject>



@end


