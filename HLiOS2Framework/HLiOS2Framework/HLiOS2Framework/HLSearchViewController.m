//
//  SearchViewController.m
//  MoueeiOS2Framework
//
//  Created by Mouee-iMac on 13-8-14.
//  Copyright (c) 2013年 北京谋易软件有限责任公司. All rights reserved.
//

#import "HLSearchViewController.h"

@interface HLSearchViewController ()

@end

@implementation HLSearchViewController

@synthesize allPageEntityArr;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, 10, 500, 40)];
        searchBar.placeholder=@"Search...";
        searchBar.delegate = self;
        searchBar.showsCancelButton = NO;
        searchBar.keyboardType = UIKeyboardTypeDefault;
        //searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        //searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [[searchBar.subviews objectAtIndex:0]removeFromSuperview]; 
        [self.view addSubview: searchBar];
        
        showPageEntity = [[NSMutableArray alloc] init];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar                     // called when keyboard search button pressed
{
    [showPageEntity removeAllObjects];
    [searchBar resignFirstResponder];
    if (![searchBar.text isEqualToString:@""])
    {
        for (int i = 0; i < allPageEntityArr.count; i++)
        {
            HLPageEntity *pageEntity = [allPageEntityArr objectAtIndex:i];
            NSString *des = [NSString stringWithString:pageEntity.description];
            des = @"aaaa";
            NSRange foundObj=[des rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            if(foundObj.length > 0)
            {
                [showPageEntity addObject:pageEntity];
                NSString *imgName = pageEntity.cacheImageID;
                NSString *path = [self.rootPath stringByAppendingPathComponent:imgName];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.adjustsImageWhenHighlighted = NO;
                [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [btn setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
                [self.view addSubview:btn];
                btn.frame = CGRectMake((showPageEntity.count - 1) % 2 * 150 + 100, (showPageEntity.count - 1) / 2 * 150 + 100, 100, 100);
            }
        }
    }
}

- (void)btnClicked:(UIButton *)sender
{
    
}

//cancel button clicked...
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar                    // called when cancel button pressed
{    
    [searchBar resignFirstResponder];
    
}

- (void)dealloc
{
    [showPageEntity release];
    [allPageEntityArr release];
    [super dealloc];
}

@end
