//
//  CKCircleLayout.m
//  CKCollectionViewLayoutDemo
//
//  Created by Yck on 16/3/11.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKCircleLayout.h"

@interface CKCircleLayout ()

@property (nonatomic, strong) NSMutableArray *attributesArray;

@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) UIBezierPath *linePath;
@property (nonatomic, strong) NSArray *locationInfo;

@end

@implementation CKCircleLayout

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

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    opacityAnimation.duration = 1;
    opacityAnimation.fromValue = @(0.0);
    opacityAnimation.toValue = @(1.0);
    opacityAnimation.removedOnCompletion = YES;
    [self.lineLayer addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    //圆心位置
    CGFloat collectinoCenterX = self.collectionView.frame.size.width * 0.5;
    CGFloat collectinoCenterY = self.collectionView.frame.size.height * 0.5;
    //半径
    CGFloat radius = (self.collectionView.frame.size.height - 80) * 0.5;
    //设置attributes
    attributes.size = CGSizeMake(75, 75);
    if (count == 1) {
        attributes.center = CGPointMake(collectinoCenterX, collectinoCenterY);
    }else {
        CGFloat angle;
        //这里减去 M_PI / 2 是为了让第一个在最上边，因为第0个是0度，这是要把他调整为-90度，以此类推
        if (!self.locationInfo) {
            angle = (2 * M_PI / count) * indexPath.item - M_PI / 2;
        }else {
            CGFloat location = [self.locationInfo[indexPath.item] floatValue];
            angle = 2 * M_PI * location - M_PI / 2;
        }
        CGFloat centerX = collectinoCenterX + radius * cos(angle);
        CGFloat centerY = collectinoCenterY + radius * sin(angle);
        attributes.center = CGPointMake(centerX, centerY);
        
        
        [self.linePath moveToPoint:CGPointMake(collectinoCenterX, collectinoCenterY)];
        if (ABS(centerX - collectinoCenterX) < 75/2.0) {
            CGFloat y = collectinoCenterY > centerY ? centerY + 75/2.0 : centerY - 75/2.0;
            [self.linePath addLineToPoint:CGPointMake(centerX,y)];
        }else if (centerX > collectinoCenterX) {
            [self.linePath addLineToPoint:CGPointMake(centerX - 75/2.0, centerY + 75/2.0)];
            [self.linePath addLineToPoint:CGPointMake(centerX - 75/2.0 + 75, centerY + 75/2.0)];
        }else {
            [self.linePath addLineToPoint:CGPointMake(centerX + 75/2.0, centerY + 75/2.0)];
            [self.linePath addLineToPoint:CGPointMake(centerX + 75/2.0 - 75, centerY + 75/2.0)];
        }
        
    }
    
    
    return attributes;
    
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
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
