//
//  SKNode.h
//  SVGKit
//
//  Created by Eric Man on 5/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKNode 

#if 0

#pragma mark --- Output ---
#endif

+ (NSString *)name;

/*!
 @method description
 @abstract Used for debugging. May give more information than XMLString.
 */
- (NSString *)description;

/*!
 @method XMLString
 @abstract The representation of this node as it would appear in an XML document.
 */
- (NSString *)XMLString;


@end
