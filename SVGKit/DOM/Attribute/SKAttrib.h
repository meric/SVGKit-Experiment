//
//  SKCoreAttrib.h
//  SVGKit
//
//  Created by Eric Man on 10/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKElement+DOM.h"

// See SKRoot.h and SKRoot.m for example on how to use these attribute sets.

// Core attributes
// http://www.w3.org/TR/SVG11/intro.html#TermCoreAttributes

/*
 Core attributes notes
 =====================
 
 id: Not checked for uniqueness. Saved to string only.
 xml:lang: Currently ignored; Saved to string only.
 xml:space: Currently ignored; Saved to string only.
 
 */

#define SKCoreAttrib__interface() \
SKAttribute__property(NSString, *identifier, *xmlLang, *xmlSpace)

#define SKCoreAttrib__implementation() \
SKAttribute__accessor(identifier, setIdentifier, NSString*, @"id"); \
SKAttribute__accessor(xmlLang, setXmlLang, NSString*, @"xml:lang"); \
SKAttribute__accessor(xmlSpace, setXmlSpace, NSString*, @"xml:space")

#define SKCoreAttrib__initialize() \
SKAttribute__init(@"id"); \
SKAttribute__init(@"xml:lang"); \
SKAttribute__init(@"xml:space")

// Document Event attributes
// http://www.w3.org/TR/SVG11/intro.html#TermDocumentEventAttribute

/*
 Document Event attributes notes
 ===============================
 
 *:  Currently ignored; Saved to string only.
 
 */

#define SKDocumentEventAttrib__interface() \
SKAttribute__property(NSString, *onAbort, *onError, *onResize, *onScroll, \
                                *onUnload, *onZoom)

#define SKDocumentEventAttrib__implementation() \
SKAttribute__accessor(onAbort, setOnAbort, NSString*, @"onabort"); \
SKAttribute__accessor(onError, setOnError, NSString*, @"onerror"); \
SKAttribute__accessor(onResize, setOnResize, NSString*, @"onresize"); \
SKAttribute__accessor(onScroll, setOnScroll, NSString*, @"onscroll"); \
SKAttribute__accessor(onUnload, setOnUnload, NSString*, @"onunload"); \
SKAttribute__accessor(onZoom, setOnZoom, NSString*, @"onzoom"); \

#define SKDocumentEventAttrib__initialize() \
SKAttribute__init(@"onabort"); \
SKAttribute__init(@"onerror"); \
SKAttribute__init(@"onresize") \
SKAttribute__init(@"onscroll"); \
SKAttribute__init(@"onunload"); \
SKAttribute__init(@"onzoom")

// Graphical Event attributes
// http://www.w3.org/TR/SVG11/intro.html#TermGraphicalEventAttribute

/*
 Graphical Event attributes notes
 ================================
 
 *:  Currently ignored; Saved to string only.
 
 */

#define SKGraphicalEventAttrib__interface() \
SKAttribute__property(NSString, *onActivate, *onClick, *onFocusIn, *onFocusOut,\
                                *onLoad, *onMouseDown, *onMouseMove,\
                                *onMouseOut, *onMouseOver, *onMouseUp)


#define SKGraphicalEventAttrib__implementation() \
SKAttribute__accessor(onActivate, setOnActivate, NSString*, @"onactivate"); \
SKAttribute__accessor(onClick, setOnClick, NSString*, @"onclick"); \
SKAttribute__accessor(onFocusIn, setOnFocusIn, NSString*, @"onfocusin"); \
SKAttribute__accessor(onFocusOut, setOnFocusOut, NSString*, @"onfocusout"); \
SKAttribute__accessor(onLoad, setOnLoad, NSString*, @"onload"); \
SKAttribute__accessor(onMouseDown, setOnMouseDown, NSString*, @"onmousedown"); \
SKAttribute__accessor(onMouseMove, setOnMouseMove, NSString*, @"onmousemove"); \
SKAttribute__accessor(onMouseOut, setOnMouseOut, NSString*, @"onmouseout"); \
SKAttribute__accessor(onMouseOver, setOnMouseOver, NSString*, @"onmouseover"); \
SKAttribute__accessor(onMouseUp, setOnMouseUp, NSString*, @"onmouseup")

