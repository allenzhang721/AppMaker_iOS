//
//  PushView.m
//  HLiOS2Framework
//
//  Created by Emiaostein on 8/31/16.
//  Copyright © 2016 北京谋易软件有限责任公司. All rights reserved.
//

#import "PushCell.h"

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

- (CGFloat)x {
    return  CGRectGetMinX(self.frame);
 }

- (CGFloat)y {
    return  CGRectGetMinY(self.frame);
}

- (CGFloat)width {
    return CGRectGetWidth(self.bounds);
}

- (CGFloat)height {
    return CGRectGetHeight(self.bounds);
}

- (CGPoint) topRightOrigin {
    return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame));
}

- (CGPoint) bottomRightOrigin {
    return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
}

- (CGPoint) bottomLeftOrigin {
    return CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
}

@end

@interface PushCell ()
@property (assign, nonatomic) UILabel *textView;
@property (assign, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) UILabel *dateLabel;
@property (assign, nonatomic) UIButton *closeButton;

@end

@implementation PushCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.userInteractionEnabled = true;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    UILabel *t = [[UILabel alloc] initWithFrame:(CGRectZero)];
    t.font = [UIFont systemFontOfSize:13];
    t.textColor = [UIColor whiteColor];
    t.numberOfLines = 0;
    [self addSubview:t];
    _textView = t;
    
    UILabel *title = [[UILabel alloc] initWithFrame:(CGRectZero)];
    title.textColor = [UIColor whiteColor];
    [self addSubview:title];
    _titleLabel = title;
    
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    [close addTarget:self action:@selector(close:) forControlEvents:(UIControlEventTouchUpInside)];
    [close setTitle:@"close" forState:(UIControlStateNormal)];
    [self addSubview:close];
    _closeButton = close;
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectZero];
    date.font = [UIFont systemFontOfSize:10];
    date.textColor = [UIColor lightGrayColor];
    [self addSubview:date];
    _dateLabel = date;
}

- (void) close:(id)sender {
    
    NSLog(@"closed");
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_titleLabel sizeToFit];
    [_titleLabel setOrigin:CGPointMake(20, 10)];
    
     [_textView setOrigin:[_titleLabel bottomLeftOrigin] size:[_textView sizeThatFits:CGSizeMake([self width] - 40 , CGFLOAT_MAX)]];
    
    [_dateLabel sizeToFit];
    CGPoint br = [_textView bottomRightOrigin];
    [_dateLabel setTopRightOrigin:br];
    
    [_closeButton sizeToFit];
    [_closeButton setBottomRightOrigin:[_textView topRightOrigin]];
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
