//
//  Html5Component.m
//  Core
//
//  Created by MoueeSoft on 12-12-26.
//
//

#import "Html5Component.h"
#import "HLContainer.h"

@implementation Html5Component
@synthesize request;


- (id)initWithEntity:(HLContainerEntity *) entity
{
    self = [super init];
    if (self != nil)
	{
        self.entity = (HTML5Entity*)entity;
        
        NSString *filePath = self.entity.rootPath;
        NSString *lastString = [entity.rootPath substringWithRange:NSMakeRange(entity.rootPath.length - 1 - 3, 4)];
        
        if ([lastString isEqualToString:@".app"])
        {
            filePath = [filePath stringByAppendingPathComponent:@"book"];
            filePath = [filePath stringByAppendingPathComponent:self.entity.folderName];
            filePath = [filePath stringByAppendingPathComponent:self.entity.indexName];
        }
        else
        {
            filePath = [filePath stringByAppendingPathComponent:self.entity.folderName];
            filePath = [filePath stringByAppendingPathComponent:self.entity.indexName];
        }
        
        NSURL *url = [[[NSURL alloc] initFileURLWithPath:filePath] autorelease];
        UIView *view = [[[UIView alloc] initWithFrame:CGRectNull] autorelease];
        NSURLRequest *re = [[[NSURLRequest alloc] initWithURL:url] autorelease];
        self.request = re;
        curWebView = [[[UIWebView alloc] init] autorelease];
        curWebView.delegate = self;
        curWebView.frame = CGRectMake(0, 0, [entity.width floatValue], [entity.height floatValue]);
        curWebView.clipsToBounds = YES;
        [view addSubview:curWebView];
        self.uicomponent = view;
        [self.uicomponent addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture)] autorelease]];//adward 3.6
        self.uicomponent.hidden = YES;
        
        UIPanGestureRecognizer *panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)] autorelease];
        panGesture.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.uicomponent addGestureRecognizer:panGesture];
        
        isFirstFail = YES;
    }
	return self;
}

-(void) beginView
{
    [super beginView];
     [curWebView loadRequest:self.request];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (!self.hidden)
    {
        self.uicomponent.hidden = NO;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (!isFirstFail) {
        return;
    }
    isFirstFail = NO;
    NSString *filePath = [  self.entity.rootPath stringByAppendingPathComponent:@""];
    filePath = [filePath stringByAppendingPathComponent:self.entity.indexName];
    NSURL *url = [[[NSURL alloc] initFileURLWithPath:filePath] autorelease];
    NSURLRequest *re = [[[NSURLRequest alloc] initWithURL:url] autorelease];
    self.request = re;
    [curWebView loadRequest:self.request];
}

- (void)didPan:(UIGestureRecognizer*)gesture
{
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (void)dealloc
{
    [self.entity release];
    [curWebView stopLoading];
    [curWebView loadRequest:nil];
    curWebView.delegate = nil;
    [curWebView removeFromSuperview];
    [self.uicomponent removeFromSuperview];
	[self.uicomponent release];
    [self.request release];
    [super dealloc];
}
@end
