//
//  SKDocument.m
//  SVGKit
//
//  Created by Eric Man on 5/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import "SKDocument.h"
#import "SKElement+DOM.h"
#import "SKRoot.h"

@implementation SKDocument

- (id)init
{
    self = [super init];
    if (self) {
        _document = [[NSXMLDocument alloc] init];
        _root = [[SKRoot alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_document release];
    [_root release];
    [super dealloc];
}

- (id)initWithXMLDocument:(NSXMLDocument *)document error:(NSError **)error
{
    if (!document) return nil;
    self = [super init];
    if (self) {
        _document = [document retain];
        NSXMLElement *element = _document.rootElement;
        if ([element.name compare:@"svg"] == NSEqualToComparison) {
            _root = [[SKRoot alloc] initWithXMLElement:element];
        }
        else {
            if (error) {
                NSString *description = @"element name is not \"svg\"";
                NSDictionary* details = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
                *error = [NSError errorWithDomain:@"svg" code:200 userInfo:details];
            } 
            return nil;
        }
    }
    return self;
}

- (id)initWithSVGString:(NSString *)string error:(NSError **)error
{
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithXMLString:string options:0 error:error];
    self = [self initWithXMLDocument:document error:error];
    [document release];
    return self;
}

- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)error
{
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:error];
    self = [self initWithXMLDocument:document error:error];
    [document release];
    return self;
}

- (id)initWithData:(NSData *)data error:(NSError **)error
{
    NSXMLDocument *document = [[NSXMLDocument alloc] initWithData:data options:0 error:error];
    self = [self initWithXMLDocument:document error:error];
    [document release];
    return self;
}

- (id)initWithRoot:(SKRoot *)root
{
    self = [self init];
    if (self) {
        _root = [root retain];
    }
    return self;
}

#if 0
#pragma mark --- SKNode ---
#endif

+ (NSString *)name
{
    return @"";
}

- (NSString *)description
{
    return [_document XMLString];
}

- (NSString *)XMLString
{
    return [_document XMLString];
}


#if 0
#pragma mark --- Properties ---
#endif

- (void)setRoot:(SKRoot *)root
{
    [_root release];
    _root = [root retain];
}

- (SKRoot *)root
{
    return _root;
}

- (NSXMLDocument *) document 
{
    return [_document copy];
}

#if 0
#pragma mark --- Output ---
#endif

- (NSData *)SVGData
{
    return [_document XMLData];
}

@end
