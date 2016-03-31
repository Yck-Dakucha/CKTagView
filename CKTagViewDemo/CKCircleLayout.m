//
//  CKCircleLayout.m
//  CKCollectionViewLayoutDemo
//
//  Created by Yck on 16/3/11.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKCircleLayout.h"

#define kCollectinoCenterX self.collectionView.frame.size.width * 0.5
#define kCollectinoCenterY self.collectionView.frame.size.height * 0.5

@interface CKCircleLayout ()

@property (nonatomic, strong) NSMutableArray *attributesArray;

@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) UIBezierPath *linePath;
@property (nonatomic, strong) NSArray *locationInfo;

@property (nonatomic, copy) CKTagViewSizeCallBack tagSize;

@end

@implementation CKCircleLayout

- (void)setStyle:(CKTagStyle)style {
    _style = style;
    [self.linePath removeAllPoints];
    [self invalidateLayout];
}
- (void)ck_setLoatcionInfo:(NSArray *)loactionInfo {
    self.locationInfo = [NSArray arrayWithArray:loactionInfo];
    [self.linePath removeAllPoints];
    [self invalidateLayout];
}

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [self.linePath removeAllPoints];
    [self invalidateLayout];
}
- (void)prepareLayout {
    [super prepareLayout];
    [self.attributesArray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attributes];
    }

    if (!_lineLayer) {
        [self.collectionView.layer addSublayer:self.lineLayer];
    }else {
        self.lineLayer.path = self.linePath.CGPath;
        [self.lineLayer display];
    }

    CABasicAnimation *strokeAnimation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation1.duration = 1;
    strokeAnimation1.fromValue = @(0.0);
    strokeAnimation1.toValue = @(1.0);
    strokeAnimation1.removedOnCompletion = YES;
//    CABasicAnimation *strokeAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    strokeAnimation2.duration = 1;
//    strokeAnimation2.fromValue = @(0.3);
//    strokeAnimation2.toValue = @(0.6);
//    strokeAnimation2.removedOnCompletion = YES;
//    CABasicAnimation *strokeAnimation3 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    strokeAnimation3.duration = 1;
//    strokeAnimation3.fromValue = @(0.6);
//    strokeAnimation3.toValue = @(1.0);
//    strokeAnimation3.removedOnCompletion = YES;
    [self.lineLayer addAnimation:strokeAnimation1 forKey:nil];
//    [self.lineLayer addAnimation:strokeAnimation2 forKey:nil];
//    [self.lineLayer addAnimation:strokeAnimation3 forKey:nil];
    
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];

    //设置attributes
    if (self.tagSize) {
        CGSize tagSize = self.tagSize(indexPath);
        if (tagSize.width > 0 && tagSize.height > 0) {
            attributes.size = tagSize;
        }
    }else {
        attributes.size = CGSizeMake(75, 75);
    }
    
    CGFloat width = attributes.size.width;
    CGFloat hight = attributes.size.height;
    //半径
    if (!self.radius) {
        self.radius = 50;
    }

    if (count == 1) {
        attributes.center = CGPointMake(kCollectinoCenterX - self.radius, self.collectionView.frame.size.height/4.0);
    }else {
        switch (self.style) {
            case CKTagStyleDefault:
                attributes.center = [self ck_defaultStyleWithItem:indexPath.item WithRadius:self.radius];
                break;
            case CKTagStyleLeftRight:
            {
                CGFloat leftCount = count%2 == 0 ? count/2 : count/2 + 1;
                attributes.center = [self ck_leftRightStyleWithItem:indexPath.item itemWidth:width LeftCount:leftCount];
                break;
            }
            case CKTagStyleAllLeft:
                attributes.center = [self ck_leftRightStyleWithItem:indexPath.item itemWidth:width LeftCount:count];
                break;
            case CKTagStyleAllright:
                attributes.center = [self ck_leftRightStyleWithItem:indexPath.item itemWidth:width LeftCount:0];
                break;
            case CKTagStyleLeftOnltOne:
                attributes.center = [self ck_leftRightStyleWithItem:indexPath.item itemWidth:width LeftCount:1];
                break;
            case CKTagStyleRightOnlyOne:
                attributes.center = [self ck_leftRightStyleWithItem:indexPath.item itemWidth:width LeftCount:count - 1];
                break;
            default:
                break;
        }
    }
    
    CGFloat centerX = attributes.center.x;
    CGFloat centerY = attributes.center.y;

    [self.linePath moveToPoint:CGPointMake(kCollectinoCenterX, kCollectinoCenterY)];
    if (ABS(centerX - kCollectinoCenterX) < width/2.0) {
        CGFloat y = kCollectinoCenterY > centerY ? centerY + hight/2.0 : centerY - hight/2.0;
        [self.linePath addLineToPoint:CGPointMake(centerX,y)];
    }else if (centerX > kCollectinoCenterX) {
        [self.linePath addLineToPoint:CGPointMake(centerX - width/2.0, centerY + hight/2.0 + 5.0)];
        [self.linePath addLineToPoint:CGPointMake(centerX - width/2.0 + width, centerY + hight/2.0 + 5.0)];
    }else {
        [self.linePath addLineToPoint:CGPointMake(centerX + width/2.0, centerY + hight/2.0 + 5.0)];
        [self.linePath addLineToPoint:CGPointMake(centerX + width/2.0 - width, centerY + hight/2.0 + 5.0)];
    }
        
    return attributes;
}

