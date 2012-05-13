//
//  SVGKit.m
//  SVGKit
//
//  Created by Eric Man on 5/05/12.
//  Copyright (c) 2012 Sydney University. All rights reserved.
//
#import <stdarg.h>

#import "SVGKit.h"
#import "SVGKit+DOM.h"
/*
NSString* SKLiteralName[SKUnknownLiteral];

__attribute__((constructor))
static void initialize_SKLiteralName () {
    SKLiteralName[SKSpecified]= @"";
}

// Must Map to SKTransformMethod enum
NSUInteger SKTransformMaxArgCount[SKUnknownMethod] = {6,2,2,3,1,1};
NSUInteger SKTransformMinArgCount[SKUnknownMethod] = {6,1,1,1,1,1};
NSString*  SKTransformName[SKUnknownMethod] = 
    {@"matrix",@"translate",@"scale",@"rotate",@"skewX",@"skewY"};

// Must Map to SKUnit enum
NSString* SKUnitName[SKUnknownUnit] = 
    {@"",@"",@"%",@"em",@"ex",@"px",@"in",@"cm",@"mm",@"pt",@"pc",@"deg",@"grad"
        ,@"rad",@"hz",@"khz"};

// Must Map to SKAlign enum
//NSString* SKAlignName[SKUnknownAlign] =
//{@"none", @"xMinYMin", @"xMidYMin", @"xMaxYMin", @"xMinYMid", @"xMidYMid",
//    @"xMaxYMid", @"xMinYMax", @"xMidYMax", @"xMaxYMax"};


SKLiteralSet SKMakePreserveAspectRatio(BOOL defer, SKLiteral align, BOOL meet) {
    SKLiteralSet literalSet;
    if (defer) {
        SKSetLiteral(&literalSet, SKDefer);
    }
    if (meet) {
        SKSetLiteral(&literalSet, SKMeet);
    }
    else {
        SKSetLiteral(&literalSet, SKSlice);
    }
    SKSetLiteral(&literalSet, align);
    return literalSet;
}

struct SKTransform SKMakeTransform(SKTransformMethod method, double* values, 
                                   size_t count)
{
    if (method != SKUnknownMethod) {
        size_t max = SKTransformMaxArgCount[method];
        size_t min = SKTransformMinArgCount[method];
        assert(count >= min && count <= max);
    }
    struct SKTransform transform;
    transform.method = method;
    for (int i = 0; i < count; i++) {
        transform.values[i]=values[i];
    }
    transform.count = count;
    return transform;
}

struct SKQuantity SKMakeQuantity(double value, SKUnit unit)
{
    return (struct SKQuantity){value, unit};
}

NSUInteger SKMakeColor(uint8_t* arr, size_t size) 
{
    uint8_t v[4] = {0, 0, 0, 255}; // r g b a
    for (int i = 0; i < MIN(size, 4); i++) {
        v[i] = arr[i];
    }
    
    // c = r | g << 8 | b << 16 | << 24 
    // c >> 16 & 0xff // returns b
    
    NSUInteger value = v[0] | v[1] << 8 | v[2] << 16 | v[3] << 24;
    return value; 
}

NSString* SKStringFromColor(NSUInteger color) {
    uint8_t r, g, b;
    double a;
    r = color & 0xff;
    g = color >> 8 & 0xff;
    b = color >> 16 & 0xff;
    a = (color >> 24 & 0xff)/255;
    
    return [NSString stringWithFormat:@"rgba(%d,%d,%d,%f)", r, g, b, a];
}
            
NSString* SKStringFromPreserveAspectRatio(struct SKPreserveAspectRatio ratio) {

    NSMutableString *string = [SKAlignName[ratio.align] mutableCopy];
    if (ratio.defer) {
        [string insertString:@"defer " atIndex:0];
    }
    if (ratio.meet) {
        [string appendString:@"meet"];
    }
    else {
        [string appendString:@"slice"];
    }
    return string;
}

NSString* SKStringFromNumber(double value) 
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"%f", value];
    NSCharacterSet *z =[NSCharacterSet characterSetWithCharactersInString:@"0"];
    string = [[string stringByTrimmingCharactersInSet:z] mutableCopy];
    if ([string characterAtIndex:0] == '.') {
        [string insertString:@"0" atIndex:0];
    }
    if ([string characterAtIndex:[string length]-1] == '.') {
        [string deleteCharactersInRange:NSMakeRange([string length]-1, 1)];
    }
    return string;
}

NSString* SKStringFromUnit(SKUnit unit) 
{
    return SKUnitName[unit];
}

NSString* SKStringFromMethod(SKTransformMethod method) 
{
    return SKTransformName[method];
}


NSArray* SKArrayFromCArray(void** cArray, NSUInteger count)
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i; i < count; i++) {
        [array addObject:(id)cArray[i]];
    }
    return array;
}

NSString* SKStringFromTransform(struct SKTransform transform)
{
    NSMutableString *string = [@"" mutableCopy];
    [string appendString:SKStringFromMethod(transform.method)];
    [string appendString:@"("];
    NSArray *values = SKArrayFromCArray((void**)transform.values, 
                                        transform.count);
    [string appendString:SKStringFromNumberArray(values)];
    [string appendString:@")"];     
    return string;
}

NSString* SKStringFromQuantity(struct SKQuantity quantity)
{
    NSMutableString *string = [@"" mutableCopy];
    [string appendString:SKStringFromNumber(quantity.value)];
    [string appendString:SKStringFromUnit(quantity.unit)];
    return string;
}

NSString* SKStringFromTransformArray(NSArray* array) {
    return [array componentsJoinedByString:@" "];
}

NSString* SKStringFromNumberArray(NSArray* array) {
    return [array componentsJoinedByString:@","];
}

NSString* SKStringFromQuantityArray(NSArray* array) {
    return [array componentsJoinedByString:@","];
}

NSString* SKStringFromLiteral(SKLiteral literal) {
    if (literal < SKUnknownLiteral) {
        return SKLiteralName[literal];
    }
    return nil;
}

BOOL SKScanLiteral(NSScanner* scanner, SKLiteral *ptr) {
    NSUInteger location = [scanner scanLocation];
    SKScanWhitespaces(scanner, nil);
    for (SKLiteral u = 0; u < SKUnknownLiteral; u++) {
        if ([scanner scanString:SKLiteralName[u] intoString:nil]) {
            *ptr = u;
            return YES;
        }
    }
    [scanner setScanLocation:location];
    return NO;
}

BOOL SKScanWhitespaces(NSScanner* scanner, NSString** ptr)
{
    return [scanner scanCharactersFromSet:
            [NSCharacterSet whitespaceCharacterSet] 
                               intoString:ptr];
}

BOOL SKScanSeparator(NSScanner *scanner, NSString** ptr)
{
    NSUInteger location = [scanner scanLocation];
    NSString *wsp = @"";
    BOOL w = SKScanWhitespaces(scanner, &wsp);
    NSString *cma = @"";
    BOOL c = [scanner scanString:@"," intoString:&cma];
    if (w || c) {
        if (ptr) {
            *ptr = [NSString stringWithFormat:@"%@%@", wsp, cma];
        }
        return YES;
    }
    [scanner setScanLocation:location];
    return NO;
}

BOOL SKScanUnit(NSScanner* scanner, SKUnit* unit, SKUnit from, SKUnit to)
{
    SKScanWhitespaces(scanner, NULL);
    *unit = SKNumber;
    NSString *unitString;
    for (SKUnit u = from; u <= to; u++) {
        if ([scanner scanString:SKUnitName[u] intoString:&unitString]) {
            *unit = u;
            return YES;
        }
    }
    return NO;
}

BOOL SKScanNumber(NSScanner* scanner, double* value)
{
    SKScanWhitespaces(scanner, nil);
    return [scanner scanDouble:value];
}


BOOL SKScanPreserveAspectRatio(NSScanner* scanner, 
                               SKLiteraLSet *ptr) {
    NSUInteger location = [scanner scanLocation];
    struct SKPreserveAspectRatio ratio;
    BOOL wsp;
    SKScanWhitespaces(scanner, nil);
    ratio.defer = [scanner scanString:@"defer" intoString:NULL];
    wsp = SKScanWhitespaces(scanner, NULL);
    if (ratio.defer && !wsp) {
        [scanner setScanLocation:location];
        return NO;
    }
    BOOL foundAlign = NO;
    for (SKAlign u = 0; u < SKUnknownAlign; u++) {
        if ([scanner scanString:SKAlignName[u] intoString:NULL]) {
            ratio.align = u;
            foundAlign = YES;
            break;
        }
    }
    if (!foundAlign) { // align is mandatory
        [scanner setScanLocation:location];
        return NO;
    }
    location = [scanner scanLocation];
    wsp = SKScanWhitespaces(scanner, NULL);
    if (wsp) {
        BOOL meet, slice;
        if ((meet = [scanner scanString:@"meet" intoString:NULL])) {}
        else if ((slice = ![scanner scanString:@"slice" intoString:NULL])) {}
        if (meet) ratio.meet = YES;
        if (!meet && !slice) {
            [scanner setScanLocation:location]; // undo read wsp
        }
    }
    *ptr = ratio;
    return YES;
}

BOOL SKScanQuantity(NSScanner* scanner, struct SKQuantity* ptr, SKUnit from, 
                    SKUnit to)
{
    SKScanWhitespaces(scanner, nil);
    struct SKQuantity quantity = SKMakeQuantity(0, SKNumber);
    if (!SKScanNumber(scanner, &quantity.value)) return NO;
    SKScanUnit(scanner, &quantity.unit, from, to);
    *ptr = quantity;
    return  YES;
}


BOOL SKScanMethod(NSScanner *scanner, SKTransformMethod *method) 
{
    SKScanWhitespaces(scanner, nil);
    SKTransformMethod init = SK_TRANSFORM_METHOD_FIRST;
    SKTransformMethod last = SK_TRANSFORM_METHOD_LAST;
    for (SKTransformMethod i = init; i <= last; i++) {
        if ([scanner scanString:SKTransformName[i] intoString:nil]) {
            *method = i;
            return YES;
        }
    }
    return NO;
}


BOOL SKScanColor(NSScanner* scanner, NSUInteger *ptr) {
    // does not support keywords yet
    // inherit, rgb(...) or rgba(...)
    
    NSUInteger location = [scanner scanLocation];
    SKScanWhitespaces(scanner, NULL);
    NSUInteger valuesToScan = 0;
    NSArray* values;
    if ([scanner scanString:@"rgba" intoString:nil]) {
        valuesToScan = 4;
    }
    else if ([scanner scanString:@"rgb" intoString:nil]) {
        valuesToScan = 3;
    }
    else {
        [scanner setScanLocation:location];
        return NO;
    }
    
    SKScanWhitespaces(scanner, NULL);
    if (![scanner scanString:@"(" intoString:nil]) {
        [scanner setScanLocation:location];
        return NO;
    }
    
    SKScanNumberArray(scanner, &values);
    NSUInteger count = [values count];
    if (count != valuesToScan) {
        [scanner setScanLocation:location];
        return NO;
    }
    
    const NSUInteger alphaIndex = 3;
    uint8_t chars[4];
    
    for (int i = 0; i < count; i++) {
        if (i != alphaIndex) {
            chars[i] = [[values objectAtIndex:i] intValue];
        }
        else {
            chars[alphaIndex] = [[values objectAtIndex:i] doubleValue] * 255;
        }
    }
    
    if (![scanner scanString:@")" intoString:nil]) {
        [scanner setScanLocation:location];
        return NO;
    }
    
    *ptr = SKMakeColor(chars, 4);
    
    return YES;
}


BOOL SKScanTransform(NSScanner *scanner, struct SKTransform *ptr)
{
    NSUInteger location = [scanner scanLocation];
    SKScanWhitespaces(scanner, NULL);
    struct SKTransform transform;
    if (!SKScanMethod(scanner, &transform.method)) {
        [scanner setScanLocation:location];
        return NO;
    }
    if (![scanner scanString:@"(" intoString:nil]) {
        [scanner setScanLocation:location];
        return NO;
    }
    NSArray *values;
    SKScanNumberArray(scanner, &values);
    NSUInteger count = [values count];
    NSUInteger max = SKTransformMaxArgCount[transform.method];
    NSUInteger min = SKTransformMinArgCount[transform.method];
    for (int i = 0; i < max; i++) {
        if (i < count) {
            transform.values[i] = [[values objectAtIndex:i] doubleValue];
        }
        else {
            transform.values[i] = 0;
        }
    }
    if (count > max || count < min) {
        SKWarn(@"Transform method incorrect number of arguments (%d) "
               @"for method %@; "
               @"expected between %d and %d", count, min, max);
    }
    transform.count = count;
    SKScanWhitespaces(scanner, NULL);
    if (![scanner scanString:@")" intoString:nil]) {
        [scanner setScanLocation:location];
        return NO;
    }
    *ptr = transform;
    return YES;
}

BOOL SKScanLength(NSScanner *scanner, struct SKQuantity* quantity) {
    return SKScanQuantity(scanner, quantity, 
                          SK_LENGTH_UNIT_FIRST, SK_LENGTH_UNIT_LAST);
}

BOOL SKScanAngle(NSScanner *scanner, struct SKQuantity* quantity) {
    return SKScanQuantity(scanner, quantity, 
                          SK_ANGLE_UNIT_FIRST, SK_ANGLE_UNIT_LAST);
}

BOOL SKScanFrequency(NSScanner *scanner, struct SKQuantity* quantity) {
    return SKScanQuantity(scanner, quantity, 
                          SK_FREQUENCY_UNIT_FIRST, SK_FREQUENCY_UNIT_LAST);
}

void SKScanArray(NSScanner *scanner, NSArray **arr, 
                 BOOL (*action)(NSScanner*,NSMutableArray*,void**),void** args)
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:4];
    BOOL first = YES;
    while (true) {
        NSUInteger location = [scanner scanLocation];
        if (!first && !SKScanSeparator(scanner, nil)) {
            break;
        }
        first = NO;
        SKScanWhitespaces(scanner, nil);
        if (action(scanner, array, args)) {
            continue;
        }
        [scanner setScanLocation:location];
        break;
    }
    *arr = [array copy];
    [array release];
}

BOOL SKScanNumberIntoArray(NSScanner *scanner, NSMutableArray *array, 
                           void**args)
{
    double value;
    if (SKScanNumber(scanner, &value)) {
        [array addObject:[NSNumber numberWithDouble:value]];
        return YES;
    }
    return NO;
}

void SKScanNumberArray(NSScanner *scanner, NSArray **arr)
{
    return SKScanArray(scanner, arr, SKScanNumberIntoArray, NULL);
}

BOOL SKScanStringIntoArray(NSScanner *scanner, NSMutableArray *array, 
                           void**args)
{
    NSCharacterSet *characterSet = args[0];
    
    NSString* value;
    if ([scanner scanCharactersFromSet:characterSet intoString:&value]) {
        [array addObject:value];
        return YES;
    }
    return NO;
}

void SKScanStringArray(NSScanner *scanner, NSArray **arr, NSCharacterSet *set)
{
    void* args[1] = {set};
    return SKScanArray(scanner, arr, SKScanStringIntoArray, args);
}

BOOL SKScanQuantityIntoArray(NSScanner *scanner, NSMutableArray* array, 
                             void** args)
{
    SKUnit from = (SKUnit)args[0];
    SKUnit to = (SKUnit)args[1];
    Class target = (Class)args[2];
    SEL selector = (SEL)args[3];
    
    struct SKQuantity quantity;
    if (SKScanQuantity(scanner, &quantity, from, to)){
        id object = [target performSelector:selector 
                                 withObject:(id)&quantity];
        [array addObject:object];
        return YES;
    }
    return NO;
}

void SKScanQuantityArray(NSScanner *scanner, NSArray **arr, SKUnit from, 
                               SKUnit to, id target, SEL selector)
{
    void* args[4] = {(void*)from, (void*)to, (void*)target, (void*)selector};
    return SKScanArray(scanner, arr, SKScanQuantityIntoArray, args);
}

BOOL SKQuantityEqualToQuantity(struct SKQuantity a, struct SKQuantity b)
{
    return a.value == b.value && a.unit == b.unit;
}

BOOL SKQuantityIsLength(struct SKQuantity q) {
    return (q.unit >= SK_LENGTH_UNIT_FIRST && q.unit <= SK_LENGTH_UNIT_LAST) 
    || q.unit == SKNumber;
}
BOOL SKQuantityIsAngle(struct SKQuantity q) {
    return (q.unit >= SK_ANGLE_UNIT_FIRST && q.unit <= SK_ANGLE_UNIT_LAST)
    || q.unit == SKNumber;
}
BOOL SKQuantityIsFrequency(struct SKQuantity q) {
    return (q.unit>=SK_FREQUENCY_UNIT_FIRST && q.unit<=SK_FREQUENCY_UNIT_LAST) 
    || q.unit == SKNumber;
}

BOOL SKScanTransformIntoArray(NSScanner *scanner, NSMutableArray* array, 
                              void** args)
{
    struct SKTransform transform;
    if (SKScanTransform(scanner, &transform)) {
        [array addObject:[SKTransform transformWithTransform:transform]];
        return YES;
    }
    return NO;
}

void SKScanTransformArray(NSScanner *scanner, NSArray **arr)
{
    return SKScanArray(scanner, arr, SKScanTransformIntoArray, NULL);
}

void SKScanLengthArray(NSScanner *scanner, NSArray **arr)
{
    return SKScanQuantityArray(scanner, arr, 
                               SK_LENGTH_UNIT_FIRST, SK_LENGTH_UNIT_LAST, 
                               [SKLength class],@selector(lengthWithQuantity:));
}

void SKScanAngleArray(NSScanner *scanner, NSArray **arr)
{
    return SKScanQuantityArray(scanner, arr, 
                               SK_ANGLE_UNIT_FIRST, SK_ANGLE_UNIT_LAST, 
                               [SKAngle class], @selector(angleWithQuantity:));
}

void SKScanFrequencyArray(NSScanner *scanner, NSArray **arr)
{
    return SKScanQuantityArray(scanner, arr, 
                               SK_FREQUENCY_UNIT_FIRST, SK_FREQUENCY_UNIT_LAST, 
                               [SKFrequency class], 
                               @selector(frequencyWithQuantity:));
}

*/