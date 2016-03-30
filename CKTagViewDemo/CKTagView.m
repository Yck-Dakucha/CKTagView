//
//  CKTagView.m
//  CKTagViewDemo
//
//  Created by Yck on 16/3/28.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKTagView.h"

@interface CKTagView ()

@property (nonatomic, strong) CKCircleLayout *layout;
@property (nonatomic, strong) UIButton *centerbutton;

@property (nonatomic, copy) CKTagViewCallCack buttonClick;

@end


@implementation CKTagView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setContent];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setContent];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setContent];
}

- (void)setContent {
    [self addSubview:self.collectionView];
    [self addSubview:self.centerbutton];
}
#pragma mark -  设置信息
- (void)ck_setTags:(NSArray *)tagsArray withTagLocation:(CKTagStyle)style andInfo:(NSArray *)infoArray {
    self.layout.style = style;
    if (style == CKTagStyleCustom && infoArray) {
        [self.layout ck_setLoatcionInfo:infoArray];
    }
    [self.collectionView setCollectionViewLayout:self.layout];
}
- (void)ck_changeTagsLocationWithInfo:(NSArray *)infoArray animated:(BOOL)animated{
    [self.layout ck_setLoatcionInfo:infoArray];
}
- (void)ck_setMiddleButtonClick:(CKTagViewCallCack)buttonClick {
    if (buttonClick) {
        self.buttonClick = buttonClick;
    }
}
- (void)changeLocation {
    if (self.buttonClick) {
        self.buttonClick(self);
    }
}

#pragma mark -  设置标签大小
- (void)ck_settagViewSize:(CKTagViewSizeCallBack)tagSize {
    if (tagSize) {
        [self.layout ck_setTagViewSize:tagSize];
    }
}
#pragma mark -  懒加载
- (CKCircleLayout *)layout {
    if (!_layout) {
        _layout = [[CKCircleLayout alloc] init];
    }
    return _layout;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat side = MIN(self.bounds.size.width, self.bounds.size.height);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, side, side) collectionViewLayout:[[UICollectionViewLayout alloc] init]];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}
- (UIButton *)centerbutton {
    if (!_centerbutton) {
        _centerbutton = [[UIButton alloc] initWithFrame:CGRectMake(self.collectionView.center.x - 20, self.collectionView.center.y - 20, 40, 40)];
        _centerbutton.backgroundColor = [UIColor redColor];
        _centerbutton.layer.cornerRadius = 20;
        _centerbutton.layer.masksToBounds = YES;
        [_centerbutton addTarget:self action:@selector(changeLocation) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerbutton;
}


@end
