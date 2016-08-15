//
//  BaseControlPanelViewController.m
//  MoueeIOS2Core
//
//  Created by Pi Yi on 1/24/13.
//  Copyright (c) 2013 Bei Jing MoueeSoft Co., Ltd. All rights reserved.
//

#import "BaseControlPanelViewController.h"
#import "ClearView.h"
@interface BaseControlPanelViewController ()

@end

@implementation BaseControlPanelViewController
@synthesize bookController;
@synthesize orientation;
@synthesize sx;
@synthesize sy;
@synthesize sx1;
@synthesize sy1;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(id) init
{
	self = [super init];
	if (self != nil)
	{
        self.sx = 1.0;
        self.sy = 1.0;
        self.sx1 = 1.0;
        self.sy1 = 1.0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    self.view = [[ClearView alloc] init];
    self.view.autoresizingMask = 63;
    ((ClearView*)self.view).delegate = self;
}

-(void)onTouchInside:(CGPoint)point withEvent:(UIEvent *)event{}


-(void) setup:(CGRect )rect{}
-(void) refreshPanel:(int)index count:(int)count enableNav:(Boolean)enableNav{}
-(void) enable{}
-(void) disable{}
-(void) popDown{}
-(void) dismissPopup {}


@end
