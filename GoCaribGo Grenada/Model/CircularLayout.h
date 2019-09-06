//
//  DSCircularLayout.h
//  DSCircularCollectionView-Example
//

#import <UIKit/UIKit.h>

@interface CircularLayout : UICollectionViewLayout

@property (nonatomic, assign) CGPoint centre;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, assign) CGFloat angularSpacing;

@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic, assign) BOOL mirrorX;

@property (nonatomic, assign) BOOL mirrorY;

@property (nonatomic, assign) BOOL rotateItems;

-(void)initWithCentre:(CGPoint)centre radius:(CGFloat)radius itemSize:(CGSize)itemSize andAngularSpacing:(CGFloat)angularSpacing;

-(void)setStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;

@end
