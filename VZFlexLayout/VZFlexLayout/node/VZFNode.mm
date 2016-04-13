//
//  VZFNode.m
//  VZFlexLayout
//
//  Created by moxin on 16/1/26.
//  Copyright © 2016年 Vizlab. All rights reserved.
//

#import "VZFNode.h"
#import "VZFUtils.h"
#import "VZFMacros.h"
#import "VZFlexNode.h"
#import "VZFNodeLayout.h"
#import "VZFNodeInternal.h"
#import "VZFScopeHandler.h"
#import "VZFScopeManager.h"
#import "VZFNodeController.h"
#import "VZFlexNode+VZFNode.h"
#import "VZFNodeMountContext.h"
#import "VZFNodeViewManager.h"
#import "VZFNodeMountContext.h"
#import "VZFNodeControllerInternal.h"
#import "VZFNodeAttributeApplicator.h"
#import "VZFNodeSpecs.h"
#import "VZFNodeViewClass.h"

struct VZFNodeMountedInfo{
    
    VZFNode* parentNode;
    UIView* mountedView;
    CGRect mountedFrame;
};


using namespace VZ;
using namespace VZ::UIKit;

@implementation VZFNode
{
    VZFScopeHandler* _scopeHandler;
    std::unique_ptr<VZFNodeMountedInfo> _mountedInfo;
}

+ (id)initialState{
    return nil;
}

+ (instancetype)newWithView:(const ViewClass &)viewclass NodeSpecs:(const NodeSpecs &)specs{

    return [[self alloc] initWithView: viewclass Specs:specs];
}

+ (instancetype)new
{
    return [self newWithView:[UIView class] NodeSpecs:{}];
}

- (instancetype)initWithView:(const ViewClass& )viewclass Specs:(const NodeSpecs& )specs{
    self = [super init];
    if (self) {
        
        _specs = specs;
        _viewClass = viewclass;
        _flexNode = [VZFNodeUISpecs flexNodeWithAttributes:_specs.flex];
        _flexNode.name = [NSString stringWithUTF8String:specs.identifier.c_str()];
        _scopeHandler = [VZFScopeHandler scopeHandlerForNode:self];
        _flexNode.fNode = self;

    }
    return self;
}

- (instancetype)init
{
    VZ_NOT_DESIGNATED_INITIALIZER();
}

- (void)dealloc{

    NSLog(@"[%@]-->dealloc",self.class);
    _flexNode.fNode = nil;
}


- (void)updateState:(id (^)(id))updateBlock{
    [_scopeHandler updateState:updateBlock];
}


- (NodeLayout)computeLayoutThatFits:(CGSize)sz{
    
    [_flexNode layout:sz];
    NodeLayout layout = { self,
                             _flexNode.resultFrame.size,
                             _flexNode.resultFrame.origin,
                             _flexNode.resultMargin};
    return layout;
}


- (NSString *)description {
    
    NSString* className = NSStringFromClass([self class]);
    return [[NSString alloc] initWithFormat:@"Class:{%@} \nLayout:{%@\n}",className,self.flexNode.description];
}

- (VZFNode* )superNode{
    return _mountedInfo -> parentNode;
}

- (id)nextResponder {
    return _scopeHandler.controller ?: [self nextResponderAfterController];
}

- (id)nextResponderAfterController
{
    VZFNode* superNode = [self superNode];
    return (superNode?:nil)?:self.rootNodeView;
}

- (id)targetForAction:(SEL)action withSender:(id)sender
{
    return [self respondsToSelector:action] ? self : [[self nextResponder] targetForAction:action withSender:sender];
}

- (VZFNodeController* )controller {
    return _scopeHandler.controller;
}

-(VZ::UIKit::MountResult)mountInContext:(const VZ::UIKit::MountContext &)context Size:(CGSize) size ParentNode:(VZFNode* )parentNode
{    
    if (!_mountedInfo) {
        _mountedInfo.reset( new VZFNodeMountedInfo() );
    }
    
    _mountedInfo -> parentNode =  parentNode;
    
    //获取一个reuse view
    UIView* view = [context.viewManager viewForNode:self];
    
    //说明reusepool中有view
    if (view) {
        //不是当前的backingview
        if (view != _mountedInfo -> mountedView) {
            
            //如果获取
            [self _recycleMountedView];
            [view.node unmount];
            view.node = self;

            //apply attributes
            [VZFNodeAttributeApplicator applyNodeAttributes:self toView:view];
            [self.controller node:self didAquireBackingView:view];
            _mountedInfo -> mountedView = view;
        }
        else{
            VZFAssert(view.node == self, @"");
        }

        //计算公式:
        //position.x = frame.origin.x + anchorPoint.x * bounds.size.width；
        //position.y = frame.origin.y + anchorPoint.y * bounds.size.height；
        const CGPoint anchorPoint = view.layer.anchorPoint;
        view.center = context.position + CGPoint({anchorPoint.x * size.width, anchorPoint.y * size.height});
        view.bounds = {view.bounds.origin,size};

        _mountedInfo -> mountedFrame = {context.position, view.bounds.size};
        
        return {.hasChildren = YES, .childContext = context.childContextForSubview(view)};
        

    }
    else{
        //reuse Pool中没有,则使用viewManager中保存的view
        UIView* view = context.viewManager.managedView;
        _mountedInfo -> mountedView = view;
        _mountedInfo -> mountedFrame = {context.position,size};
        
        return {.hasChildren = YES, .childContext = context};
        
    }
    

}


-(void)unmount{
    
    if (_mountedInfo != nullptr) {
        [self.controller nodeWillUnmount:self];
        [self _recycleMountedView];
        _mountedInfo.reset();
        [self.controller nodeDidUnmount:self];
    }

}

-(void)didMount{
    
    [[self controller] nodeDidMount:self];
}

-(void)willMount{
    
    [[self controller] nodeWillMount:self];
    
}


- (void)_recycleMountedView{
    
    UIView* view = _mountedInfo -> mountedView;
    if(view){
        [_scopeHandler.controller node:self willReleaseBackingView:view];
        view.node = nil;
        _mountedInfo -> mountedView = nil;
    }

    

    
}
@end
