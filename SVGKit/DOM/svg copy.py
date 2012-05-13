import re, csv, textwrap

H_HEADER ="""
#import <Foundation/Foundation.h>

BOOL SKScanWhitespaces(NSScanner*, NSString**);
BOOL SKScanSeparator(NSScanner *scanner, NSString**);
BOOL SKScanNumber(NSScanner *scanner, NSNumber**);
BOOL SKScanDouble(NSScanner *scanner, double*);
BOOL SKScanString(NSScanner *scanner, NSString**);
    
"""

M_HEADER="""
#import "SVGKit+DOM.h"
BOOL SKScanString(NSScanner *scanner, NSString **ptr)
{
    NSCharacterSet *characterSet = 
    [[NSCharacterSet characterSetWithCharactersInString:@", \t"] invertedSet];
    NSString* value;
    if ([scanner scanCharactersFromSet:characterSet intoString:&value]) {
        *ptr = value;
        return YES;
    }
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
BOOL SKScanNumber(NSScanner* scanner, NSNumber** num)
{
  double value;
  SKScanWhitespaces(scanner, nil);
  BOOL s = [scanner scanDouble:&value];
  if (s) {
    *num = [NSNumber numberWithDouble:value];
  }
  return s;
}
BOOL SKScanDouble(NSScanner* scanner, double* value)
{
    SKScanWhitespaces(scanner, nil);
    return [scanner scanDouble:value];
}
"""
LITERAL_LIST = []
LITERAL_DICT = {}

LTYPE_LIST = []
LTYPE_DICT = {}

STYPE_LIST = []
STYPE_DICT = {}

ATTR_DICT = {}

COMMAND_DICT = {}

PREFIX = "SK"
UNDEFINED = "SKUndefined"

def main():
  file = open("svg.ssv", "r, b")
  for row in csv.reader(file, delimiter=" "):
    if len(row):
      cmd = row[0]
      if cmd in COMMAND_DICT:
        COMMAND_DICT[cmd](row[1:])
  file.close()
  LITERAL_LIST.sort(key=lambda x:x.cName)
  Literal("undefined")
  h, m = cstring()
  save("SVGKit+DOM.h", h)
  save("SVGKit+DOM.m", m)
  h = cattribute()
  save("SVGKit+Attribute.h", h)

def cattribute():
  content = "static NSDictionary *scannerForAttribute;\n"
  objects = ""
  for a in ATTR_DICT:
    refName = ATTR_DICT[a];
    objects += ("[NSNumber numberWithUnsignedLong:(size_t)" +
                STYPE_DICT[refName].function+"],@\"" + a + "\",\n    ")
  content += """
__attribute__((constructor))
static void initialize_scannerForAttribute() {{
  scannerForAttribute = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
    {objects}nil];
}}
__attribute__((destructor))
static void destroy_scannerForAttribute() {{
  [scannerForAttribute release];
}}

""".format(objects=objects)
  return content

def cstring():
  arrayItems = ", ".join([str(lit) for lit in LITERAL_LIST])
  stringItems = ", ".join(["@\""+lit.svgName+"\"" for lit in LITERAL_LIST[:-1]])
  arrayItems = "\n  ".join(textwrap.wrap(arrayItems, 78))
  stringItems = "\n  ".join(textwrap.wrap(stringItems, 78))
  literal_hstring = ("""
// All literals in SVG specification.
typedef enum SKLiteral {{
  {arrayItems}
}} SKLiteral;

// All literal strings. (Must map to enum SKLiteral)
NSString* SKLiteralString[{undefined}];
""".format(undefined=UNDEFINED,arrayItems=arrayItems,stringItems=stringItems))
  literal_mstring = ("""
NSString* SKLiteralString[{undefined}] = {{
{stringItems}
}};
""".format(undefined=UNDEFINED,arrayItems=arrayItems,stringItems=stringItems))
  ltype_cstrings = [ltype.cstring() for ltype in LTYPE_LIST]
  ltype_hstring = "".join([str(c[0]) for c in ltype_cstrings])
  ltype_mstring = "".join([str(c[1]) for c in ltype_cstrings])

  stype_cstrings = [stype.cstring() for stype in STYPE_LIST]
  stype_hstring = "".join([str(c[0]) for c in stype_cstrings])
  stype_mstring = "".join([str(c[1]) for c in stype_cstrings])
  h = H_HEADER + literal_hstring + ltype_hstring + stype_hstring
  m = M_HEADER + literal_mstring + ltype_mstring + stype_mstring
  return (h, m)

