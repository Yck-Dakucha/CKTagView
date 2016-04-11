//
//  CKTagView.m
//  CKTagViewDemo
//
//  Created by Yck on 16/3/28.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKTagView.h"
#import "CKTagViewManager.h"

@interface CKTagView ()

@property (nonatomic, strong) CKCircleLayout *layout;
@property (nonatomic, strong) UIButton *centerbutton;
@property (nonatomic, strong) CKTagViewManager *manager;

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
- (void)ck_setTags:(NSArray *)tagsArray withTagLocation:(CKTagStyle)style radius:(CGFloat)radius andInfo:(NSArray *)infoArray {
    _style = style;
    self.manager.dataArray = [NSMutableArray arrayWithArray:tagsArray];
    self.layout.style = style;
    self.layout.radius = radius;
    [self.collectionView setCollectionViewLayout:self.layout];
}
- (void)setStyle:(CKTagStyle)style {
    _style = style;
    self.layout.style = style;
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
    __weak typeof(self) weakSelf = self;
    if (self.buttonClick) {
        self.buttonClick(weakSelf);
    }
}
#pragma mark -  改变布局
- (void)ck_changeStyle {
    [self.layout ck_changeStyle];
}
#pragma mark -  设置标签大小
- (void)ck_setCellForItemAtIndexPath:(Class(^)(NSIndexPath *indexPath))cellClassForItem
                      withIdentifier:(NSString *)identifier
                                Size:(CKTagViewSizeCallBack)tagSize
                     willDispalyCell:(void(^)(UICollectionViewCell *cell, NSIndexPath *indexPath))display
            didSelectItemAtIndexPath:(void(^)(UICollectionView *collectionView, NSIndexPath *indexPath))didSelectItem {
    Class class = cellClassForItem([NSIndexPath indexPathForItem:0 inSection:0]);
    [self.collectionView registerClass:class forCellWithReuseIdentifier:identifier];
    self.collectionView.delegate = self.manager;
    self.collectionView.dataSource = self.manager;
    if (tagSize) {
        [self.layout ck_setTagViewSize:tagSize];
    }
    self.manager.identifier = identifier;
    [self.manager ck_setCellForItemAtIndexPath:cellClassForItem willDispalyCell:display didSelectItemAtIndexPath:didSelectItem];
}

#pragma mark -  懒加载
- (CKCircleLayout *)layout {
    if (!_layout) {
        _layout = [[CKCircleLayout alloc] init];
    }
    return _layout;
}
- (CKTagViewManager *)manager {
    if (!_manager) {
        _manager = [CKTagViewManager manager];
    }
    return _manager;
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
