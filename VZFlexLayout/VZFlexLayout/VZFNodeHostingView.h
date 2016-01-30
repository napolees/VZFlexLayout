//
//  VZFNodeHostingView.h
//  VZFlexLayout
//
//  Created by moxin on 16/1/28.
//  Copyright © 2016年 Vizlab. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VZFNode;
@protocol VZFNodeProviderInterface <NSObject>

+ (VZFNode *)nodeForItem:(id<NSObject>)item context:(id<NSObject>)context;

@end

@interface VZFNodeHostingView : UIView

- (id)initWithNodeProvider:(Class<VZFNodeProviderInterface>)provider;

@end