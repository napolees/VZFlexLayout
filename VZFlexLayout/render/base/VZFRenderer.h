//
//  VZFRenderer.h
//  VZFlexLayout-Example
//
//  Created by heling on 2017/1/22.
//  Copyright © 2017年 Vizlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VZFRenderer : NSObject

@property(nonatomic,strong) UIColor *backgroundColor;

@property(nonatomic,assign) CGFloat cornerRadius;

@property(nonatomic,assign) CGFloat borderWidth;
@property(nonatomic,strong) UIColor *borderColor;

@property(nonatomic,assign) BOOL clip;

//can not override by sub class
- (void)drawInContext:(CGContextRef)context bounds:(CGRect)bounds;


@end


//for sub class to override
@interface VZFRenderer(VZFRendererSubclassing)

- (void)drawContentInContext:(CGContextRef)context bounds:(CGRect)bounds;

@end


@interface VZFRenderer(VZFRendererHierarchy)

- (nullable VZFRenderer *)superRenderer;
- (nullable NSArray<__kindof VZFRenderer *> *)subRenderers;

- (void)removeFromSuperRenderer;


/**
 Insert renderer at specified index

 @param renderer target renderer
 @param index specified index
 */
- (void)insertSubRenderer:(VZFRenderer *)renderer atIndex:(NSInteger)index;


/**
 
 Exchange renderer at index1 and index2.If index1 or index2 is invalid(less than 0 or greater than the count of the receiver's sub renders), it will have no effect.

 @param index1 the index of renderer to be exchanged
 @param index2 the index of renderer to be exchanged
 */
- (void)exchangeSubRendererAtIndex:(NSInteger)index1 withSubRendererAtIndex:(NSInteger)index2;


/**
 Add  renderer to the top of the sub renderers.If the specified renderer is already one of the receiver's sub renderers, it will have no effect.

 @param renderer the renderer to be added
 */
- (void)addSubRenderer:(VZFRenderer *)renderer;


/**
 Insert specified renderer below the sibling sub renderer.If renderer is already one of the receiver's sub renderers or the siblingSubRenderer is not one of the receiver's sub renderers, it will have no effect

 @param renderer the renderer to be inserted
 @param siblingSubRenderer the renderer
 */
- (void)insertSubRenderer:(VZFRenderer *)renderer belowSubRenderer:(VZFRenderer *)siblingSubRenderer;

/**
 Insert specified renderer above the sibling sub renderer.If renderer is already one of the receiver's sub renderers or the siblingSubRenderer is not one of the receiver's sub renderers, it will have no effect
 
 @param renderer the renderer to be inserted
 @param siblingSubRenderer the renderer
 */
- (void)insertSubRenderer:(VZFRenderer *)renderer aboveSubRenderer:(VZFRenderer *)siblingSubRenderer;


/**
 Bring the specified renderer to the front. If the specified renderer is not one the sub renderers, it will have no effect.

 @param renderer the renderer to be operated
 */
- (void)bringSubRendererToFront:(VZFRenderer *)renderer;

/**
 Send the specified renderer to the back. If the specified renderer is not one the sub renderers, it will have no effect.
 
 @param renderer the renderer to be operated
 */
- (void)sendSubRendererToBack:(VZFRenderer *)renderer;


/**
 Returns a Boolean value indicating whether the receiver is a subRenderer of a given renderer or identical to that renderer.
 
 @param renderer The renderer to test against the receiver’s renderer hierarchy.
 
 @return YES if the receiver is an immediate or distant subRenderer of renderer or if renderer is the receiver itself; otherwise NO.
 */
- (BOOL)isDescendantOfRenderer:(VZFRenderer *)renderer;  // returns YES for self.

/**
 Remove all the sub renderers
 */
- (void)removeAllSubRenderers;


@end