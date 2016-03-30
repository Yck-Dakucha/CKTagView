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

    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeAnimation.duration = 1;
    strokeAnimation.fromValue = @(0.0);
    strokeAnimation.toValue = @(1.0);
    strokeAnimation.removedOnCompletion = YES;
    [self.lineLayer addAnimation:strokeAnimation forKey:@"strokeAnimation"];
    
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
    CGFloat radius = (self.collectionView.frame.size.height - MAX(width, hight) - 5) * 0.5;

    if (count == 1) {
        attributes.center = CGPointMake(kCollectinoCenterX, kCollectinoCenterY);
    }else {
        switch (self.style) {
            case CKTagStyleDefault:
                attributes.center = [self ck_defaultStyleWithItem:indexPath.item WithRadius:radius];
                break;
                case CKTagStyleCustom:
                attributes.center = [self ck_customStyleWithItem:indexPath.item WithRadius:radius];
            default:
                break;
        }
        
        CGFloat centerX = attributes.center.x;
        CGFloat centerY = attributes.center.y;

        [self.linePath moveToPoint:CGPointMake(kCollectinoCenterX, kCollectinoCenterY)];
        if (ABS(centerX - kCollectinoCenterX) < width/2.0) {
            CGFloat y = kCollectinoCenterY > centerY ? centerY + width/2.0 : centerY - hight/2.0;
            [self.linePath addLineToPoint:CGPointMake(centerX,y)];
        }else if (centerX > kCollectinoCenterX) {
            [self.linePath addLineToPoint:CGPointMake(centerX - width/2.0, centerY + hight/2.0)];
            [self.linePath addLineToPoint:CGPointMake(centerX - width/2.0 + width, centerY + hight/2.0)];
        }else {
            [self.linePath addLineToPoint:CGPointMake(centerX + width/2.0, centerY + hight/2.0)];
            [self.linePath addLineToPoint:CGPointMake(centerX + width/2.0 - width, centerY + hight/2.0)];
        }
        
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
