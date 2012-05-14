//
//  SKRoot.h
//  SVGKit
//
//  Created by Eric Man on 5/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import "SVGKit.h"
#import "SKElement.h"
#import "SKAttrib.h"

@class SKDocument, SKLength;

@interface SKRoot : SKElement
{
    SKDocument *_document;
}

#if 0
#pragma mark --- Attribute Properties ---
#endif

// SVG Element
// http://www.w3.org/TR/SVG11/struct.html#SVGElement

SKCoreAttrib__interface();
SKDocumentEventAttrib__interface();
SKGraphicalEventAttrib__interface();
SKConditionalProcessingAttrib__interface();
SKPresentationAttrib__interface();

SKAttribute__property(SKLength, *width, *height, *x, *y);
//SKAttribute__property(NSString, *version, *baseProfile);
//SKAttribute__property(NSString, *contentScriptType, *contentStyleType);
//SKAttribute__property(SKLength, *width, *height, *x, *y);
//SKAttribute__property(NSArray, *viewbox, *classes);
//SKAttribute__property(SKPreserveAspectRatio, *preserveAspectRatio);
//SKAttribute__property(SKLiteral, zoomAndPan);

@end