def save(name, string):
  file = open(name, "w")
  file.write("// autogenerated\n")
  file.write(string)
  file.close()

def translate(svgName):
  cap = lambda s:s[0].upper()+s[1:]
  return "".join(map(cap, svgName.split("-")))

def error(message):
  print message
  exit()

class Literal:
  def __init__(self, svgName, cName=None):
    self.svgName=svgName
    self.cName=cName
    if not cName:
      self.cName = PREFIX+translate(svgName)
    LITERAL_LIST.append(self)
    LITERAL_DICT[self.svgName] = self
  def __str__(self):
    return self.cName

class LType:
  def __init__(self, refName, literals):
    self.cType = "SKLiteral"
    self.default = "undefined"
    if not literals:
      error("Type.__init__: empty literals")
    refName__default = refName.split("=")
    if len(refName__default) > 1:
      refName = refName__default[0]
      self.default = refName__default[1]
    else:
      self.default = "undefined"
    self.refName = refName
    self.literals = literals
    self.kind = ""
    self.object = ""
    names = self.refName.split(".")
    if len(names) > 1:
      self.kind, self.object = names
      self.kind = translate(self.kind)
    else:
      self.object = refName
    self.object = translate(self.object)
    self.function = PREFIX+"Scan"+self.object
    if self.kind:
      self.function+="For"+self.kind
    if self.refName in LTYPE_DICT:
      LTYPE_DICT[self.refName].literals += self.literals
    else:
      LTYPE_LIST.append(self)
      LTYPE_DICT[self.refName] = self
  def cstring(self):
    array=PREFIX+translate(re.sub("[.]", "__", self.refName))+"Literals"
    arrayItems=",\n  ".join([str(LITERAL_DICT[lit]) for lit in self.literals])
    undefined=UNDEFINED
    return ("""

// Scan a {kind} {object} literal.
BOOL {function}(NSScanner*, SKLiteral*);
""".format(array=array,
           arrayItems=arrayItems,
           function=self.function,
           kind=self.kind,
           object=self.object,
           undefined=UNDEFINED,
           stringArray=PREFIX+"LiteralString"),
           """
// {kind} {object} literals.
SKLiteral {array}[] = {{
  {arrayItems},
  {undefined}
}};
BOOL {function}(NSScanner* scanner, SKLiteral* ptr) {{
  NSUInteger location = scanner.scanLocation;
  SKScanWhitespaces(scanner, nil);
  int i = 0;
  while({array}[i] != {undefined}) {{
    NSString *s = {stringArray}[{array}[i]];
    if ([scanner scanString:s intoString:nil]) {{
      *ptr = {array}[i];
      return YES;
    }}
    i++;
  }}
  scanner.scanLocation = location;
  return NO;
}}
""".format(array=array,
           arrayItems=arrayItems,
           function=self.function,
           kind=self.kind,
           object=self.object,
           undefined=UNDEFINED,
           stringArray=PREFIX+"LiteralString"))

