//
//  PushView.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 8/31/16.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "PushView.h"

@implementation UIView (Frame)

- (void)setOrigin: (CGPoint)origin size:(CGSize)size {
    CGRect f = self.frame;
    f.origin = origin;
    f.size = size;
    self.frame = f;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect f = self.frame;
    [self setOrigin:origin size:f.size];
}

- (void)setSize:(CGSize)size {
    CGRect f = self.frame;
    [self setOrigin:f.origin size:size];
}

- (void)setTopRightOrigin:(CGPoint)origin {
    CGRect f = self.frame;
    [self setOrigin:CGPointMake(origin.x - f.size.width, origin.y) size:f.size];
}

- (void) setBottomRightOrigin:(CGPoint)origin {
    CGRect f = self.frame;
    [self setOrigin:CGPointMake(origin.x - f.size.width, origin.y - f.size.height) size:f.size];
}

- (CGPoint) bottomRightOrigin {
    return CGPointMake(self.frame.origin.x + self.bounds.size.width, self.frame.origin.y + self.bounds.size.height);
}

@end

@interface PushView ()
@property (assign, nonatomic) UILabel *textView;
@property (assign, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) UILabel *dateLabel;

@end

@implementation PushView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    UILabel *t = [[UILabel alloc] initWithFrame:(CGRectZero)];
    t.font = [UIFont systemFontOfSize:13];
    t.textColor = [UIColor whiteColor];
    t.numberOfLines = 0;
    t.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    [self addSubview:t];
    _textView = t;
    
    UILabel *title = [[UILabel alloc] initWithFrame:(CGRectZero)];
    title.textColor = [UIColor whiteColor];
    [self addSubview:title];
    _titleLabel = title;
    _titleLabel.text = @"Emiaostein";
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:close];
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectZero];
    date.font = [UIFont systemFontOfSize:10];
    date.textColor = [UIColor lightGrayColor];
    [self addSubview:date];
    _dateLabel = date;
    _dateLabel.text = @"Emiaostein";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_titleLabel sizeToFit];
    [_titleLabel setOrigin:CGPointMake(20, 10)];
    
     [_textView setOrigin:CGPointMake(20, 30) size:[_textView sizeThatFits:CGSizeMake(self.bounds.size.width - 40 , CGFLOAT_MAX)]];
    
    [_dateLabel sizeToFit];
    CGPoint br = [_textView bottomRightOrigin];
    [_dateLabel setTopRightOrigin:br];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize textsize = [_textView sizeThatFits:CGSizeMake(size.width - 40 , CGFLOAT_MAX)];
    return CGSizeMake(size.width, textsize.height + 30 + 20);
}

-(void) setConent:(NSString *)content title:(NSString *)title date:(NSString *)date {
    _titleLabel.text = title;
    _textView.text = content;
    _dateLabel.text = date;
}

@end
