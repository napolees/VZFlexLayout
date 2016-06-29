//
//  VZFNodeInternal.h
//  VZFlexLayout
//
//  Created by moxin on 16/2/4.
//  Copyright © 2016年 Vizlab. All rights reserved.
//

#ifndef VZFNodeInternal_h
#define VZFNodeInternal_h

#import <UIKit/UIKit.h>
#import "VZFNode.h"
#import "VZFStateUpdateMode.h"


/**
 *  前项声明
 */
namespace VZ {
    class NodeLayout;
    class ViewClass;
    class NodeSpecs;
    namespace UIKit{
        class MountContext;
        class MountResult;
    }
}

using namespace VZ;

@class VZFlexNode;
@class VZFNodeController;
@class VZFNodeHostingView;

@interface VZFNode()

/**
 *  Node对应到UIKit的类型
 */
@property(nonatomic,assign,readonly)ViewClass viewClass;
/**
 *  Node的描述文件
 */
@property(nonatomic,assign,readonly)NodeSpecs specs;

/**
 *  内部引用的Objective-C类型的node
 */
@property(nonatomic,strong,readonly)VZFlexNode* flexNode;
/**
 *  node的父节点
 */
@property(nonatomic,weak)VZFNode* superNode;

//@property(nonatomic,weak)UIView* backingView;
/**
 *  root view
 */
@property(nonatomic,weak)UIView* rootNodeView;

/**
 *  Node的初始状态
 *
 *  @return state
 */
+ (id)initialState;

/**
 *  更新状态，(old) -> (new)
 *
 *  @param updateBlock
 */
- (void)updateState:(id(^)(id))updateBlock Mode:(VZFActionUpdateMode)mode;

/**
 *  计算Node的layout
 *
 *  @param sz
 *
 *  @return
 */
- (NodeLayout)computeLayoutThatFits:(CGSize)sz;

@end

@interface VZFNode(Layout)

- (BOOL)shouldMemoizeLayout;

- (NodeLayout)nodeDidLayout;

@end


@interface VZFNode(ResponderChain)

/**
 *  返回controller的下一个responder
 *
 *  @return object
 */
- (id)nextResponderAfterController;
/**
 *  response响应事件的方法
 *
 *  @param action 事件名
 *  @param sender sender
 *
 *  @return object
 */
- (id)targetForAction:(SEL)action withSender:(id)sender;

@end


@interface VZFNode(Mounting)
/**
 *  加载一个Node
 *
 *  @param size       node的size
 *  @param parentNode 父节点
 *
 *  @return 加载结果
 */
-(VZ::UIKit::MountResult)mountInContext:(const VZ::UIKit::MountContext &)context
                                   Size:(CGSize) size
                             ParentNode:(VZFNode* )parentNode;
-(void)unmount;
-(void)willMount;
-(void)didMount;

@end

@interface VZFNode(Controller)

- (VZFNodeController* )controller;

@end
#endif /* VZFNodeInternal_h */
