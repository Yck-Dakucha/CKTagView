//
//  CKTagViewManager.m
//  CKTagViewDemo
//
//  Created by Yck on 16/4/7.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKTagViewManager.h"

@interface CKTagViewManager ()

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) Class (^cellForItem)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^display)(UICollectionViewCell *cell, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didSelectItem)(UICollectionView *collectionView, NSIndexPath *indexPath);

@end

@implementation CKTagViewManager

+ (instancetype)manager {
    CKTagViewManager *manager = [[CKTagViewManager alloc] init];
    return manager;
}
- (void)ck_setCellForItemAtIndexPath:(Class(^)(NSIndexPath *indexPath))cellClassForItem
                     willDispalyCell:(void(^)(UICollectionViewCell *cell, NSIndexPath *indexPath))display
            didSelectItemAtIndexPath:(void(^)(UICollectionView *collectionView, NSIndexPath *indexPath))didSelectItem {
    self.cellForItem = cellClassForItem;
    self.display = display;
    self.didSelectItem = didSelectItem;
}

#pragma mark -  collectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    self.collectionView = collectionView;
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark -  collectionView Delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.display) {
        self.display(cell,indexPath);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectItem) {
        self.didSelectItem(collectionView,indexPath);
    }
}

#pragma mark -  增删改
- (void)ck_insertItems:(NSArray *)items atIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {

    NSMutableIndexSet *tempIndexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *indexpath in indexPaths) {
        [tempIndexSet addIndex:indexpath.item];
    }
    [self.dataArray insertObjects:items atIndexes:tempIndexSet];
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}
- (void)ck_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    NSMutableIndexSet *tempIndexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *indexpath in indexPaths) {
        [tempIndexSet addIndex:indexpath.item];
    }
    [self.dataArray removeObjectsAtIndexes:tempIndexSet];
    [self.collectionView deleteItemsAtIndexPaths:indexPaths];
}
- (void)ck_reloadItems:(NSArray *)items atIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    NSMutableIndexSet *tempIndexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *indexpath in indexPaths) {
        [tempIndexSet addIndex:indexpath.item];
    }
    [self.dataArray replaceObjectsAtIndexes:tempIndexSet withObjects:items];
    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
}

#pragma mark -  懒加载
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
