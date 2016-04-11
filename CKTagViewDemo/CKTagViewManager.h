//
//  CKTagViewManager.h
//  CKTagViewDemo
//
//  Created by Yck on 16/4/7.
//  Copyright © 2016年 CK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef UICollectionViewCell *(^asd)();

@interface CKTagViewManager : NSObject<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *identifier;

+ (instancetype)manager;


- (void)ck_setCellForItemAtIndexPath:(Class(^)(NSIndexPath *indexPath))cellClassForItem
                     willDispalyCell:(void(^)(UICollectionViewCell *cell, NSIndexPath *indexPath))display
            didSelectItemAtIndexPath:(void(^)(UICollectionView *collectionView, NSIndexPath *indexPath))didSelectItem;
@end
