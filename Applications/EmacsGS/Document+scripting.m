#import "Document.h"

@implementation Document(scripting)

- (void) sendCommand:(NSString*) cmd {
  if ([cmd length]) {
    const char *c = [cmd cString];
    [terminalView ts_sendCString:c];
  }
}

@end
