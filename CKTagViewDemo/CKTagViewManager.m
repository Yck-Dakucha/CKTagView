//
//  CKTagViewManager.m
//  CKTagViewDemo
//
//  Created by Yck on 16/4/7.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKTagViewManager.h"

@interface CKTagViewManager ()

@property (nonatomic, copy) UICollectionViewCell *(^cellForItem)(UICollectionView *collectionView, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^display)(UICollectionViewCell *cell, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didSelectItem)(UICollectionView *collectionView, NSIndexPath *indexPath);



@end

@implementation CKTagViewManager

+ (instancetype)manager {
    CKTagViewManager *manager = [[CKTagViewManager alloc] init];
    return manager;
}
- (void)ck_setCellForItemAtIndexPath:(UICollectionViewCell *(^)(UICollectionView *collectionView, NSIndexPath *indexPath))cellForItem
                     willDispalyCell:(void(^)(UICollectionViewCell *cell, NSIndexPath *indexPath))display
            didSelectItemAtIndexPath:(void(^)(UICollectionView *collectionView, NSIndexPath *indexPath))didSelectItem {
    self.cellForItem = cellForItem;
    self.display = display;
    self.didSelectItem = didSelectItem;
}

#pragma mark -  collectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark -  collectionView Delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identifier = @"CardSliderCell";
//    CKTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return self.cellForItem(collectionView,indexPath);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    self.display(cell,indexPath);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.dataArray.count == 1) {
//        return;
//    }
//    [self.dataArray removeObjectAtIndex:indexPath.item];
//    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    self.didSelectItem(collectionView,indexPath);
}

#pragma mark -  懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
