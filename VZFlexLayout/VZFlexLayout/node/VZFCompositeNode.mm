//
//  VZFCompositeNode.m
//  VZFlexLayout
//
//  Created by moxin on 16/2/17.
//  Copyright © 2016年 Vizlab. All rights reserved.
//

#import "VZFCompositeNode.h"
#import "VZFMacros.h"
#import "VZFNodeInternal.h"
#import "VZFNodeLayout.h"
#import "VZFNodeViewClass.h"
#import "VZFNodeLayout.h"
#import "VZFNodeSpecs.h"

using namespace VZ;
@implementation VZFCompositeNode
{
}


- (VZFlexNode* )flexNode{
    return _node.flexNode;
}

+ (instancetype)newWithView:(const ViewClass &)viewClass NodeSpecs:(const NodeSpecs &)specs{
    VZ_NOT_DESIGNATED_INITIALIZER();
}

+ (instancetype)newWithNode:(VZFNode *)node{

    if (!node) {
        return nil;
    }
    

    
    VZFCompositeNode* compositeNode = [super newWithView:{} NodeSpecs:{}];
    if (compositeNode) {
        compositeNode -> _node = node;

    }
    return compositeNode;
}

/**
 * @discussion: Composite Node同样参与Node🌲的构建
 */
- (NodeLayout)computeLayoutThatFits:(CGSize)sz{

//    return [_node computeLayoutThatFits:sz];
    NodeLayout layout = [_node computeLayoutThatFits:sz];
    return {self,layout.size,layout.origin,layout.margin, {{_node,layout.size,layout.origin,layout.margin,*layout.children}}};
}


@end
