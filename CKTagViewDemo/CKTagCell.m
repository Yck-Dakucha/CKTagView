//
//  CKTagCell.m
//  CKTagViewDemo
//
//  Created by Yck on 16/3/30.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKTagCell.h"

@interface CKTagCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CKTagCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self ck_setContent];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self ck_setContent];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self ck_setContent];
    }
    return self;
}

- (void)ck_setContent {
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.titleLabel];
}
- (void)ck_setTitle:(NSString *)string {
    self.titleLabel.text = string;
}
@end