#define SKGraphicalEventAttrib__initialize() \
SKAttribute__init(@"onactivate"); \
SKAttribute__init(@"onclick"); \
SKAttribute__init(@"onfocusin") \
SKAttribute__init(@"onfocusout"); \
SKAttribute__init(@"onload"); \
SKAttribute__init(@"onmousedown"); \
SKAttribute__init(@"onmousemove"); \
SKAttribute__init(@"onmouseout") \
SKAttribute__init(@"onmouseover"); \
SKAttribute__init(@"onmouseup")

// Conditional Processing attributes
// http://www.w3.org/TR/SVG11/intro.html#TermConditionalProcessingAttribute

/*
 Conditional Processing attributes notes
 =======================================
 
 *:  Currently ignored; Saved to string only.
 
 */

#define SKConditionalProcessingAttrib__interface() \
SKAttribute__property(NSArray, *requiredExtensions, *requiredFeatures, \
                               *systemLanguage)

#define SKConditionalProcessingAttrib__implementation() \
SKAttribute__arrayAccessor(requiredExtensions, setRequiredExtensions, \
                           @"requiredExtensions", @" "); \
SKAttribute__arrayAccessor(requiredFeatures, setRequiredFeatures, \
                           @"requiredFeatures", @" "); \
SKAttribute__arrayAccessor(systemLanguage, setSystemLanguage, \
                           @"systemLanguage", @" "); \

#define SKConditionalProcessingAttrib__initialize() \
SKAttribute__init(@"requiredExtensions"); \
SKAttribute__init(@"requiredFeatures"); \
SKAttribute__init(@"systemLanguage");

// Presentation attributes
// http://www.w3.org/TR/SVG11/intro.html#TermPresentationAttribute

/*
 Presentation attributes notes
 =============================
 
 flood-color: default should be current color, but is "inherit" instead
 flood-opacity: value could be (number | inherit) but is (number | nil)
 
 */

#define SKPresentationAttrib__interface() \
@property (readonly) NSDictionary *computedStyle;\
SKAttribute__property(SKColor, *color, *floodColor); \
SKAttribute__property(NSNumber, *floodOpacity)

#define SKPresentationAttrib__implementation() \
-(NSDictionary*)computedStyle{return nil;} /*incomplete*/ \
SKAttribute__accessor(color, setColor, SKColor*, @"color"); \
SKAttribute__accessor(floodColor, setFloodColor, SKColor*, @"flood-color"); \
SKAttribute__accessor(floodOpacity,setFloodOpacity, NSNumber*,@"flood-opacity")

#define SKPresentationAttrib__initialize() \
SKAttribute__init(@"color"); \
SKAttribute__init(@"flood-color"); \
SKAttribute__init(@"flood-opacity");
/*
 ‘font’
 ‘font-family’
 ‘font-size’
 ‘font-size-adjust’
 ‘font-stretch’
 ‘font-style’
 ‘font-variant’
 ‘font-weight’
 
 Text properties:
 ‘direction’
 ‘letter-spacing’
 ‘text-decoration’
 ‘unicode-bidi’
 ‘word-spacing’
 ‘clip’,
 ‘color’, 
 ‘cursor’
 ‘display’
 ‘overflow’,
 ‘visibility’,
 
 Clipping, Masking and Compositing properties:
 ‘clip-path’
 ‘clip-rule’
 ‘mask’
 ‘opacity’
 
 Filter Effects properties:
 ‘enable-background’
 ‘filter’
 ‘flood-color’
 ‘flood-opacity’
 ‘lighting-color’
 Gradient properties:
 ‘stop-color’
 ‘stop-opacity’
 Interactivity properties:
 ‘pointer-events’
 
 Color and Painting properties:
 ‘color-interpolation’
 ‘color-interpolation-filters’
 ‘color-profile’
 ‘color-rendering’
 ‘fill’
 ‘fill-opacity’
 ‘fill-rule’
 ‘image-rendering’
 ‘marker’
 ‘marker-end’
 ‘marker-mid’
 ‘marker-start’
 ‘shape-rendering’
 ‘stroke’
 ‘stroke-dasharray’
 ‘stroke-dashoffset’
 ‘stroke-linecap’
 ‘stroke-linejoin’
 ‘stroke-miterlimit’
 ‘stroke-opacity’
 ‘stroke-width’
 ‘text-rendering’
 
 Text properties:
 ‘alignment-baseline’
 ‘baseline-shift’
 ‘dominant-baseline’
 ‘glyph-orientation-horizontal’
 ‘glyph-orientation-vertical’
 ‘kerning’
 ‘text-anchor’
 ‘writing-mode’
 */


