//
//  ViewController.m
//  CKTagViewDemo
//
//  Created by Yck on 16/3/28.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "ViewController.h"
#import "CKTagView.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet CKTagView *tagView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@1,@2,@3];
    
    
    [self.tagView.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CardSliderCell"];
    self.tagView.collectionView.dataSource = self;
    self.tagView.collectionView.delegate   = self;
    
    [self.tagView ck_setTags:self.dataArray withTagLocation:CKTagLocationCustom andInfo:@[@(7/8.0),@(5/8.0),@(5/16.0)]];
    [self.tagView ck_setMiddleButtonClick:^(CKTagView *tagView) {
        [tagView ck_changeTagsLocationWithInfo:@[[NSNumber numberWithFloat:1/8.0],[NSNumber numberWithFloat:1/4.0],[NSNumber numberWithFloat:3/8.0]] animated:YES];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    cell.backgroundColor = [UIColor blueColor];
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 3;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
