//
//  SKCoreAttribTests.m
//  SVGKit
//
//  Created by Eric Man on 10/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//

#import "SKCoreAttribTests.h"
#import "SKDocument.h"
#import "SKRoot.h"
#import "SVGKit.h"

@implementation SKCoreAttribTests

// All code under test must be linked into the Unit Test bundle
- (void)testIdentifier
{
    NSString *svg = @"<svg id=\"hello\"/>";
    SKDocument *document = [[SKDocument alloc]initWithSVGString:svg
                                                          error:nil];
    SKRoot *root = document.root;
    //STAssertEqualObjects(root.identifier, @"hello", @"");
    //STAssertEquals(root.zoomAndPan, SKMagnifyZoomAndPan, @"");
}

@end
