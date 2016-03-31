//
//  ViewController.m
//  CKTagViewDemo
//
//  Created by Yck on 16/3/28.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "ViewController.h"
#import "CKTagView.h"
#import "CKTagCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet CKTagView *tagView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@1,@2,@3,@4,@5,@6,@7,@8,@9];
    
    
    [self.tagView.collectionView registerClass:[CKTagCell class] forCellWithReuseIdentifier:@"CardSliderCell"];
    self.tagView.collectionView.dataSource = self;
    self.tagView.collectionView.delegate   = self;
    
    [self.tagView ck_setTags:self.dataArray withTagLocation:CKTagStyleDefault radius:100 andInfo:nil];
    [self.tagView ck_setMiddleButtonClick:^(CKTagView *tagView) {
//        [tagView ck_changeTagsLocationWithInfo:@[@(1/8.0),@(1/4.0),@(3/8.0)] animated:YES];
        [tagView ck_changeStyle];
    }];
    [self.tagView ck_settagViewSize:^CGSize(NSIndexPath *indexPath) {
        return CGSizeMake(90, 20);
    }];
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
    static NSString *identifier = @"CardSliderCell";
    CKTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    CKTagCell *tagCell = (CKTagCell *)cell;
    [tagCell ck_setTitle:[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]]];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CKTagCell *cell = (CKTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@">>>>>> %@",cell);
    
}
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(104.0f, 20.0f);
}
@end
