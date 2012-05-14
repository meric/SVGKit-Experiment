//
//  SKElement.m
//  SVGKit
//
//  Created by Eric Man on 5/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import "SKElement.h"
#import "SKRoot.h"
#import "SVGKit+DOM.h"

@implementation SKElement

- (id) init
{
    self = [super init];
    
    if (self)  {
        _element = [[NSXMLElement alloc] initWithName:[[self class] name]];
        _children = [[NSMutableArray alloc] init];
        _attributes = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) dealloc
{
    [_element release];
    [_children release];
    [_attributes release];
    [super dealloc];
}

- (NSString*)name 
{
    return [[self class] name];
}

+ (NSString *)name
{
    return @"";
}

+ (Class)classForName:(NSString*)name
{
    static NSDictionary* classDict =  nil;
    
    if (classDict == nil)
    {
        classDict = [NSDictionary dictionaryWithObjectsAndKeys:
                     @"svg", [SKRoot class]
                     , nil];
    }
    Class SKElementClass = [classDict objectForKey:name];
    if (SKElementClass == nil)
    {
        SKWarn(@"unrecognized SVG XML element %@", name);
        SKElementClass = [SKElement class];
    }
    return SKElementClass;
}

- (id) initWithXMLElement:(NSXMLElement *)element
{
    self = [super init];
    
    if (self) {
        _element = [element retain];
        _children = [[NSMutableArray alloc] init];
        _attributes = [[NSMutableDictionary alloc] init];
        for (NSXMLElement *xmlElement in _element.children) {
            Class SKElementClass = [SKElement classForName:xmlElement.name];
            SKElement *svgElement = [[SKElementClass alloc] 
                                     initWithXMLElement:xmlElement];
            [_children addObject:svgElement];
            [svgElement release];
        }
    }
    
    return self;
}

- (NSXMLElement *)element
{
    return _element;
}

- (void)addedToParent:(SKElement *)parent atIndex:(NSUInteger)index
{
    _parent = parent;
    _index = index;
}

- (void)removedFromParent
{
    _parent = nil;
    _index = 0;
}

- (void)setValue:(NSString *)value forName:(NSString*)name;
{
    NSAssert(name != nil, 
             @"setValue:forName: name cannot be nil");
    [_element removeAttributeForName:name];
    if (value && [value length] > 0) {
        [_element addAttribute:
         [NSXMLNode attributeWithName:name stringValue:value]];
        return;
    }
}

// Get string from attribute

- (NSString*)stringForName:(NSString*)attributeName {
    NSXMLNode *node = [_element attributeForName:attributeName];
    if (node) return [node stringValue];
    return nil;
}

#if 0
#pragma mark --- SKNode ---
#endif

- (NSString *)description
{
    return [_element XMLString];
}

- (NSString *)XMLString
{
    return [_element XMLString];
}


#if 0
#pragma mark --- Attributes ---
#endif

/*!
 @method setAttributes:
 @abstract Set the attributes. (Drop all current attributes)
 */
- (void)setAttributes:(NSDictionary *)attributes {
    for (NSString* name in [_attributes allKeys]) {
        [_element removeAttributeForName:name];
    }
    [_attributes release];
    _attributes = [[attributes mutableCopy] retain];
    for (NSString* name in [_attributes allKeys]) {
        [_element removeAttributeForName:name];
        [_element addAttribute:[NSXMLNode attributeWithName:name 
                                                stringValue:
                                [[_attributes objectForKey:name] description]]];
    }
}

/*!
 @method attributes
 @abstract The attributes.
 */
- (NSDictionary *)attributes {
    return _attributes;
}

/*!
 @method setAttribute:forName:
 @abstract Set the attribute for this name.
 */
- (void)setAttribute:(id)attribute forName:(NSString *)name {
    assert(attribute);
    if ([_attributes objectForKey:name]) {
        [_element removeAttributeForName:name];
    }
    [_element addAttribute:[NSXMLNode attributeWithName:name 
                                            stringValue:
                            [attribute description]]];
    [_attributes setObject:attribute forKey:name];
}


/*!
 @method attributeForName:
 @abstract Returns an attribute matching this name.
 */
- (id)attributeForName:(NSString *)name {
    return [_attributes objectForKey:name];
}

#if 0
#pragma mark --- Children ---
#endif

- (void)insertChild:(SKElement *)child atIndex:(NSUInteger)index
{
    [_children insertObject:child atIndex:index];
    [_element insertChild:[child element] atIndex:index];
    [child addedToParent:self atIndex:index];
}

- (void)insertChildren:(NSArray *)children atIndex:(NSUInteger)index
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:
                            NSMakeRange(index, [children count])];
    [_children insertObjects:children atIndexes:indexSet];
    NSMutableArray *elements = [[NSMutableArray alloc] 
                                initWithCapacity:[children count]];
    for (SKElement *element in children)
    {
        [element addedToParent:self atIndex:index+[elements count]];
        [elements addObject:[element element]];
    }
    [_element insertChildren:elements atIndex:index];
    [elements release];
}

- (void)removeChildAtIndex:(NSUInteger)index;
{
    if (index >= [_children count]) {
        [NSException raise:@"index out of range" 
                    format:@"index %d is out of range", index];
    }
    [[_children objectAtIndex:index] removedFromParent];
    [_children removeObjectAtIndex:index];
    [_element removeChildAtIndex:index];
}

- (void)setChildren:(NSArray *)children
{
    for (SKElement *child in _children) {
        [child removedFromParent];
    }
    [_children removeAllObjects];
    _children = [children mutableCopy];
    NSMutableArray *elements = 
        [[NSMutableArray alloc] initWithCapacity:[children count]];
    for (SKElement *element in children)
    {
        [elements addObject:[element element]];
    }
    [_element setChildren:children];
    [elements release];
}

- (void)addChild:(SKElement *)child
{
    [_children addObject:child];
    [_element addChild:[child element]];
}

- (void)replaceChildAtIndex:(NSUInteger)index withElement:(SKElement *)node
{
    if (index >= [_children count]) {
        [NSException raise:@"index out of range" 
                    format:@"index %d is out of range", index];
    }
    [[_children objectAtIndex:index] removedFromParent];
    [_children replaceObjectAtIndex:index withObject:node];
    [_element replaceChildAtIndex:index withNode:[node element]];
}

#if 0
#pragma mark --- Tree Navigation ---
#endif

- (NSUInteger)index
{
    return _index;
}

/*!
 @method rootDocument
 @abstract The encompassing document or nil.
 */
- (SKDocument *)rootDocument
{
    if (_parent != nil) {
        return [_parent rootDocument];
    }
    return nil;
}

- (SKElement *)parent
{
    return _parent;
}

- (NSUInteger)childCount
{
    return [_children count];
}

- (NSArray *)children
{
    return [_children copy];
}

- (SKElement *)childAtIndex:(NSUInteger)index
{
    return [_children objectAtIndex:index];
}

- (SKElement *)previousSibling
{
    if (_parent) {
        if (_index > 0) {
            return [_parent childAtIndex:_index-1];
        }
    }
    return nil;
}

- (SKElement *)nextSibling
{
    if (_parent) {
        if (_index < [_parent childCount]) {
            return [_parent childAtIndex:_index+1];
        }
    }
    return nil;
}

- (void)detach
{
    if (_parent) [_parent removeChildAtIndex:_index];
}

@end