class STypeBranch:
  def __init__(self, sType, refName, grammar):
    self.refName = refName
    self.grammar = grammar
    self.sType=sType
    for g in grammar:
      if g[0]=="{" and g[len(g)-1] == "}":
        g = g[1:-1]
        key, type_name = g.split(":")
        # process type_name
        if "[" in type_name and "]" in type_name:
          match = re.match("(.+)\\[(.*)\\]", type_name)
          sType.ivars[key] = "NSArray*"
          sType.types[key] = match.group(1)
          continue
        elif "==" in type_name:
          type_name, equals = type_name.split("==")

        if type_name in LTYPE_DICT:
          sType.ivars[key] = LTYPE_DICT[type_name].cType
        elif type_name in STYPE_DICT:
          sType.ivars[key] = STYPE_DICT[type_name].cType
        elif type_name == "double":
          sType.ivars[key] = "double"
        elif type_name == "number":
          sType.ivars[key] = "NSNumber*"
        elif type_name == "string":
          sType.ivars[key] = "NSString*"
        else:
          error("STypeBranch.__init__ bad type " + type_name)
        sType.types[key] = type_name
  @classmethod
  def function_for_type(self, type_name):
    if type_name in LTYPE_DICT:
      return LTYPE_DICT[type_name].function
    elif type_name in STYPE_DICT:
      return STYPE_DICT[type_name].function
    elif type_name == "double":
      return "SKScanDouble"
    elif type_name == "number":
      return "SKScanNumber"
    elif type_name == "string":
      return "SKScanString"
  
  @classmethod
  def cType_for_type(self, type_name):
    if type_name in LTYPE_DICT:
      return LTYPE_DICT[type_name].cType
    elif type_name in STYPE_DICT:
      return STYPE_DICT[type_name].cType
    elif type_name == "double":
      return "double"
    elif type_name == "number":
      return "NSNumber*"
    elif type_name == "string":
      return "NSString*"

  def content(self):
    lines = []
    i = 0;
    for g in self.grammar:
      if g[0]=="{" and g[len(g)-1] == "}":
        g = g[1:-1]
        key, type_name = g.split(":")
        # process type_name
        if "[" in type_name and "]" in type_name:
          match = re.match("(.+)\\[(.*)\\]", type_name)
          valid_lengths = match.group(2).split(",");
          type_name = match.group(1)
          check_content = []
          if len(valid_lengths) and len(valid_lengths[0]):
            for length in valid_lengths:
              check_content += ["case " + length + ": b"+str(i)+"=YES; break;"]
          check_content = "\n      ".join(check_content)
          type = STypeBranch.cType_for_type(type_name)
          check = ""
          if valid_lengths:
            check = """
    switch([array{0} count]) {{
      {check_content}
    }}
  """.format(i, check_content=check_content)
          lines += ["""
    BOOL b{0};
    NSMutableArray *array{0} = [[NSMutableArray alloc] init];
    {{
      BOOL first = YES;
      while (true) {{
        NSUInteger location = [scanner scanLocation];
        if (!first && !SKScanSeparator(scanner, nil)) {{
            break;
        }}
        first = NO;
        SKScanWhitespaces(scanner, nil);
        {type} object;
        if ({function}(scanner, &object)) {{
            [array{0} addObject:object];
            continue;
        }}
        [scanner setScanLocation:location];
        break;
      }}
    }}
    {check}
    result.{key} = array{0};
    [array{0} release];
""".format(i, function = STypeBranch.function_for_type(type_name),
           type = type,
           key = key,
           check=check)]

          i+=1;
          continue

        if "==" in type_name:
          type_name, equals = type_name.split("==")
          ctype = STypeBranch.cType_for_type(type_name)
          cname = LITERAL_DICT[equals].cName
          if type_name not in LTYPE_DICT:
            error("Only LTYPE can use == operator")
          function = STypeBranch.function_for_type(type_name)
          lines += ["""
    {type} item{0};
    BOOL b{0} = {function}(scanner, &item{0});
    if (item{0} != {cname}) b{0} = NO;
    result.{key} = item{0};
""".format(i, type=ctype, function = function,cname = cname,key=key)]
          i+=1
          continue;

        # no operator
        ctype = STypeBranch.cType_for_type(type_name)
        
        function = STypeBranch.function_for_type(type_name)
        lines += ["""
    {type} item{0};
    BOOL b{0} = {function}(scanner, &item{0});
    result.{key} = item{0};
""".format(i, type=ctype, function = function,key=key)]
        i+=1
        continue;
      else:
        lines += ["""BOOL b{0} = [scanner scanString:@"{1}" intoString:nil];""".format(i,g)]
        i += 1;
    check_str = """
    if ({bools}) {{
      *ptr = result;
      return YES;
    }}
""".format(bools = " && ".join(map(lambda x: "b"+str(x), range(0, i))))
    return "\n    ".join(lines) + check_str

  def __str__(self):
    content = self.content()
    return ("""
  {{
    NSUInteger location = [scanner scanLocation];
    {type}* result = [[[{type} alloc] init] autorelease];
    {content}
    scanner.scanLocation = location;
  }}
""".format(content=content, type=self.sType.cType[:-1]))

