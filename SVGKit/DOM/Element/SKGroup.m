//
//  SKGroup.m
//  SVGKit
//
//  Created by Eric Man on 10/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import "SKGroup.h"
#import "SVGKit+DOM.h"
#import "SKRoot.h"

@implementation SKGroup
@synthesize transform = _transform;

- (id) initWithXMLElement:(NSXMLElement *)element
{
    self = [super initWithXMLElement:element];
    if (self) {
        _transform = [[self transformArrayForName:@"transform"] retain];
    }
    return self;
}

- (void)dealloc
{
    [_transform release];
    [super dealloc];
}

- (void)setTransform:(NSArray *)value {
    [self setValue:[_transform = [value retain] description]
           forName:@"transform"];
}

#if 0
#pragma mark --- SKNode ---
#endif

+ (NSString *)name
{
    return @"g";
}

- (SKDocument *)rootDocument
{
    return [[self parent] rootDocument];
}

@end

