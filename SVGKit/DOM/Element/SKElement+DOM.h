//
//  SKElement+DOM.h
//  SVGKit
//
//  Created by Eric Man on 5/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

// SKElement+DOM.h package-wide interface

#import <Foundation/Foundation.h>
#import "SKElement.h"
#import "SVGKit+DOM.h"
#import "SVGKit+Attribute.h"
#import </usr/include/objc/objc-class.h>

@class SKLength, SKPreserveAspectRatio;


@interface SKElement (SKDOM) // interface available to package only
- (id) initWithXMLElement:(NSXMLElement *)element;
- (NSXMLElement *)element;
- (void)addedToParent:(SKElement *)parent atIndex:(NSUInteger)index;
- (void)removedFromParent;
- (void)setValue:(NSString *)value forName:(NSString*)name;
- (NSString*)stringForName:(NSString*)attributeName;
- (SKLength*)lengthForName:(NSString*)attributeName;
- (NSArray*)transformArrayForName:(NSString*)attributeName;
- (NSArray*)lengthArrayForName:(NSString*)attributeName;
- (SKPreserveAspectRatio*)preserveAspectRatioForName:(NSString*)attributeName;
- (NSArray*)stringArrayForName:(NSString*)attributeName;
- (NSArray*)classArrayForName:(NSString*)attributeName;
- (SKLiteral)literalForName:(NSString*)attributeName;
- (SKColor*)colorForName:(NSString*)attributeName;
- (NSNumber*)numberForName:(NSString*)attributeName;

@end

/*
 This is a domain specific language for adding SVG XML attributes to data model.
 See SKCoreAttrib.h and SKRoot.h and SKRoot.m for example usage.
 */
#define SKAttribute__property(type, ...) \
@property (assign) type __VA_ARGS__

#define SKAttribute__init(name) SKAttribute__initWithDefault(name,nil)

#define SKAttribute__initWithDefault(name, default) \
{   NSNumber *number = [scannerForAttribute objectForKey:name]; \
    void* (*call)(NSScanner*,void*) = (void*)(number.unsignedLongValue);\
    NSString* string =  [self stringForName:name]; \
    id val = default; \
    if(string) {\
        NSScanner *scanner = [NSScanner scannerWithString:string];\
        if (!call) SKWarn(@"Attribute handler not found %@", name);\
        call(scanner, &val);\
    }\
    if (val) [_attributes setObject:val forKey:name];\
}

#define SKAttribute__set(name)\
[_attributes setObject:val forKey:name];\
[self setValue:[val description] forName:name]

#define SKAttribute__arraySet(name, sep)\
[_attributes setObject:val forKey:name];\
[self setValue:[val componentsJoinedByString:sep] forName:name]

#define SKAttribute__enumSet(name, names)\
[_attributes setObject:(id)val forKey:name];\
[self setValue:names[val] forName:name]

#define SKAttribute__setter(setter, type, name)\
- (void)setter:(type)val{SKAttribute__set(name);}

#define SKAttribute__arraySetter(setter, name, sep)\
- (void)setter:(NSArray*)val{SKAttribute__arraySet(name, sep);}

#define SKAttribute__enumSetter(setter, type, name, names)\
- (void)setter:(type)val{SKAttribute__enumSet(name, names);}

#define SKAttribute__getter(getter, type, name)\
- (type)getter{ return (type)[_attributes objectForKey:name]; }

#define SKAttribute__accessor(getter, setter, type, name) \
SKAttribute__getter(getter, type, name);\
SKAttribute__setter(setter, type, name);

#define SKAttribute__arrayAccessor(getter, setter, name, sep) \
SKAttribute__getter(getter, NSArray*, name);\
SKAttribute__arraySetter(setter, name, sep);

#define SKAttribute__enumAccessor(getter, setter, type, name, names) \
SKAttribute__getter(getter, type, name);\
SKAttribute__enumSetter(setter, type, name, names);
