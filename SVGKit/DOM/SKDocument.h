//
//  SKDocument.h
//  SVGKit
//
//  Created by Eric Man on 5/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKNode.h"

@class SKRoot;

@interface SKDocument : NSObject<SKNode>
{
    @protected
    NSXMLDocument *_document;
    SKRoot   *_root;
}

@property (retain) SKRoot *root;

/*!
 @method initWithXMLDocument:error:
 @abstract Returns a document created an instance of NSXMLDocument. NSXMLDocument problems such as 404, parse errors are returned in <tt>error</tt>.
 */
- (id)initWithXMLDocument:(NSXMLDocument *)document error:(NSError **)error;

/*!
 @method initWithSVGString:error:
 @abstract Returns a SVG document created from either XML. Parse errors are returned in <tt>error</tt>.
 */
- (id)initWithSVGString:(NSString *)string error:(NSError **)error;

/*!
 @method initWithContentsOfURL:error:
 @abstract Returns a document created from the contents of an XML. Connection problems such as 404, parse errors are returned in <tt>error</tt>.
 */
- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)error;

/*!
 @method initWithData:error:
 @abstract Returns a document created from data. Parse errors are returned in <tt>error</tt>.
 */
- (id)initWithData:(NSData *)data error:(NSError **)error; //primitive

/*!
 @method initWithRootElement:
 @abstract Returns a document with a single child, the root element.
 */
- (id)initWithRoot:(SKRoot *)element;

#if 0
#pragma mark --- Properties ---
#endif

/*!
 @method setRoot:
 @abstract Set the root element.
 */
- (void)setRoot:(SKRoot *)root;

/*!
 @method root
 @abstract The root element.
 */
- (SKRoot *)root;

#if 0
#pragma mark --- Output ---
#endif

/*!
 @method SVGData
 @abstract Returns the XML data for the SVG document.
 */
- (NSData *)SVGData;

@end
