//
//  VZFNodeViewManager.m
//  VZFlexLayout
//
//  Created by moxin on 16/1/30.
//  Copyright © 2016年 Vizlab. All rights reserved.
//

#import "VZFNodeViewManager.h"
#import "VZFGestureForward.h"
#import "VZFNode.h"
#import "VZFStackNode.h"
@implementation VZFNodeViewManager
{

}

+ (UIView* )viewForStackNode:(VZFStackNode *)node withStackLayoutSpec:(const VZFNodeLayout &)stackLayout{
    
    if (![[node class] isKindOfClass : [VZFStackNode class] ]) {
        return nil;
    }
    
//    VZFStackLayout layout = node.layout;
    UIView* stackView = [UIView new];
    stackView.backgroundColor = [UIColor clearColor];
    //apply stack view layout
    stackView.frame.origin = stackLayout.getNodeOriginPoint();
    stackView.frame.size = stackLayout.getNodeSize();

    for (int i = 0; i < node.children.size(); i++) {
        
        VZFStackChildNode childNode = node.children[i];
        VZFNode* node = childNode.node;
        VZFNodeLayout layout = stackLayout.getChildren()[i];
        if ([node isKindOfClass:[VZFStackNode class]]) {
            [self viewForStackNode:(VZFStackNode* )node withStackLayoutSpec:layout];
        }
        UIView* view = [self viewForNode:node withLayoutSpec:layout];
        [stackView addSubview:view];
    }
    return stackView;
}

+ (UIView* )viewForNode:(VZFNode *)node withLayoutSpec:(const VZFNodeLayout &)layout{
    
    const VZ::UISpecs specs = node.specs;
    std::shared_ptr<const VZUISpecs> spec = specs.getSpecs();
    VZ::ViewClass viewClass = (*spec.get()).clz;
    UIView* view = viewClass.createView();
    VZ::ViewAttrs vs = (*spec.get()).view;
    
    //apply view attributes
    view.backgroundColor = vs.backgroundColor;
    view.contentMode = vs.contentMode;
    view.clipsToBounds = vs.clipToBounds;
    view.layer.cornerRadius = vs.layer.cornerRadius;
    view.layer.borderColor = vs.layer.borderColor.CGColor;
    view.layer.contents = (__bridge id)vs.layer.contents.CGImage;
    
    //apply layout result
    view.frame.size = layout.getNodeSize();
    view.frame.origin = layout.getNodeOriginPoint();
    
    //apply gestures
    std::set<Gesture> gestures = (*spec.get()).gestures;
    VZFGestureForward* gestureForward = node.gestureForward;
    if (!gestureForward) {
        VZFGestureForward* gestureForward = [VZFGestureForward new];
        node.gestureForward = gestureForward;
    }
    for (auto g : gestures) {
        
        UIGestureRecognizer* gesture = g.getGestureRecognizer();
        gesture_callback_t callback = g.getGestureCallback();
        [node.gestureForward addGestureWithType:NSStringFromClass([gesture class]) Callback:callback];
        [gesture addTarget:node.gestureForward action:@selector(action:)];
        [view addGestureRecognizer:gesture];
    }
    
    return view;
}


@end