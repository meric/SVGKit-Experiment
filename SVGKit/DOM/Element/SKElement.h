//
//  SKElement.h
//  SVGKit
//
//  Created by Eric Man on 5/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNode.h"

@class SKDocument;

@interface SKElement : NSObject <SKNode>
{
    NSXMLElement *_element;
    SKElement *_parent;
    NSUInteger _index;
    NSMutableArray *_children;
    NSMutableDictionary *_attributes;
}

@property (readonly) NSString* name;

#if 0
#pragma mark --- Attributes ---
#endif

/*!
 @method setAttributes:
 @abstract Set the attributes.
 */
- (void)setAttributes:(NSDictionary *)attributes;

/*!
 @method attributes
 @abstract The attributes.
 */
- (NSDictionary *)attributes;

/*!
 @method setAttribute:forName:
 @abstract Set the attribute for this name.
 */
- (void)setAttribute:(id)attribute forName:(NSString *)name;


/*!
 @method attributeForName:
 @abstract Returns an attribute matching this name.
 */
- (id)attributeForName:(NSString *)name;

#if 0
#pragma mark --- Children ---
#endif

/*!
 @method insertChild:atIndex:
 @abstract Inserts a child at a particular index.
 */
- (void)insertChild:(SKElement *)child atIndex:(NSUInteger)index; //primitive

/*!
 @method insertChildren:atIndex:
 @abstract Insert several children at a particular index.
 */
- (void)insertChildren:(NSArray *)children atIndex:(NSUInteger)index;

/*!
 @method removeChildAtIndex:atIndex:
 @abstract Removes a child at a particular index.
 */
- (void)removeChildAtIndex:(NSUInteger)index; //primitive

/*!
 @method setChildren:
 @abstract Removes all existing children and replaces them with the new children. Set children to nil to simply remove all children.
 */
- (void)setChildren:(NSArray *)children; //primitive

/*!
 @method addChild:
 @abstract Adds a child to the end of the existing children.
 */
- (void)addChild:(SKElement *)child;

/*!
 @method replaceChildAtIndex:withNode:
 @abstract Replaces a child at a particular index with another child.
 */
- (void)replaceChildAtIndex:(NSUInteger)index withElement:(SKElement *)node;


#if 0
#pragma mark --- Tree Navigation ---
#endif

/*!
 @method index
 @abstract A node's index amongst its siblings.
 */
- (NSUInteger)index; //primitive

/*!
 @method rootDocument
 @abstract The encompassing document or nil.
 */
- (SKDocument *)rootDocument;

/*!
 @method parent
 @abstract The parent of this node. Documents and standalone Nodes have a nil parent; there is not a 1-to-1 relationship between parent and children, eg a namespace cannot be a child but has a parent element.
 */
- (SKElement *)parent; //primitive

/*!
 @method childCount
 @abstract The amount of children, relevant for documents, elements, and document type declarations. Use this instead of [[self children] count].
 */
- (NSUInteger)childCount; //primitive

/*!
 @method children
 @abstract An immutable array of child nodes. Relevant for documents, elements, and document type declarations.
 */
- (NSArray *)children; //primitive

/*!
 @method childAtIndex:
 @abstract Returns the child node at a particular index.
 */
- (SKElement *)childAtIndex:(NSUInteger)index; //primitive

/*!
 @method previousSibling:
 @abstract Returns the previous sibling, or nil if there isn't one.
 */
- (SKElement *)previousSibling;

/*!
 @method nextSibling:
 @abstract Returns the next sibling, or nil if there isn't one.
 */
- (SKElement *)nextSibling;

/*!
 @method detach:
 @abstract Detaches this node from its parent.
 */
- (void)detach; //primitive

@end