class SType:
  def __init__(self, refName, grammar):
    if not grammar:
      error("SType.__init__: empty grammar")
    self.ivars = {}
    self.types = {}
    self.struct = PREFIX + translate(refName)
    self.cType = self.struct+"*"
    self.refName = refName
    self.function = PREFIX+"Scan"+translate(refName)
    self.branches = []
    if refName in STYPE_DICT:
      STYPE_DICT[refName].add(STypeBranch(STYPE_DICT[refName], refName, grammar))
      return
    else:
      STYPE_LIST.append(self)
      STYPE_DICT[self.refName] = self
      self.add(STypeBranch(self, refName, grammar))

  def add(self, branch):
    self.branches.append(branch)

  def cstring(self):
    ivars = []
    props = []
    syns = []
    deallocs=[]
    inits = []
    for ivar in self.ivars:
      ivars += [self.ivars[ivar]+" "+ivar + ";"]
      if "*" in self.ivars[ivar]:
        props += ["@property (nonatomic,retain) "+self.ivars[ivar]+" "+ivar+";"]
        deallocs += ["self."+ivar + "=" + "nil;"]
      else:
        props += ["@property "+self.ivars[ivar]+" "+ivar+";"]
      if self.ivars[ivar] == PREFIX+"Literal":
        inits +=["  "+ivar+"="+LITERAL_DICT[LTYPE_DICT[self.types[ivar]].default].cName+";"]
      syns+= ["@synthesize " + ivar+";"];
    ivars = "\n  ".join(ivars)
    props = "\n".join(props)
    syns = "\n".join(syns)
    deallocs = "\n  ".join(deallocs)
    inits = "\n  ".join(inits)
    body = "".join([str(b) for b in self.branches])
    return ("""
// {struct}
@interface {struct} : NSObject {{
  {ivars}
}};
{props}
@end

BOOL {function}(NSScanner* scanner, {struct}** ptr);
""".format(struct = self.struct, 
           body=body, 
           function=self.function, 
           ivars=ivars,
           props=props,
           syns=syns,
           inits=inits,
           deallocs=deallocs),
      """
// {struct}
@implementation {struct}
{syns}

- (id)init {{
  self = [super init];
  if (self) {{
    {inits}
  }}
  return self;
}}

- (void)dealloc {{
  {deallocs}
  [super dealloc];
}}

@end

BOOL {function}(NSScanner* scanner, {struct}** ptr) {{
  NSUInteger location = [scanner scanLocation];
  SKScanWhitespaces(scanner, nil);
  {body}
  scanner.scanLocation = location;
  return NO;
}}
""".format(struct = self.struct, 
           body=body, 
           function=self.function, 
           ivars=ivars,
           props=props,
           syns=syns,
           inits=inits,
           deallocs=deallocs))

def run_literal(parameters):
  for parameter in parameters:
    pair = parameter.split(",")
    if len(pair) > 1:
      Literal(pair[0], cName=pair[1])
    elif len(pair) == 1:
      Literal(pair[0])
    else:
      error("run_literal: empty literal")

COMMAND_DICT["literal"] = run_literal

def run_ltype(parameters):
  refName = parameters[0];
  parameters = parameters[1:]
  LType(refName, parameters)
COMMAND_DICT["ltype"] = run_ltype

def run_type(parameters):
  refName = parameters[0];
  parameters = parameters[1:]
  SType(refName, parameters)
COMMAND_DICT["type"] = run_type

def run_attribute(parameters):
  attr = parameters[0]
  refName = parameters[0]+"Attribute";
  parameters = parameters[1:]
  SType(refName, parameters)
  ATTR_DICT[attr] = refName
COMMAND_DICT["attribute"] = run_attribute

def run_alias(parameters):
  attr = parameters[0];
  refName = parameters[1]
  ATTR_DICT[attr] = refName
COMMAND_DICT["alias"] = run_alias
  
if __name__=="__main__":
  main()



