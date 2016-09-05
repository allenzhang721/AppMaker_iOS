//
//  PushHUD.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 9/1/16.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "PushHUD.h"
#import "PushCell.h"
#import "PushController.h"

@interface CleardView : UIView

@end

@implementation CleardView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *v in self.subviews) {
        CGPoint p = [self convertPoint:point toView:v];
        if ([v pointInside:p withEvent:event]) {
            NSLog(@"%@ cleanrddd", NSStringFromClass(self.class));
            return true;
        }
    }
    return false;
}

@end

typedef void(^Handler)();

@interface PushListView : UIView

@property(nonatomic, assign) UITableView *tableView;
@property(nonatomic, copy) Handler handler;
@property(nonatomic, copy) Handler clearHandler;
@end

@implementation PushListView {
    
    NSUInteger count;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    count = 100;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 44) style:(UITableViewStylePlain)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self addSubview:_tableView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 44)];
    toolbar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
    fix.width = 10;
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemStop) target:self action:@selector(done:)];
    close.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemTrash) target:self action:@selector(clear:)];
    clear.tintColor = [UIColor whiteColor];
    UIBarButtonItem *fix2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
    fix2.width = 10;
    toolbar.items = @[fix, clear, flex, close, fix2];
    [self addSubview:toolbar];
    
    
    _tableView.estimatedRowHeight = 44;
//    _tableView.dataSource = self;
}

- (void) done:(id)sender {
    if (_handler) {
        _handler();
    }
}

- (void)clear:(id)sender {
    if (_clearHandler) {
        _clearHandler();
    }
}

@end

@interface TableViewCell : UITableViewCell

@end

@implementation TableViewCell

-(void) layoutSubviews {
    [super layoutSubviews];
    
    CGRect f1 = self.textLabel.frame;
    f1.origin.x = 20;
    self.textLabel.frame = f1;
    
    CGRect f = self.detailTextLabel.frame;
    f.origin.x = 20;
    self.detailTextLabel.frame = f;
}

@end

@interface PushView : CleardView <UITableViewDataSource>

@property(assign, nonatomic) PushHUD *hud;
@property(assign, nonatomic) PushListView *listView;

- (void)show;
- (void)showList;

@end

@implementation PushView {
    NSUInteger _totalCount;
    NSUInteger _currentCount;
    BOOL showing;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        showing = false;
    }
    return self;
}

- (void)show {
    if (!_hud.datasource || showing) {
        return;
    }
    showing = true;
    _totalCount = [_hud.datasource numberOfdipslayItemInPushHUD];
    _currentCount = 0;
    [self next];
}

- (void)next {
    if (_currentCount >= _totalCount) {
        showing = false;
        [PushHUD dismiss];
        return;
    } else if (!showing) {
        [PushHUD dismiss];
        return;
    }else {
        
        PushCell *p = [PushController newPushView];
        p.closeHandler = ^{
            showing = false;
            [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
                p.transform = CGAffineTransformMakeTranslation(0, -p.bounds.size.height);
            } completion:^(BOOL finished) {
                if (finished) {
                    [p removeFromSuperview];
                    _currentCount += 1;
                    [self next];
                }
            }];
        };
        [_hud.datasource pushCell:p ForItemAtIndex:_currentCount];
        
        CGSize size = [p sizeThatFits:self.superview.frame.size];
        CGRect f = p.frame;
        f.size = size;
        p.frame = f;
        
        [self addSubview:p];
        p.transform = CGAffineTransformMakeTranslation(0, -p.bounds.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            p.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            if (finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (showing) {
                        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
                            p.transform = CGAffineTransformMakeTranslation(0, -p.bounds.size.height);
                        } completion:^(BOOL finished) {
                            if (finished) {
                                [p removeFromSuperview];
                                _currentCount += 1;
                                [self next];
                            }
                        }];
                    }
                });
            }
        }];
    }
}

- (void)showList {
    
    _listView = [[PushListView alloc] initWithFrame:self.bounds];
    _listView.handler = ^{
        [PushHUD dismissList];
    };
    _listView.clearHandler = ^{
        [(PushController *)_hud.datasource removeAll];
        [_listView.tableView reloadData];
    };
    _listView.tableView.dataSource = self;
    _listView.tableView.delegate = self;
    
    [self addSubview:_listView];
}

- (void)dismissList {
    _listView.tableView.dataSource = nil;
    [_listView removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_hud.datasource numberOfItemInPushHUD];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell.detailTextLabel) {
        cell = [[TableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier: @"Cell"];
        
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    if (cell.textLabel.numberOfLines != 0) {
        cell.textLabel.numberOfLines = 0;
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    
    PushMessage *m = [(PushController *)_hud.datasource messageAtIndex:indexPath.item];
    
    cell.textLabel.text = m.content;
    cell.backgroundColor = [UIColor clearColor];
    
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.text = m.createDate;
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [(PushController *)_hud.datasource removeMessageAt:indexPath.item];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
}

@end

@interface PushHUD ()

@property (strong, nonatomic) CleardView *overlayView;
@property (strong, nonatomic) PushView *contentView;
@property (assign, nonatomic) UIWindowLevel maxSupportedWindowLevel; // default is UIWindowLevelNormal

@end

@implementation PushHUD

+ (PushHUD*)shareInstance {
    static dispatch_once_t once;
    
    static PushHUD *share;
    dispatch_once(&once, ^{ share = [[self alloc] init];});
    return share;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxSupportedWindowLevel = UIWindowLevelNormal;
    }
    return self;
}

- (UIControl *)overlayView {
    if(!_overlayView) {
        _overlayView = [[CleardView alloc] init];
        _overlayView.userInteractionEnabled = true;
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
//        [_overlayView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
    // Update frame
    CGRect windowBounds = [[[UIApplication sharedApplication] delegate] window].bounds;
    _overlayView.frame = windowBounds;
    
    return _overlayView;
}

- (PushView *)contentView {
    if(!_contentView) {
        _contentView = [[PushView alloc] init];
        _contentView.hud = self;
        _contentView.userInteractionEnabled = true;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentView.backgroundColor = [UIColor clearColor];
    }
    // Update frame
    CGRect windowBounds = [[[UIApplication sharedApplication] delegate] window].bounds;
    _contentView.frame = windowBounds;
    
    return _contentView;
}

- (void)updateViewHierarchy {
    if(!self.overlayView.superview) {
        // Default case: iterate over UIApplication windows
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows) {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= self.maxSupportedWindowLevel);
            
            if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
                [window addSubview:self.overlayView];
                break;
            }
        }
    } else {
        // The HUD is already on screen, but maybot not in front. Therefore
        // ensure that overlay will be on top of rootViewController (which may
        // be changed during runtime).
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    
    // Add self to the overlay view
    if(!self.contentView.superview){
        [self.overlayView addSubview:self.contentView];
    }
    
//    self.overlayView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
}

- (void)dismiss {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [_overlayView removeFromSuperview];
        [_contentView removeFromSuperview];
    }];
}

+ (void)show {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[PushHUD shareInstance] updateViewHierarchy];
        [[PushHUD shareInstance].contentView show];
    }];
}

+ (void)dismiss {
    [[PushHUD shareInstance] dismiss];
}

+ (void)showList {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[PushHUD shareInstance] updateViewHierarchy];
        [[PushHUD shareInstance].contentView showList];
    }];
}

+ (void)dismissList {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [[PushHUD shareInstance] updateViewHierarchy];
        [[PushHUD shareInstance].contentView dismissList];
        [[PushHUD shareInstance] dismiss];
    }];
}

@end

