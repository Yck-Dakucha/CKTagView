//
//  CKTagView.h
//  CKTagViewDemo
//
//  Created by Yck on 16/3/28.
//  Copyright © 2016年 CK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CKTagLocation) {
    CKTagLocationDefault, //默认是顺时针平均分布
    CKTagLocationCustom,  //自定义布局，需要传输位置信息
};

@interface CKTagView : UIView

typedef void(^CKTagViewCallCack)(CKTagView *tagView);


@property (nonatomic, strong) UICollectionView *collectionView;

/**
 *  设置标签内容，与标签位置信息
 *
 *  @param tagsArray 标签内容
 *  @param location  标签位置信息，默认是顺时针平均分布，如果选择CKTagLocationCustom自定义布局，需要传入info来定义标签位置
 *  @param infoArray 定义标签位置，位置类型为NSNumber,范围是 0->1 ,对应 0-> 2 * M_PI,且与tagsArray一一对应
 */
- (void)ck_setTags:(NSArray *)tagsArray withTagLocation:(CKTagLocation)location andInfo:(NSArray *)infoArray;
- (void)ck_changeTagsLocationWithInfo:(NSArray *)infoArray animated:(BOOL)animated;
- (void)ck_setMiddleButtonClick:(CKTagViewCallCack)buttonClick;

- (void)ck_settagView:(UIView *)tagView withSize:(CGSize)size;
@end