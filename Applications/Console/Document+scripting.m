#import "Document.h"

@implementation Document(scripting)

- (void) mark:(id) sender {
  [terminalView mark:sender];
}

- (void) clear:(id) sender {
  [terminalView clear:sender];
}

- (void) appendToTiveConsole:(NSString*) txt {
  [terminalView appendToTiveConsole:txt];
}

- (void) writeToTiveConsole:(NSString*) txt {
  [terminalView writeToTiveConsole:txt];
}

- (NSString*) liveConsolePath {
  return [terminalView liveConsolePath];
}

@end
