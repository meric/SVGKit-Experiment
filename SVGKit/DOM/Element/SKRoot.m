//
//  SKRoot.m
//  SVGKit
//
//  Created by Eric Man on 5/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import "SKRoot.h"
#import "SVGKit+DOM.h"
#import </usr/include/objc/objc-class.h>


@implementation SKRoot

SKCoreAttrib__implementation();
SKDocumentEventAttrib__implementation();
SKGraphicalEventAttrib__implementation();
SKConditionalProcessingAttrib__implementation();
SKPresentationAttrib__implementation();

- (id)initWithXMLElement:(NSXMLElement *)element
{
    self = [super initWithXMLElement:element];
    if (self) {
        SKCoreAttrib__initialize();
        SKDocumentEventAttrib__initialize();
        SKGraphicalEventAttrib__initialize();
        SKConditionalProcessingAttrib__initialize();
        SKPresentationAttrib__initialize();
        
        //SKAttribute__initWithDefault(@"contentScriptType",
         //                            @"application/ecmascript");
        //SKAttribute__initWithDefault(@"contentStyleType",
        //                             @"text/css");
        //SKAttribute__init(@"version");
        //SKAttribute__initWithDefault(@"baseProfile", @"none");
        SKAttribute__init(@"width");
        SKAttribute__init(@"height");
        SKAttribute__init(@"x");
        SKAttribute__init(@"y");
//        SKAttribute__init(@"viewBox");
//        SKAttribute__init(@"preserveAspectRatio");
//        SKAttribute__init(@"class");
//        SKAttribute__init(@"zoomAndPan");
    }
    return self;
}

#if 0
#pragma mark --- Attribute Accessors ---
#endif

//SKAttribute__accessor(contentScriptType, setContentScriptType, NSString*,
//                      @"contentScriptType");
//SKAttribute__accessor(contentStyleType, setContentStyleType, NSString*, 
//                      @"contentStyleType");
//SKAttribute__accessor(baseProfile, setBaseProfile, NSString*, @"baseProfile");
//SKAttribute__accessor(version, setVersion, NSString*, @"version");

SKAttribute__accessor(width, setWidth, SKLength*, @"width");
SKAttribute__accessor(height, setHeight, SKLength*, @"height");

SKAttribute__accessor(x, setX, SKLength*, @"x");
SKAttribute__accessor(y, setY, SKLength*, @"y");
//SKAttribute__arrayAccessor(viewbox, setViewbox, @"viewBox", @",");
//SKAttribute__accessor(preserveAspectRatio, setPreserveAspectRatio, 
//                      SKPreserveAspectRatio*, @"preserveAspectRatio");
//SKAttribute__arrayAccessor(classes, setClasses, @"class", @" ");
//SKAttribute__enumAccessor(zoomAndPan, setZoomAndPan, SKLiteral, @"zoomAndPan"
//                          ,SKLiteralString);

#if 0
#pragma mark --- SKNode ---
#endif

+ (NSString *)name
{
    return @"svg";
}

- (SKDocument *)rootDocument
{
    return _document;
}

@end
