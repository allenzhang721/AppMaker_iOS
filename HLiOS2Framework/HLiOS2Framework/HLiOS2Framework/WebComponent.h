//
//  WebComponent.h
//  MoueeTest
//
//  Created by Pi Yi on 12/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Component.h"
@interface WebComponent : Component<UIWebViewDelegate>
{
    NSURLRequest *request;
    UIWebView *curWebView;
    UIActivityIndicatorView *activeView;
}
@property (nonatomic , retain) NSURLRequest *request;

//-(id) initWithPath:(NSString*) path width:(float)width height:(float)height;

- (void)changeUrl:(NSString *)newUrl;
@end