#pragma mark -  默认围绕中心的圆形布局

- (CGPoint)ck_defaultStyleWithItem:(NSInteger)index WithRadius:(CGFloat)radius {
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    CGFloat angle = (2 * M_PI / count) * index - M_PI / 2;
    return CGPointMake(kCollectinoCenterX + radius * cos(angle), kCollectinoCenterY + radius * sin(angle));
}

#pragma mark -  自定义布局

- (CGPoint)ck_customStyleWithItem:(NSInteger)index WithRadius:(CGFloat)radius {
    CGFloat location = [self.locationInfo[index] floatValue];
    CGFloat angle = 2 * M_PI * location - M_PI / 2;
    return CGPointMake(kCollectinoCenterX + radius * cos(angle), kCollectinoCenterY + radius * sin(angle));
}

#pragma mark -  自定义左右布局

- (CGPoint)ck_leftRightStyleWithItem:(NSInteger)index itemWidth:(CGFloat)width LeftCount:(NSInteger)leftCount {
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    CGFloat leftDelta = (CGFloat)self.collectionView.frame.size.height/leftCount;
    CGFloat rightDelta = (CGFloat)self.collectionView.frame.size.height/(count - leftCount);
    if ((index + 1) <= leftCount) {
        if (leftCount == 1) {
            return CGPointMake(kCollectinoCenterX - self.radius,(CGFloat)leftDelta/2);
        }
        return CGPointMake(kCollectinoCenterX - self.radius, leftDelta *(index + 1) - (CGFloat)leftDelta/2);
    }else{
        if ((count - leftCount) == 1) {
            return CGPointMake(kCollectinoCenterX + self.radius,(CGFloat)rightDelta/2);
        }
        return CGPointMake(kCollectinoCenterX + self.radius, rightDelta *(index - leftCount + 1) - (CGFloat)rightDelta/2);
    }
}
#pragma mark -  更换布局
- (void)ck_changeStyle {
    if (self.style == 5) {
        self.style = 0;
        return;
    }
    self.style += 1;
}
#pragma mark -  设置刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
- (void)ck_setTagViewSize:(CKTagViewSizeCallBack)tagSize {
    if (tagSize) {
        self.tagSize = tagSize;
    }
}

#pragma mark -  懒加载
- (NSMutableArray *)attributesArray {
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

- (UIBezierPath *)linePath {
    if (!_linePath) {
        _linePath = [UIBezierPath bezierPath];
    }
    return _linePath;
}

- (CAShapeLayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.strokeColor = [UIColor blackColor].CGColor;
        _lineLayer.fillColor = [UIColor clearColor].CGColor;
        _lineLayer.path = self.linePath.CGPath;
        _lineLayer.lineWidth = 3;
    }
    return _lineLayer;
}
@end
