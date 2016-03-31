//
//  CKCircleLayout.h
//  CKCollectionViewLayoutDemo
//
//  Created by Yck on 16/3/11.
//  Copyright © 2016年 CK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CKTagStyle) {
    CKTagStyleDefault, //默认是顺时针平均分布
    CKTagStyleLeftRight,
    CKTagStyleAllLeft,
    CKTagStyleAllright,
    CKTagStyleLeftOnltOne,
    CKTagStyleRightOnlyOne,
};

typedef CGSize(^CKTagViewSizeCallBack)(NSIndexPath *indexPath);

@interface CKCircleLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CKTagStyle style;

- (void)ck_setLoatcionInfo:(NSArray *)loactionInfo;

- (void)ck_setTagViewSize:(CKTagViewSizeCallBack)tagSize;

- (void)ck_changeStyle;
@end
