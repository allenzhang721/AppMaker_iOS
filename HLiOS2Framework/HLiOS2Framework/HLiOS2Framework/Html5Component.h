//
//  Html5Component.h
//  Core
//
//  Created by MoueeSoft on 12-12-26.
//
//

#import "Component.h"
#import "HTML5Entity.h"

@interface Html5Component : Component<UIWebViewDelegate>
{
    NSURLRequest *request;
    UIWebView *curWebView;
    BOOL isFirstFail;
}
@property (nonatomic , retain) NSURLRequest *request;
@property (nonatomic , retain) HTML5Entity *entity;

@end
