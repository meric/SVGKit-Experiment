#import <Foundation/Foundation.h>

// All literals in SVG specification.
typedef enum SKLiteral { {% for lit in literals %}
  {{ lit.cstr() }},{% endfor %}
  SKUndefined
} SKLiteral;

BOOL SKScanArray(NSScanner* scanner, NSArray** ptr, 
                 BOOL (*SKScanFN)(NSScanner*,id*), NSArray* valid);
BOOL SKScanLiteral(NSScanner* scanner, SKLiteral* ptr, SKLiteral* valid);

BOOL SKScanWhitespaces(NSScanner*, NSString**);
BOOL SKScanSeparator(NSScanner *scanner, NSString**);
BOOL SKScanNumber(NSScanner *scanner, NSNumber**);
BOOL SKScanDouble(NSScanner *scanner, double*);
BOOL SKScanString(NSScanner *scanner, NSString**);

BOOL SKScanNumberArray(NSScanner* scanner, NSArray** ptr);
BOOL SKScanStringArray(NSScanner* scanner, NSArray** ptr);

// All literal strings. (Must map to enum SKLiteral)
NSString* SKLiteralString[SKUndefined];
{% for ltype in ltypes %}
BOOL {{ltype.fstr()}}(NSScanner*, SKLiteral*);{% endfor %}

{% for ctype in ctypes %}
@interface {{ctype.tstr()}} : NSObject { {% for ivar in ctype.ivars() %}
  {{ivar.tstr()}} {{ivar.nstr()}};{% endfor %}
};

{% for ivar in ctype.ivars() %}@property {% if ivar.ptr() %}(nonatomic,retain){% endif %}{{ivar.tstr()}} {{ivar.nstr()}};
{% endfor %}@end

BOOL {{ctype.fstr()}}(NSScanner*, {{ctype.tstr()}}** ptr);
BOOL {{ctype.fstr()}}Array(NSScanner*, NSArray** ptr);
{% endfor %}
