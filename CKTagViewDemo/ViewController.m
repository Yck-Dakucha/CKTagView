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

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CKTagView *tagView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray arrayWithArray:@[@1,@2,@3,@4,@5,@6,@7,@8,@9]];
    
    
    [self.tagView ck_setTags:self.dataArray withTagLocation:CKTagStyleDefault radius:100 andInfo:nil];
    [self.tagView ck_setMiddleButtonClick:^(CKTagView *tagView) {
        [tagView ck_changeStyle];
    }];
   
    [self.tagView ck_setCellForItemAtIndexPath:^Class(NSIndexPath *indexPath) {
        return [CKTagCell class];
    } withIdentifier:@"CardSliderCell" Size:^CGSize(NSIndexPath *indexPath) {
        return CGSizeMake(120, 20);
    } willDispalyCell:^(UICollectionViewCell *cell, NSIndexPath *indexPath) {
        CKTagCell *tagCell = (CKTagCell *)cell;
        [tagCell ck_setTitle:[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]]];
    } didSelectItemAtIndexPath:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        [self.tagView ck_deleteItemsAtIndexPaths:@[indexPath]];
    }];
}


@end
